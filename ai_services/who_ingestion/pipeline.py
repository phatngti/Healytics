"""
pipeline.py — Orchestrator end-to-end ingest WHO.

Luồng cho MỖI publication:
  crawl metadata → tải PDF tạm (staging) → extract text
  → chunk token → embed → index OpenSearch → xóa PDF local

S3 là tuỳ chọn (chỉ bật khi có S3_BUCKET). Mặc định chỉ cần OpenSearch.

Cách chạy:
  cd ai_services
  python -m who_ingestion.pipeline --all
  python -m who_ingestion.pipeline --domain nutrition --limit 5
  python -m who_ingestion.pipeline --from-manifest data/staging/who/manifest.json
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from who_ingestion.chunker import chunk_text_by_tokens
from who_ingestion.config import WhoIngestionSettings, load_settings
from who_ingestion.crawler import WhoPublication, WhoPublicationCrawler
from who_ingestion.domains import WHO_DOMAINS, all_domain_keys
from who_ingestion.elasticsearch_ingest import WhoElasticsearchIngestor
from who_ingestion.pdf_extractor import extract_pdf_text
from who_ingestion.s3_storage import WhoS3Storage


def _validate_settings(settings: WhoIngestionSettings) -> list[str]:
    """Chỉ bắt buộc OpenSearch; S3 tuỳ chọn."""
    missing: list[str] = []
    if not settings.elasticsearch_enabled:
        missing.append("ELASTICSEARCH_URL")
    if settings.s3_enabled and not (
        (settings.aws_access_key_id and settings.aws_secret_access_key)
        or Path.home().joinpath(".aws/credentials").exists()
    ):
        missing.append(
            "AWS credentials (cần khi bật S3_BUCKET — hoặc để trống S3_BUCKET để bỏ S3)"
        )
    return missing


def _publication_from_dict(data: dict) -> WhoPublication:
    """Đọc lại metadata từ manifest.json."""
    return WhoPublication(
        domain=data["domain"],
        keyword=data.get("keyword", ""),
        title=data.get("title", ""),
        source_url=data.get("source_url", ""),
        pdf_url=data.get("pdf_url", ""),
        publication_id=data.get("publication_id", ""),
    )


def _delete_local_pdf(pdf_path: Path, *, staging_dir: Path) -> None:
    """Xóa vĩnh viễn PDF tạm và thư mục rỗng phía trên (không đụng manifest)."""
    if not pdf_path.exists():
        return
    pdf_path.unlink()
    print(f"🗑️  Đã xóa file local: {pdf_path}")

    # Dọn thư mục domain/pdfs rỗng (giữ staging_dir + manifest.json)
    pdfs_root = staging_dir / "pdfs"
    parent = pdf_path.parent
    while parent != pdfs_root and pdfs_root in parent.parents:
        try:
            parent.rmdir()
            parent = parent.parent
        except OSError:
            break


def process_publication(
    publication: WhoPublication,
    *,
    settings: WhoIngestionSettings,
    crawler: WhoPublicationCrawler,
    s3: WhoS3Storage | None,
    ingestor: WhoElasticsearchIngestor | None,
    staging_dir: Path,
) -> int:
    """
    Xử lý 1 PDF WHO — trả về số chunk đã index.

    PDF chỉ tồn tại tạm trên máy để đọc/chunk; sau khi index ES thành công sẽ bị xóa.
    """
    pdf_dir = staging_dir / "pdfs" / publication.domain
    pdf_path = crawler.download_pdf(publication, pdf_dir)

    s3_key = ""
    if s3 is not None:
        object_key = s3.build_object_key(
            publication.domain,
            publication.publication_id,
            pdf_path.name,
        )
        if not s3.object_exists(object_key):
            s3.upload_file(pdf_path, object_key)
        s3_key = object_key

    text = extract_pdf_text(pdf_path)
    chunks = chunk_text_by_tokens(
        text,
        doc_id=publication.publication_id,
        domain=publication.domain,
        title=publication.title,
        source_url=publication.source_url,
        s3_key=s3_key,
        settings=settings,
        content_en=text,
    )

    indexed = 0
    if ingestor is not None:
        indexed = ingestor.ingest_chunks(chunks)

    if settings.delete_local_after_ingest and ingestor is not None:
        _delete_local_pdf(pdf_path, staging_dir=staging_dir)

    return indexed if ingestor is not None else len(chunks)


def run_pipeline(
    *,
    domain: str | None = None,
    limit: int | None = None,
    manifest_path: Path | None = None,
    settings: WhoIngestionSettings | None = None,
) -> dict:
    """Entry point chính — gọi từ CLI hoặc script test."""
    settings = settings or load_settings()
    missing = _validate_settings(settings)
    if missing:
        raise RuntimeError(
            "Thiếu cấu hình: "
            + ", ".join(missing)
            + ". Xem who_ingestion/.env.example"
        )

    staging_dir = Path(settings.staging_dir)
    staging_dir.mkdir(parents=True, exist_ok=True)

    crawler = WhoPublicationCrawler(settings)
    s3 = WhoS3Storage(settings) if settings.s3_enabled else None
    ingestor = WhoElasticsearchIngestor(settings)
    ingestor.ensure_index()

    if s3 is None:
        print("ℹ️  S3 tắt — chỉ crawl → OpenSearch (PDF local sẽ xóa sau khi index)")
    if settings.delete_local_after_ingest:
        print("ℹ️  WHO_DELETE_LOCAL_AFTER_INGEST=true — xóa PDF tạm sau mỗi doc thành công")

    publications: list[WhoPublication] = []

    if manifest_path and manifest_path.exists():
        manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        for domain_key, pubs in manifest.items():
            if domain and domain_key != domain:
                continue
            for item in pubs:
                publications.append(_publication_from_dict(item))
    else:
        if domain:
            publications = crawler.crawl_domain(WHO_DOMAINS[domain], limit=limit)
        else:
            crawled = crawler.crawl_all()
            crawler.save_manifest(crawled, staging_dir / "manifest.json")
            for pubs in crawled.values():
                publications.extend(pubs)

    if limit:
        publications = publications[:limit]

    total_chunks = 0
    for index, publication in enumerate(publications, start=1):
        print(
            f"[{index}/{len(publications)}] "
            f"domain={publication.domain} id={publication.publication_id} "
            f"title={publication.title[:80]}"
        )
        try:
            total_chunks += process_publication(
                publication,
                settings=settings,
                crawler=crawler,
                s3=s3,
                ingestor=ingestor,
                staging_dir=staging_dir,
            )
        except Exception as exc:
            print(f"⚠️ Failed publication {publication.source_url}: {exc}")

    summary = {
        "publications_processed": len(publications),
        "chunks_indexed": total_chunks,
        "elasticsearch_index": settings.elasticsearch_index,
        "s3_enabled": settings.s3_enabled,
        "local_pdf_deleted": settings.delete_local_after_ingest,
    }
    print("✅ Pipeline complete:", summary)
    return summary


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Pipeline ingest WHO → OpenSearch (S3 tuỳ chọn)"
    )
    parser.add_argument("--all", action="store_true", help="Crawl cả 4 domain (~200 docs)")
    parser.add_argument("--domain", choices=all_domain_keys(), help="Chỉ 1 domain")
    parser.add_argument("--limit", type=int, help="Giới hạn số publication (test)")
    parser.add_argument(
        "--from-manifest",
        type=str,
        help="Dùng manifest.json đã crawl, không gọi WHO lại",
    )
    args = parser.parse_args()

    if not args.all and not args.domain and not args.from_manifest:
        parser.error("Chọn --all, --domain, hoặc --from-manifest")

    run_pipeline(
        domain=args.domain,
        limit=args.limit,
        manifest_path=Path(args.from_manifest) if args.from_manifest else None,
    )


if __name__ == "__main__":
    main()
