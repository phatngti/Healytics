"""
crawler.py — Crawl tài liệu WHO theo keyword từng domain.

Luồng crawl 1 publication:
  1. Search WHO bằng keyword (nutrition, mental health, ...)
  2. Thu thập link trang chi tiết /publications/i/item/...
  3. Vào trang chi tiết → tìm link PDF (iris, bitstream, .pdf)
  4. Lưu metadata vào WhoPublication
  5. download_pdf() tải file về staging_dir trước khi upload S3

Lưu ý:
  - Trang WHO có thể đổi HTML → nếu crawl thiếu, xem log và cân nhắc Playwright.
  - crawl_delay_seconds tránh gửi request quá nhanh.
  - manifest.json lưu kết quả crawl để ingest lại không cần crawl (--from-manifest).
"""

from __future__ import annotations

import hashlib
import json
import re
import time
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Set
from urllib.parse import quote_plus, urljoin, urlparse

import requests
from bs4 import BeautifulSoup

from who_ingestion.config import WhoIngestionSettings
from who_ingestion.domains import WHO_DOMAINS, WhoDomain


@dataclass
class WhoPublication:
    """Metadata một tài liệu WHO sau khi crawl (chưa cần đã tải PDF)."""

    domain: str  # nutrition, mental_health, ...
    keyword: str  # Keyword đã match được link này
    title: str
    source_url: str  # URL trang publication trên who.int
    pdf_url: str  # URL tải PDF trực tiếp
    publication_id: str  # Hash ngắn từ source_url — dùng làm doc_id

    def to_dict(self) -> dict:
        return asdict(self)


def _slug(value: str) -> str:
    cleaned = re.sub(r"[^a-zA-Z0-9_-]+", "-", value.strip().lower())
    return cleaned.strip("-") or "unknown"


def _publication_id(url: str) -> str:
    return hashlib.sha1(url.encode("utf-8")).hexdigest()[:16]


class WhoPublicationCrawler:
    def __init__(self, settings: WhoIngestionSettings) -> None:
        self.settings = settings
        self.session = requests.Session()
        self.session.headers.update({"User-Agent": settings.crawl_user_agent})

    def _get(self, url: str) -> requests.Response:
        response = self.session.get(url, timeout=self.settings.crawl_timeout_seconds)
        response.raise_for_status()
        time.sleep(self.settings.crawl_delay_seconds)
        return response

    def _search_publication_links(self, keyword: str, limit: int) -> List[str]:
        """
        Query WHO publications listing/search and collect detail page URLs.
        """
        links: List[str] = []
        seen: Set[str] = set()

        search_urls = [
            f"{self.settings.who_base_url}/publications/i?query={quote_plus(keyword)}",
            f"{self.settings.who_publications_url}?query={quote_plus(keyword)}",
            f"{self.settings.who_base_url}/publications/i/item?query={quote_plus(keyword)}",
        ]

        for search_url in search_urls:
            try:
                html = self._get(search_url).text
            except Exception as exc:
                print(f"⚠️ Search failed for '{keyword}' at {search_url}: {exc}")
                continue

            soup = BeautifulSoup(html, "html.parser")
            for anchor in soup.find_all("a", href=True):
                href = anchor["href"].strip()
                full = urljoin(self.settings.who_base_url, href)
                if "/publications/i/item/" in full and full not in seen:
                    seen.add(full)
                    links.append(full)
                if len(links) >= limit:
                    return links

        return links[:limit]

    def _extract_pdf_url(self, detail_url: str) -> tuple[str, str]:
        html = self._get(detail_url).text
        soup = BeautifulSoup(html, "html.parser")

        title = ""
        h1 = soup.find("h1")
        if h1:
            title = h1.get_text(" ", strip=True)
        if not title:
            title_tag = soup.find("title")
            title = title_tag.get_text(" ", strip=True) if title_tag else detail_url

        pdf_candidates: List[str] = []
        for anchor in soup.find_all("a", href=True):
            href = anchor["href"].strip()
            full = urljoin(self.settings.who_base_url, href)
            lower = full.lower()
            if lower.endswith(".pdf") or "/iris/" in lower or "bitstream" in lower:
                pdf_candidates.append(full)

        if not pdf_candidates:
            for tag in soup.find_all(["a", "button", "link"], href=True):
                href = tag.get("href", "")
                if "download" in href.lower() or "pdf" in tag.get_text(" ", strip=True).lower():
                    pdf_candidates.append(urljoin(self.settings.who_base_url, href))

        pdf_url = pdf_candidates[0] if pdf_candidates else ""
        return title, pdf_url

    def crawl_domain(
        self,
        domain: WhoDomain,
        *,
        limit: int | None = None,
    ) -> List[WhoPublication]:
        target = limit or self.settings.docs_per_domain
        publications: List[WhoPublication] = []
        seen_urls: Set[str] = set()

        for keyword in domain.keywords:
            if len(publications) >= target:
                break

            remaining = target - len(publications)
            detail_links = self._search_publication_links(keyword, remaining * 3)

            for detail_url in detail_links:
                if len(publications) >= target:
                    break
                if detail_url in seen_urls:
                    continue
                seen_urls.add(detail_url)

                try:
                    title, pdf_url = self._extract_pdf_url(detail_url)
                except Exception as exc:
                    print(f"⚠️ Skip detail page {detail_url}: {exc}")
                    continue

                if not pdf_url:
                    print(f"⚠️ No PDF found for {detail_url}")
                    continue

                publications.append(
                    WhoPublication(
                        domain=domain.key,
                        keyword=keyword,
                        title=title,
                        source_url=detail_url,
                        pdf_url=pdf_url,
                        publication_id=_publication_id(detail_url),
                    )
                )

        return publications

    def crawl_all(self) -> Dict[str, List[WhoPublication]]:
        results: Dict[str, List[WhoPublication]] = {}
        for key, domain in WHO_DOMAINS.items():
            print(f"📚 Crawling domain={domain.label_vi} ({key}), target={self.settings.docs_per_domain}")
            results[key] = self.crawl_domain(domain)
            print(f"   → collected {len(results[key])} publications")
        return results

    def download_pdf(self, publication: WhoPublication, output_dir: Path) -> Path:
        output_dir.mkdir(parents=True, exist_ok=True)
        filename = f"{publication.domain}_{publication.publication_id}.pdf"
        output_path = output_dir / filename

        if output_path.exists() and output_path.stat().st_size > 0:
            return output_path

        response = self.session.get(
            publication.pdf_url,
            timeout=self.settings.crawl_timeout_seconds,
            stream=True,
        )
        response.raise_for_status()

        with output_path.open("wb") as handle:
            for chunk in response.iter_content(chunk_size=1024 * 64):
                if chunk:
                    handle.write(chunk)

        time.sleep(self.settings.crawl_delay_seconds)
        return output_path

    def save_manifest(self, publications: Dict[str, List[WhoPublication]], path: Path) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        serializable = {
            domain: [pub.to_dict() for pub in pubs]
            for domain, pubs in publications.items()
        }
        path.write_text(json.dumps(serializable, ensure_ascii=False, indent=2), encoding="utf-8")
