"""
dedup.py — Đăng ký toàn cục, đảm bảo mỗi PDF WHO chỉ xuất hiện một lần trong corpus.

Dedup theo (ưu tiên):
  1. IRIS handle (10665/xxxxx)
  2. PDF URL chuẩn hóa
  3. Mã publication who.int (/item/CODE)
  4. source_url trang chi tiết
"""

from __future__ import annotations

import hashlib
import re
from dataclasses import dataclass, field
from typing import Any, Iterable, Set
from urllib.parse import parse_qs, urlparse, urlunparse


def normalize_pdf_url(url: str) -> str:
    """Bỏ query/fragment để cùng file IRIS bitstream không bị coi là khác."""
    if not url:
        return ""
    parsed = urlparse(url.strip())
    return urlunparse((parsed.scheme, parsed.netloc, parsed.path.rstrip("/"), "", "", ""))


_ITEM_CODE_RE = re.compile(r"^[A-Z][A-Z0-9._-]{2,24}$", re.I)
_ISBN_RE = re.compile(r"^97[89]\d{10}$")


def is_valid_who_item_url(url: str) -> bool:
    """Chỉ URL /publications/i/item/... hoặc iris handle là hợp lệ để fetch."""
    if not url:
        return False
    if "/publications/i/item/" in url:
        return True
    if "iris" in url and "handle" in url:
        return True
    return False


def normalize_source_url(url: str) -> str:
    """
    Chuẩn hóa URL từ Hubs API (thường sai dạng https://www.who.int/978924...).

    Trả '' nếu URL không thể resolve qua who.int detail (dùng IRIS thay thế).
    """
    if not url:
        return ""
    cleaned = url.strip().split("?")[0].rstrip("/")
    if is_valid_who_item_url(cleaned):
        return cleaned

    parsed = urlparse(cleaned)
    if "who.int" not in (parsed.netloc or ""):
        return cleaned

    slug = (parsed.path or "").strip("/")
    if not slug or "/" in slug:
        return ""

    if _ISBN_RE.match(slug):
        return ""  # ISBN → IRIS search, không gọi who.int/978...

    if _ITEM_CODE_RE.match(slug.split("/")[-1]):
        return f"https://www.who.int/publications/i/item/{slug.split('/')[-1]}"

    return ""  # slug dài / câu → bỏ qua (tránh 404)


def extract_who_item_code(url: str) -> str:
    if not url:
        return ""
    match = re.search(r"/publications/i/item/([^/?#]+)", url, re.I)
    return match.group(1).upper() if match else ""


def extract_iris_handle(url: str) -> str:
    if not url:
        return ""
    match = re.search(r"(?:iris/)?handle/(\d+/\d+)", url, re.I)
    if match:
        return match.group(1)
    match = re.search(r"/bitstream/(\d+/\d+)", url, re.I)
    if match:
        return match.group(1)
    return ""


def publication_id_from_keys(*, pdf_url: str = "", source_url: str = "", iris_handle: str = "") -> str:
    """ID ổn định — dùng làm doc_id trong ES (không phụ thuộc domain)."""
    primary = iris_handle or extract_who_item_code(source_url) or normalize_pdf_url(pdf_url) or source_url
    return hashlib.sha1(primary.encode("utf-8")).hexdigest()[:16]


@dataclass
class GlobalDedupRegistry:
    """Theo dõi publication đã claim trên toàn bộ 4 domain."""

    _handles: Set[str] = field(default_factory=set)
    _pdf_urls: Set[str] = field(default_factory=set)
    _item_codes: Set[str] = field(default_factory=set)
    _source_urls: Set[str] = field(default_factory=set)
    _publication_ids: Set[str] = field(default_factory=set)

    def is_duplicate(
        self,
        *,
        pdf_url: str = "",
        source_url: str = "",
        iris_handle: str = "",
        publication_id: str = "",
    ) -> bool:
        handle = iris_handle or extract_iris_handle(pdf_url) or extract_iris_handle(source_url)
        pdf_key = normalize_pdf_url(pdf_url)
        item_code = extract_who_item_code(source_url)
        src = (source_url or "").strip().rstrip("/")
        pub_id = publication_id or publication_id_from_keys(
            pdf_url=pdf_url, source_url=source_url, iris_handle=handle
        )

        if pub_id and pub_id in self._publication_ids:
            return True
        if handle and handle in self._handles:
            return True
        if pdf_key and pdf_key in self._pdf_urls:
            return True
        if item_code and item_code in self._item_codes:
            return True
        if src and src in self._source_urls:
            return True
        return False

    def register(
        self,
        *,
        pdf_url: str = "",
        source_url: str = "",
        iris_handle: str = "",
        publication_id: str = "",
    ) -> str:
        handle = iris_handle or extract_iris_handle(pdf_url) or extract_iris_handle(source_url)
        pdf_key = normalize_pdf_url(pdf_url)
        item_code = extract_who_item_code(source_url)
        src = (source_url or "").strip().rstrip("/")
        pub_id = publication_id or publication_id_from_keys(
            pdf_url=pdf_url, source_url=source_url, iris_handle=handle
        )

        if handle:
            self._handles.add(handle)
        if pdf_key:
            self._pdf_urls.add(pdf_key)
        if item_code:
            self._item_codes.add(item_code)
        if src:
            self._source_urls.add(src)
        if pub_id:
            self._publication_ids.add(pub_id)
        return pub_id

    @property
    def total_unique(self) -> int:
        return len(self._publication_ids)

    @classmethod
    def seed_from_manifest(cls, manifest: dict[str, list[dict[str, Any]]]) -> "GlobalDedupRegistry":
        """Nạp publication đã crawl/ingest — dùng khi batch 2+ để tránh trùng."""
        registry = cls()
        for pubs in manifest.values():
            for item in pubs:
                registry.register(
                    pdf_url=item.get("pdf_url", ""),
                    source_url=item.get("source_url", ""),
                    iris_handle=item.get("iris_handle", ""),
                    publication_id=item.get("publication_id", ""),
                )
        return registry
