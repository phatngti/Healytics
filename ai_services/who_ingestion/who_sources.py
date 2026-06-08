"""
who_sources.py — Đa nguồn crawl WHO publications (pagination + PDF resolution).

Nguồn (crawler ưu tiên HTML + IRIS trước; Hubs API sau vì DefaultUrl hay 404):
  1. who.int HTML        — /publications/i/item/... (ổn định nhất)
  2. IRIS DSpace 7 API   — iris.who.int/server/api/discover/search/objects
  3. IRIS legacy REST    — apps.who.int/iris/rest/search (start/rows)
  4. WHO Hubs OData API  — normalize slug → /publications/i/item/ hoặc IRIS
"""

from __future__ import annotations

import json
import re
import time
from dataclasses import dataclass
from typing import Any, Generator, Iterable, List, Optional
from urllib.parse import quote, quote_plus, urljoin, urlparse

import requests
from bs4 import BeautifulSoup

from who_ingestion.config import WhoIngestionSettings
from who_ingestion.dedup import (
    extract_iris_handle,
    extract_who_item_code,
    is_valid_who_item_url,
    normalize_pdf_url,
    normalize_source_url,
)


@dataclass
class RawPublication:
    """Kết quả thô trước khi gán domain và dedup."""

    title: str
    source_url: str
    pdf_url: str
    keyword: str = ""
    iris_handle: str = ""
    subjects: List[str] | None = None
    source_name: str = ""


class WhoHttpClient:
    def __init__(self, settings: WhoIngestionSettings) -> None:
        self.settings = settings
        self.session = requests.Session()
        self.session.trust_env = False  # Tránh proxy hệ thống gây 403/404 giả
        self.session.headers.update({
            "User-Agent": settings.crawl_user_agent,
            "Accept": "application/json, text/html, */*",
            "Accept-Language": "en",
        })

    def get(
        self,
        url: str,
        *,
        expect_json: bool = False,
        stream: bool = False,
        retries: int | None = None,
    ) -> requests.Response:
        retries = retries if retries is not None else self.settings.crawl_retries
        last_exc: Exception | None = None
        for attempt in range(retries):
            try:
                response = self.session.get(
                    url,
                    timeout=self.settings.crawl_timeout_seconds,
                    stream=stream,
                )
                response.raise_for_status()
                time.sleep(self.settings.crawl_delay_seconds)
                return response
            except requests.HTTPError as exc:
                last_exc = exc
                status = exc.response.status_code if exc.response is not None else 0
                if status in {400, 401, 403, 404, 410}:
                    raise
                wait = self.settings.crawl_retry_backoff_seconds * (2 ** attempt)
                print(f"⚠️  HTTP retry {attempt + 1}/{retries} {url[:80]}… ({exc})")
                time.sleep(wait)
            except Exception as exc:
                last_exc = exc
                wait = self.settings.crawl_retry_backoff_seconds * (2 ** attempt)
                print(f"⚠️  HTTP retry {attempt + 1}/{retries} {url[:80]}… ({exc})")
                time.sleep(wait)
        raise last_exc  # type: ignore[misc]

    def get_json(self, url: str) -> Any:
        response = self.get(url, expect_json=True)
        return response.json()


def _pick_pdf_from_bitstreams(bitstreams: Iterable[dict]) -> str:
    pdfs: List[str] = []
    for bs in bitstreams:
        name = (bs.get("name") or bs.get("bundleName") or "").lower()
        link = bs.get("link") or bs.get("href") or bs.get("url") or ""
        if not link:
            continue
        if name.endswith(".pdf") or link.lower().endswith(".pdf") or "/bitstream/" in link.lower():
            pdfs.append(link)
    return pdfs[0] if pdfs else ""


class WhoHubsApiSource:
    """WHO Sitefinity Hubs OData — phân trang $top/$skip."""

    def __init__(self, http: WhoHttpClient, settings: WhoIngestionSettings) -> None:
        self.http = http
        self.base = settings.who_hubs_api.rstrip("/")

    def search(self, term: str, *, max_pages: int) -> Generator[RawPublication, None, None]:
        page_size = 50
        for page in range(max_pages):
            skip = page * page_size
            # Thử nhiều biến thể OData (Sitefinity có thể khác version)
            safe_term = term.replace("'", "''")
            urls = [
                f"{self.base}?$top={page_size}&$skip={skip}&$filter=contains(Title,'{safe_term}')",
                f"{self.base}?$top={page_size}&$skip={skip}",
            ]
            items: list[dict] = []
            for url in urls:
                try:
                    data = self.http.get_json(url)
                    items = data.get("value") or data.get("Items") or []
                    if items:
                        break
                except Exception as exc:
                    print(f"⚠️  Hubs API skip={skip} term='{term}': {exc}")
                    continue
            if not items:
                break
            for item in items:
                title = (item.get("Title") or item.get("title") or "").strip()
                url_name = (item.get("UrlName") or item.get("urlname") or "").strip()
                raw_url = (
                    item.get("Link")
                    or item.get("ItemDefaultUrl")
                    or item.get("DefaultUrl")
                    or item.get("Url")
                    or ""
                )
                if raw_url and not str(raw_url).startswith("http"):
                    raw_url = urljoin("https://www.who.int", str(raw_url))
                source_url = normalize_source_url(str(raw_url))
                if not source_url and url_name:
                    source_url = normalize_source_url(
                        f"https://www.who.int/publications/i/item/{url_name}"
                    )
                if not source_url and not title:
                    continue
                yield RawPublication(
                    title=title or url_name or source_url,
                    source_url=source_url or str(raw_url),
                    pdf_url="",
                    keyword=term,
                    source_name="hubs_api",
                )
            if len(items) < page_size:
                break


class IrisDspace7Source:
    """IRIS DSpace 7 Discovery API."""

    def __init__(self, http: WhoHttpClient, settings: WhoIngestionSettings) -> None:
        self.http = http
        self.base = settings.who_iris_d7_api.rstrip("/")

    def search(self, query: str, *, max_pages: int) -> Generator[RawPublication, None, None]:
        page_size = 20
        for page in range(max_pages):
            url = (
                f"{self.base}/discover/search/objects"
                f"?query={quote_plus(query)}&dsoType=item&page={page}&size={page_size}"
            )
            try:
                data = self.http.get_json(url)
            except Exception as exc:
                print(f"⚠️  IRIS D7 page={page} q='{query}': {exc}")
                break

            objects = (
                data.get("_embedded", {})
                .get("searchResult", {})
                .get("_embedded", {})
                .get("objects", [])
            )
            if not objects:
                break

            for obj in objects:
                item = obj.get("_embedded", {}).get("indexableObject", {})
                if not item:
                    continue
                uuid = item.get("uuid") or ""
                title = (item.get("name") or "").strip()
                handle = (item.get("handle") or "").strip()
                source_url = f"https://iris.who.int/handle/{handle}" if handle else ""
                pdf_url = self._resolve_pdf(uuid, handle)
                subjects = self._extract_subjects(item)
                yield RawPublication(
                    title=title or handle or uuid,
                    source_url=source_url,
                    pdf_url=pdf_url,
                    keyword=query,
                    iris_handle=handle,
                    subjects=subjects,
                    source_name="iris_d7",
                )

            page_info = data.get("_embedded", {}).get("searchResult", {}).get("page", {})
            if page >= page_info.get("totalPages", page + 1) - 1:
                break

    def _extract_subjects(self, item: dict) -> List[str]:
        metadata = item.get("metadata") or {}
        out: List[str] = []
        for key in ("dc.subject", "dc.title", "dc.description"):
            for entry in metadata.get(key, []) or []:
                val = entry.get("value") if isinstance(entry, dict) else str(entry)
                if val:
                    out.append(str(val))
        return out

    def _resolve_pdf(self, uuid: str, handle: str) -> str:
        if uuid:
            try:
                url = f"{self.base}/core/items/{uuid}?embed=bundles/bitstreams"
                data = self.http.get_json(url)
                for bundle in data.get("_embedded", {}).get("bundles", {}).get("_embedded", {}).get("bundles", []):
                    for bs in bundle.get("_embedded", {}).get("bitstreams", {}).get("_embedded", {}).get("bitstreams", []):
                        name = (bs.get("name") or "").lower()
                        if name.endswith(".pdf"):
                            links = bs.get("_links", {})
                            content = links.get("content", {}).get("href", "")
                            if content:
                                return content
            except Exception:
                pass
        if handle:
            try:
                url = f"{self.base}/core/bitstreams/search/byItemHandle?handle={quote_plus(handle)}&filename=.pdf"
                data = self.http.get_json(url)
                links = data.get("_links", {})
                content = links.get("content", {}).get("href", "")
                if content:
                    return content
            except Exception:
                pass
        return ""


class IrisLegacyRestSource:
    """IRIS DSpace 6 REST — start/rows pagination."""

    def __init__(self, http: WhoHttpClient, settings: WhoIngestionSettings) -> None:
        self.http = http
        self.base = settings.who_iris_legacy_api.rstrip("/")

    def search(self, query: str, *, max_pages: int) -> Generator[RawPublication, None, None]:
        rows = 20
        for page in range(max_pages):
            start = page * rows
            url = f"{self.base}/search?query={quote_plus(query)}&start={start}&rows={rows}"
            try:
                data = self.http.get_json(url)
            except Exception as exc:
                print(f"⚠️  IRIS legacy start={start} q='{query}': {exc}")
                break

            items = self._extract_items(data)
            if not items:
                break

            for item in items:
                title = (item.get("name") or item.get("title") or "").strip()
                handle = (item.get("handle") or "").strip()
                source_url = f"https://apps.who.int/iris/handle/{handle}" if handle else ""
                bitstreams = item.get("bitstreams") or []
                pdf_url = _pick_pdf_from_bitstreams(bitstreams)
                if pdf_url and pdf_url.startswith("/"):
                    pdf_url = urljoin("https://apps.who.int/iris/", pdf_url.lstrip("/"))
                yield RawPublication(
                    title=title or handle,
                    source_url=source_url,
                    pdf_url=pdf_url,
                    keyword=query,
                    iris_handle=handle,
                    source_name="iris_legacy",
                )
            if len(items) < rows:
                break

    def _extract_items(self, data: Any) -> list[dict]:
        if isinstance(data, list):
            return data
        if isinstance(data, dict):
            for key in ("items", "results", "response", "docs"):
                val = data.get(key)
                if isinstance(val, list):
                    return val
                if isinstance(val, dict) and "docs" in val:
                    return val["docs"]
        return []


class WhoIntHtmlSource:
    """Parse who.int HTML — search có page + duyệt theo năm."""

    PUBLICATION_ITEM_RE = re.compile(r"/publications/i/item/[^\"'?\s#]+", re.I)

    def __init__(self, http: WhoHttpClient, settings: WhoIngestionSettings) -> None:
        self.http = http
        self.base = settings.who_base_url.rstrip("/")

    def search_keyword(self, keyword: str, *, max_pages: int) -> Generator[RawPublication, None, None]:
        templates = [
            f"{self.base}/publications/i?query={quote_plus(keyword)}&page={{page}}",
            f"{self.base}/publications/i/item?query={quote_plus(keyword)}&page={{page}}",
            f"{self.http.settings.who_publications_url}?query={quote_plus(keyword)}&page={{page}}",
        ]
        seen: set[str] = set()
        for template in templates:
            empty_streak = 0
            for page in range(1, max_pages + 1):
                url = template.format(page=page)
                links = self._extract_item_links(url)
                if not links:
                    empty_streak += 1
                    if empty_streak >= 2:
                        break
                    continue
                empty_streak = 0
                for link in links:
                    if link in seen:
                        continue
                    seen.add(link)
                    yield RawPublication(
                        title="",
                        source_url=link,
                        pdf_url="",
                        keyword=keyword,
                        source_name="who_html_search",
                    )

    def browse_years(self, years: Iterable[int]) -> Generator[RawPublication, None, None]:
        seen: set[str] = set()
        for year in years:
            url = f"{self.base}/publications/i?year={year}"
            for link in self._extract_item_links(url):
                if link in seen:
                    continue
                seen.add(link)
                yield RawPublication(
                    title="",
                    source_url=link,
                    pdf_url="",
                    keyword=f"year:{year}",
                    source_name="who_html_year",
                )

    def _extract_item_links(self, url: str) -> List[str]:
        try:
            html = self.http.get(url).text
        except Exception as exc:
            print(f"⚠️  HTML fetch failed {url}: {exc}")
            return []
        links: List[str] = []
        seen: set[str] = set()
        soup = BeautifulSoup(html, "html.parser")

        for anchor in soup.find_all("a", href=True):
            href = anchor["href"].strip()
            full = urljoin(self.base, href)
            if "/publications/i/item/" in full and full not in seen:
                seen.add(full)
                links.append(full.split("?")[0].rstrip("/"))

        # JSON embedded trong script (Next.js / Sitefinity)
        for script in soup.find_all("script"):
            text = script.string or ""
            for match in self.PUBLICATION_ITEM_RE.findall(text):
                full = urljoin(self.base, match)
                if full not in seen:
                    seen.add(full)
                    links.append(full.split("?")[0].rstrip("/"))

        return links


class PdfResolver:
    """Resolve PDF: IRIS API trước, who.int /publications/i/item/ sau."""

    def __init__(self, http: WhoHttpClient, settings: WhoIngestionSettings) -> None:
        self.http = http
        self.base = settings.who_base_url
        self._iris_d7 = IrisDspace7Source(http, settings)
        self._iris_legacy = IrisLegacyRestSource(http, settings)

    def resolve(
        self,
        source_url: str,
        existing_pdf: str = "",
        *,
        title_hint: str = "",
        iris_handle: str = "",
    ) -> tuple[str, str]:
        if existing_pdf:
            return existing_pdf, title_hint or self._title_from_url(source_url)

        # 1) IRIS handle có sẵn
        if iris_handle:
            pdf = self._iris_d7._resolve_pdf("", iris_handle)
            if pdf:
                return pdf, title_hint or iris_handle

        # 2) IRIS search theo ISBN / mã / title
        query = self._iris_query_from_url(source_url, title_hint)
        if query:
            found = self._search_iris_once(query)
            if found:
                return found.pdf_url, found.title

        # 3) Trang who.int chuẩn /publications/i/item/ (cách crawl hôm qua)
        norm_url = normalize_source_url(source_url)
        if norm_url and "/publications/i/item/" in norm_url:
            pdf, title = self._resolve_from_item_page(norm_url)
            if pdf:
                return pdf, title

        return "", title_hint or ""

    def _iris_query_from_url(self, source_url: str, title_hint: str) -> str:
        if title_hint and len(title_hint) > 8:
            return title_hint[:120]
        parsed = urlparse(source_url or "")
        slug = (parsed.path or "").strip("/").split("/")[-1]
        if slug and len(slug) >= 4:
            return slug
        return ""

    def _search_iris_once(self, query: str) -> RawPublication | None:
        for raw in self._iris_d7.search(query, max_pages=1):
            if raw.pdf_url:
                return raw
        for raw in self._iris_legacy.search(query, max_pages=1):
            if raw.pdf_url:
                return raw
        return None

    def _resolve_from_item_page(self, source_url: str) -> tuple[str, str]:
        try:
            html = self.http.get(source_url, retries=1).text
        except Exception:
            return "", ""

        soup = BeautifulSoup(html, "html.parser")
        title = ""
        h1 = soup.find("h1")
        if h1:
            title = h1.get_text(" ", strip=True)
        if not title:
            t = soup.find("title")
            title = t.get_text(" ", strip=True) if t else source_url

        pdf_candidates: List[str] = []
        for anchor in soup.find_all("a", href=True):
            href = anchor["href"].strip()
            full = urljoin(self.base, href)
            lower = full.lower()
            text = anchor.get_text(" ", strip=True).lower()
            if (
                lower.endswith(".pdf")
                or "/iris/" in lower
                or "bitstream" in lower
                or "download" in text
                or "pdf" in text
            ):
                pdf_candidates.append(full)

        for script in soup.find_all("script"):
            text = script.string or ""
            for match in re.findall(r"https?://[^\s\"']+\.pdf", text, re.I):
                pdf_candidates.append(match)
            for match in re.findall(r"https?://[^\s\"']*iris[^\s\"']+", text, re.I):
                pdf_candidates.append(match)

        for cand in pdf_candidates:
            norm = normalize_pdf_url(cand)
            if norm.endswith(".pdf") or "/bitstream/" in norm or "/iris/" in norm:
                return cand, title
        if pdf_candidates:
            return pdf_candidates[0], title
        return "", title

    def _title_from_url(self, url: str) -> str:
        code = extract_who_item_code(url)
        return code or url


def relevance_score(raw: RawPublication, domain_keywords: List[str]) -> float:
    """Điểm liên quan domain — càng cao càng phù hợp."""
    blob = " ".join([
        raw.title or "",
        " ".join(raw.subjects or []),
        raw.keyword or "",
        raw.source_url or "",
    ]).lower()
    score = 0.0
    for kw in domain_keywords:
        token = kw.lower().strip()
        if not token:
            continue
        if token in blob:
            score += 2.0
        else:
            for part in token.split():
                if len(part) > 3 and part in blob:
                    score += 0.5
    return score
