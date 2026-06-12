"""
crawler.py — Crawl đa nguồn WHO, dedup toàn cục, mục tiêu 50 PDF/domain (200 unique).

Nguồn: WHO Hubs API, IRIS DSpace 7, IRIS legacy, who.int HTML (search + năm).
Mỗi PDF chỉ thuộc MỘT domain — không index trùng.
"""

from __future__ import annotations

import json
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Dict, List, Set

from who_ingestion.config import WhoIngestionSettings
from who_ingestion.dedup import (
    GlobalDedupRegistry,
    extract_who_item_code,
    is_valid_who_item_url,
    publication_id_from_keys,
)
from who_ingestion.domains import WHO_DOMAINS, WhoDomain
from who_ingestion.who_sources import (
    IrisDspace7Source,
    IrisLegacyRestSource,
    PdfResolver,
    RawPublication,
    WhoHttpClient,
    WhoHubsApiSource,
    WhoIntHtmlSource,
    relevance_score,
)


@dataclass
class WhoPublication:
    domain: str
    keyword: str
    title: str
    source_url: str
    pdf_url: str
    publication_id: str
    iris_handle: str = ""
    source_name: str = ""

    def to_dict(self) -> dict:
        return asdict(self)


class WhoPublicationCrawler:
    def __init__(self, settings: WhoIngestionSettings) -> None:
        self.settings = settings
        self.http = WhoHttpClient(settings)
        self.pdf_resolver = PdfResolver(self.http, settings)
        self.hubs = WhoHubsApiSource(self.http, settings)
        self.iris_d7 = IrisDspace7Source(self.http, settings)
        self.iris_legacy = IrisLegacyRestSource(self.http, settings)
        self.who_html = WhoIntHtmlSource(self.http, settings)

    def crawl_domain(
        self,
        domain: WhoDomain,
        *,
        limit: int | None = None,
        registry: GlobalDedupRegistry | None = None,
    ) -> List[WhoPublication]:
        target = limit or self.settings.docs_per_domain
        registry = registry or GlobalDedupRegistry()
        print(f"   → Bắt đầu crawl {domain.key}, mục tiêu {target} PDF…", flush=True)
        collected: List[WhoPublication] = []
        seen_in_domain: Set[str] = set()
        min_relevance = 1.0

        def try_add(raw: RawPublication, *, relax_relevance: bool = False) -> bool:
            if len(collected) >= target:
                return False

            score = relevance_score(raw, domain.keywords + domain.iris_queries)
            if not relax_relevance and score < min_relevance:
                return False

            pdf_url = raw.pdf_url
            title = raw.title
            if not pdf_url:
                resolved_pdf, resolved_title = self.pdf_resolver.resolve(
                    raw.source_url,
                    raw.pdf_url,
                    title_hint=raw.title,
                    iris_handle=raw.iris_handle,
                )
                pdf_url = resolved_pdf
                title = title or resolved_title
            elif not title and is_valid_who_item_url(raw.source_url):
                _, resolved_title = self.pdf_resolver.resolve(
                    raw.source_url, pdf_url, title_hint="", iris_handle=raw.iris_handle
                )
                title = resolved_title or raw.title

            if not pdf_url:
                return False
            if not title:
                title = extract_who_item_code(raw.source_url) or raw.source_url

            pub_id = publication_id_from_keys(
                pdf_url=pdf_url,
                source_url=raw.source_url,
                iris_handle=raw.iris_handle,
            )
            if pub_id in seen_in_domain:
                return False
            if registry.is_duplicate(
                pdf_url=pdf_url,
                source_url=raw.source_url,
                iris_handle=raw.iris_handle,
                publication_id=pub_id,
            ):
                return False

            registry.register(
                pdf_url=pdf_url,
                source_url=raw.source_url,
                iris_handle=raw.iris_handle,
                publication_id=pub_id,
            )
            seen_in_domain.add(pub_id)
            collected.append(
                WhoPublication(
                    domain=domain.key,
                    keyword=raw.keyword,
                    title=title,
                    source_url=raw.source_url,
                    pdf_url=pdf_url,
                    publication_id=pub_id,
                    iris_handle=raw.iris_handle,
                    source_name=raw.source_name,
                )
            )
            return True

        # ── Phase 1: search terms chuyên biệt từng domain ──
        for term in domain.all_search_terms():
            if len(collected) >= target:
                break
            before = len(collected)
            self._collect_from_all_sources(term, try_add)
            added = len(collected) - before
            if added:
                print(f"   +{added} từ query '{term}' (tổng {len(collected)}/{target})")

        # ── Phase 2: duyệt theo năm, gán theo relevance ──
        if len(collected) < target:
            print(f"   ↻ Bổ sung từ browse năm ({len(collected)}/{target})…")
            years = list(range(2026, 1997, -1))
            for raw in self.who_html.browse_years(years):
                if len(collected) >= target:
                    break
                try_add(raw, relax_relevance=False)

        # ── Phase 3: nới relevance nếu vẫn thiếu ──
        if len(collected) < target:
            print(f"   ↻ Nới lọc relevance ({len(collected)}/{target})…")
            for term in domain.keywords[:5]:
                if len(collected) >= target:
                    break
                for raw in self._iter_sources(term):
                    try_add(raw, relax_relevance=True)

        return collected

    def _source_order(self, term: str, max_pages: int):
        """IRIS trước (có PDF sẵn, không 404); HTML item links; Hubs API cuối."""
        yield from self.iris_d7.search(term, max_pages=max_pages)
        yield from self.iris_legacy.search(term, max_pages=max_pages)
        yield from self.who_html.search_keyword(term, max_pages=max_pages)
        yield from self.hubs.search(term, max_pages=max_pages)

    def _collect_from_all_sources(self, term: str, try_add) -> None:
        max_pages = self.settings.crawl_max_pages_per_query
        for raw in self._source_order(term, max_pages):
            try_add(raw)

    def _iter_sources(self, term: str):
        max_pages = self.settings.crawl_max_pages_per_query
        yield from self._source_order(term, max_pages)

    def crawl_all(self) -> Dict[str, List[WhoPublication]]:
        registry = GlobalDedupRegistry()
        results: Dict[str, List[WhoPublication]] = {}
        total = 0
        for key, domain in WHO_DOMAINS.items():
            print(f"📚 Crawling domain={domain.label_vi} ({key}), target={self.settings.docs_per_domain}")
            pubs = self.crawl_domain(domain, registry=registry)
            results[key] = pubs
            total += len(pubs)
            print(f"   → collected {len(pubs)} unique publications (global unique so far: {registry.total_unique})")
        print(f"📊 Tổng unique toàn corpus: {registry.total_unique} (mục tiêu {len(WHO_DOMAINS) * self.settings.docs_per_domain})")
        return results

    def download_pdf(self, publication: WhoPublication, output_dir: Path) -> Path:
        output_dir.mkdir(parents=True, exist_ok=True)
        filename = f"{publication.domain}_{publication.publication_id}.pdf"
        output_path = output_dir / filename

        if output_path.exists() and output_path.stat().st_size > 1024:
            return output_path

        last_exc: Exception | None = None
        for attempt in range(self.settings.crawl_retries):
            try:
                response = self.http.get(publication.pdf_url, stream=True)
                with output_path.open("wb") as handle:
                    for chunk in response.iter_content(chunk_size=1024 * 64):
                        if chunk:
                            handle.write(chunk)
                if output_path.stat().st_size < 1024:
                    output_path.unlink(missing_ok=True)
                    raise ValueError("PDF quá nhỏ — có thể không phải file hợp lệ")
                return output_path
            except Exception as exc:
                last_exc = exc
                output_path.unlink(missing_ok=True)
                print(f"⚠️  Download retry {attempt + 1} {publication.pdf_url[:70]}…")
        raise last_exc  # type: ignore[misc]

    def save_manifest(self, publications: Dict[str, List[WhoPublication]], path: Path) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        serializable = {
            domain: [pub.to_dict() for pub in pubs]
            for domain, pubs in publications.items()
        }
        path.write_text(json.dumps(serializable, ensure_ascii=False, indent=2), encoding="utf-8")

    @staticmethod
    def merge_manifest(
        existing: Dict[str, list[dict]],
        new_batch: Dict[str, List[WhoPublication]],
    ) -> Dict[str, list[dict]]:
        """Gộp manifest cũ + batch mới (theo publication_id)."""
        merged: Dict[str, list[dict]] = {k: list(v) for k, v in existing.items()}
        seen = {
            item.get("publication_id")
            for pubs in merged.values()
            for item in pubs
            if item.get("publication_id")
        }
        added = 0
        for domain, pubs in new_batch.items():
            merged.setdefault(domain, [])
            for pub in pubs:
                if pub.publication_id in seen:
                    continue
                merged[domain].append(pub.to_dict())
                seen.add(pub.publication_id)
                added += 1
        print(f"📄 Manifest: +{added} mới, tổng {len(seen)} publication")
        return merged
