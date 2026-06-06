#!/usr/bin/env python3
"""
Tự động thử mọi URL + phương thức auth, chọn cấu hình hoạt động.

Chạy: cd ai_services && python who_ingestion/scripts/test_es_connection.py
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

AI_SERVICES_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(AI_SERVICES_ROOT))

from dotenv import load_dotenv

load_dotenv(AI_SERVICES_ROOT / "who_ingestion" / ".env")

from common.es_client import (
    build_elasticsearch_client,
    candidate_elasticsearch_urls,
    normalize_elasticsearch_url,
)


def _creds() -> dict:
    return {
        "username": os.getenv("ELASTICSEARCH_USERNAME", ""),
        "password": os.getenv("ELASTICSEARCH_PASSWORD", ""),
        "verify_certs": os.getenv("ELASTICSEARCH_VERIFY_CERTS", "true").lower() == "true",
        "aws_region": os.getenv("AWS_REGION", "ap-southeast-1"),
        "aws_access_key_id": os.getenv("AWS_ACCESS_KEY_ID", ""),
        "aws_secret_access_key": os.getenv("AWS_SECRET_ACCESS_KEY", ""),
    }


def main() -> None:
    primary = os.getenv("ELASTICSEARCH_URL", "")
    urls = candidate_elasticsearch_urls(primary)
    creds = _creds()

    print("=== Tự động kiểm tra OpenSearch ===\n")

    # Thứ tự: basic auth trước (master user FGAC), IAM sau
    attempts: list[tuple[str, str, bool | None]] = []
    for url in urls:
        attempts.append((url, "basic (master user)", False))
        attempts.append((url, "iam (AWS key)", True))

    last_error = None
    for url, label, force_iam in attempts:
        print(f"Thử: {label}")
        print(f"      {url}")
        try:
            es = build_elasticsearch_client(
                url=url,
                force_iam=force_iam,
                **creds,
            )
            info = es.info()
            cluster = info.get("cluster_name")
            version = info.get("version", {}).get("number")
            print(f"✅ THÀNH CÔNG — {label}")
            print(f"   cluster: {cluster}")
            print(f"   version: {version}")
            print()
            print("→ Cập nhật who_ingestion/.env:")
            print(f"   ELASTICSEARCH_URL={url}")
            if force_iam:
                print("   ELASTICSEARCH_USE_AWS_IAM=true")
            else:
                print("   ELASTICSEARCH_USE_AWS_IAM=false")
            return
        except Exception as exc:
            last_error = exc
            short = str(exc).replace("\n", " ")[:220]
            print(f"   ❌ {type(exc).__name__}: {short}\n")

    print("❌ Không URL/auth nào hoạt động.")
    if last_error:
        print(f"Lỗi cuối: {last_error}")
    print()
    print("Chẩn đoán:")
    print("  • UnsupportedProductError → cần opensearch-py: pip install opensearch-py")
    print("  • 401 basic  → sai master user/password")
    print("  • 403 iam    → IAM OK nhưng thiếu FGAC role mapping")
    print()
    print("Bước 1 — Lấy đúng master username:")
    print("  python who_ingestion/scripts/describe_opensearch_domain.py")
    print()
    print("Bước 2 — Sửa who_ingestion/.env:")
    print("  ELASTICSEARCH_USERNAME=<MasterUserName từ AWS>")
    print("  ELASTICSEARCH_PASSWORD=<password khi tạo domain>")
    print("  (Quên password → AWS Console → OpenSearch → healytics-who → Edit → đổi master password)")
    print()
    print("Bước 3a — Dùng master user (đơn giản):")
    print("  ELASTICSEARCH_USE_AWS_IAM=false")
    print("  python who_ingestion/scripts/test_es_connection.py")
    print()
    print("Bước 3b — Hoặc map IAM rồi dùng AWS key:")
    print("  python who_ingestion/scripts/setup_fgac_iam_mapping.py")
    print("  ELASTICSEARCH_USE_AWS_IAM=true")
    raise SystemExit(1)


if __name__ == "__main__":
    main()
