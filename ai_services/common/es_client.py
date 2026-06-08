"""
es_client.py — Tạo AWS OpenSearch client dùng chung.

Dùng opensearch-py (không dùng elasticsearch-py) vì AWS OpenSearch không phải
Elasticsearch product → elasticsearch 8.x báo UnsupportedProductError.

OpenSearch managed domain (FGAC):
  - API:  https://search-xxx.ap-southeast-1.es.amazonaws.com  (KHÔNG /_dashboards)
  - Auth: master user username/password (ELASTICSEARCH_USE_AWS_IAM=false)
"""

from __future__ import annotations

import os
import re
from typing import Any
from urllib.parse import urlparse


def normalize_elasticsearch_url(url: str) -> str:
    """Bỏ /_dashboards và slash thừa."""
    cleaned = (url or "").strip()
    if not cleaned:
        return cleaned
    cleaned = re.sub(r"/_dashboards/?$", "", cleaned, flags=re.IGNORECASE)
    return cleaned.rstrip("/")


def _host_from_url(url: str) -> str:
    parsed = urlparse(url)
    return parsed.hostname or url


def _parse_hosts(url: str) -> list[dict[str, Any]]:
    parsed = urlparse(url)
    if not parsed.hostname:
        raise ValueError(f"URL OpenSearch không hợp lệ: {url}")
    port = parsed.port or (443 if parsed.scheme == "https" else 80)
    return [{"host": parsed.hostname, "port": port}]


def _iam_mode_explicit() -> str | None:
    """true | false | None (auto)."""
    raw = os.getenv("ELASTICSEARCH_USE_AWS_IAM", "").strip().lower()
    if raw in {"1", "true", "yes", "on"}:
        return "true"
    if raw in {"0", "false", "no", "off"}:
        return "false"
    return None


def should_use_aws_iam(url: str, *, username: str = "", password: str = "") -> bool:
    """
    Quyết định dùng IAM hay master user password.

    Mặc định (auto): có username+password → basic auth (ổn định nhất cho FGAC master user).
    """
    mode = _iam_mode_explicit()
    if mode == "true":
        return True
    if mode == "false":
        return False
    if username and password:
        return False
    host = _host_from_url(url).lower()
    return ".aos." in host or ".aoss." in host


def build_elasticsearch_client(
    *,
    url: str,
    api_key: str = "",
    username: str = "",
    password: str = "",
    verify_certs: bool = True,
    aws_region: str = "",
    aws_access_key_id: str = "",
    aws_secret_access_key: str = "",
    force_iam: bool | None = None,
) -> Any:
    """
    Trả về OpenSearch client (API tương thích elasticsearch-py).
    Tên hàm giữ 'elasticsearch' để không đổi call site.
    """
    try:
        from opensearchpy import OpenSearch, RequestsHttpConnection
    except ImportError as exc:
        raise RuntimeError(
            "Cần opensearch-py cho AWS OpenSearch. Chạy: pip install opensearch-py"
        ) from exc

    class _NoProxyRequestsHttpConnection(RequestsHttpConnection):
        """Tránh proxy Cursor/IDE làm fail kết nối OpenSearch."""

        def __init__(self, *args: Any, **kwargs: Any) -> None:
            super().__init__(*args, **kwargs)
            self.session.trust_env = False

    normalized_url = normalize_elasticsearch_url(url)
    if not normalized_url:
        raise ValueError("ELASTICSEARCH_URL is empty.")

    hosts = _parse_hosts(normalized_url)
    use_ssl = normalized_url.startswith("https://")
    common_kwargs: dict[str, Any] = {
        "hosts": hosts,
        "use_ssl": use_ssl,
        "verify_certs": verify_certs,
        "connection_class": _NoProxyRequestsHttpConnection,
        "timeout": 60,
    }

    if api_key:
        return OpenSearch(
            http_auth=("ApiKey", api_key),
            **common_kwargs,
        )

    use_iam = (
        force_iam
        if force_iam is not None
        else should_use_aws_iam(normalized_url, username=username, password=password)
    )

    if not use_iam and username and password:
        return OpenSearch(
            http_auth=(username, password),
            **common_kwargs,
        )

    if use_iam:
        try:
            from requests_aws4auth import AWS4Auth
        except ImportError as exc:
            raise RuntimeError(
                "Cần requests-aws4auth. Chạy: pip install requests-aws4auth"
            ) from exc

        import boto3

        region = (
            aws_region
            or os.getenv("AWS_REGION", "")
            or os.getenv("ELASTICSEARCH_AWS_REGION", "")
            or "ap-southeast-1"
        )
        session = boto3.Session(
            aws_access_key_id=aws_access_key_id or os.getenv("AWS_ACCESS_KEY_ID") or None,
            aws_secret_access_key=aws_secret_access_key or os.getenv("AWS_SECRET_ACCESS_KEY") or None,
            region_name=region,
        )
        credentials = session.get_credentials()
        if credentials is None:
            raise ValueError("Thiếu AWS credentials cho OpenSearch IAM.")
        frozen = credentials.get_frozen_credentials()
        awsauth = AWS4Auth(
            frozen.access_key,
            frozen.secret_key,
            region,
            "es",
            session_token=frozen.token,
        )
        return OpenSearch(
            http_auth=awsauth,
            **common_kwargs,
        )

    if username and password:
        return OpenSearch(
            http_auth=(username, password),
            **common_kwargs,
        )

    raise ValueError(
        "Thiếu thông tin đăng nhập. Cần USERNAME/PASSWORD (master user) hoặc AWS IAM."
    )


def candidate_elasticsearch_urls(primary: str = "") -> list[str]:
    """
    Danh sách URL thử theo thứ tự ưu tiên cho domain healytics-who.
    """
    seen: set[str] = set()
    ordered: list[str] = []

    def add(url: str) -> None:
        norm = normalize_elasticsearch_url(url)
        if norm and norm not in seen:
            seen.add(norm)
            ordered.append(norm)

    if primary:
        add(primary)

    host_id = "search-healytics-who-et572nybnlgo7dclgmdyg7vcpq"
    add(f"https://{host_id}.aos.ap-southeast-1.on.aws")
    add(f"https://{host_id}.ap-southeast-1.es.amazonaws.com")

    extra = os.getenv("ELASTICSEARCH_URL_FALLBACK", "")
    if extra:
        add(extra)

    return ordered
