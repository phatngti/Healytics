#!/usr/bin/env python3
"""
Chỉ crawl metadata (không ingest ES) — kiểm tra số lượng + dedup.

Chạy: cd ai_services && python who_ingestion/scripts/crawl_dry_run.py
      python who_ingestion/scripts/crawl_dry_run.py --domain nutrition --limit 10
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

AI_SERVICES = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(AI_SERVICES))

from dotenv import load_dotenv

load_dotenv(AI_SERVICES / "who_ingestion" / ".env")

from who_ingestion.config import load_settings
from who_ingestion.crawler import WhoPublicationCrawler
from who_ingestion.domains import WHO_DOMAINS, all_domain_keys
from who_ingestion.dedup import GlobalDedupRegistry


def main() -> None:
    parser = argparse.ArgumentParser(description="Dry-run crawl WHO — không ingest")
    parser.add_argument("--domain", choices=all_domain_keys())
    parser.add_argument("--limit", type=int, help="Override docs per domain")
    args = parser.parse_args()

    settings = load_settings()
    crawler = WhoPublicationCrawler(settings)
    registry = GlobalDedupRegistry()

    if args.domain:
        domain = WHO_DOMAINS[args.domain]
        limit = args.limit or settings.docs_per_domain
        print(
            f"🔍 Dry-run crawl: domain={args.domain} ({domain.label_vi}), "
            f"target={limit} — đang gọi IRIS/WHO (có thể mất 1–3 phút trước khi in kết quả)…",
            flush=True,
        )
        pubs = crawler.crawl_domain(domain, limit=limit, registry=registry)
        print(f"\n✅ {args.domain}: {len(pubs)} publications (global unique: {registry.total_unique})")
        for i, p in enumerate(pubs[:10], 1):
            print(f"  {i}. [{p.source_name}] {p.title[:70]}")
    else:
        results = crawler.crawl_all()
        all_ids = set()
        for key, pubs in results.items():
            for p in pubs:
                all_ids.add(p.publication_id)
            print(f"  {key}: {len(pubs)}")
        print(f"\n✅ Tổng: {sum(len(v) for v in results.values())} rows, {len(all_ids)} PDF unique")


if __name__ == "__main__":
    main()
