#!/usr/bin/env python3
"""
Map IAM user healytics-who-ingestion vào role all_access (FGAC).

Cần master user đúng trong .env (ELASTICSEARCH_USERNAME / PASSWORD).
Sau khi chạy thành công → ELASTICSEARCH_USE_AWS_IAM=true hoạt động.

Chạy: cd ai_services && python who_ingestion/scripts/setup_fgac_iam_mapping.py
"""

from __future__ import annotations

import json
import os
import sys
from pathlib import Path

AI_SERVICES_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(AI_SERVICES_ROOT))

from dotenv import load_dotenv

load_dotenv(AI_SERVICES_ROOT / "who_ingestion" / ".env")

from common.es_client import build_elasticsearch_client, candidate_elasticsearch_urls

IAM_ARN = os.getenv(
    "OPENSEARCH_IAM_USER_ARN",
    "arn:aws:iam::206193621163:user/healytics-who-ingestion",
)
ROLE = os.getenv("OPENSEARCH_FGAC_ROLE", "all_access")


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
    username = os.getenv("ELASTICSEARCH_USERNAME", "").strip()
    password = os.getenv("ELASTICSEARCH_PASSWORD", "").strip()
    if not username or not password:
        print("❌ Thiếu ELASTICSEARCH_USERNAME / ELASTICSEARCH_PASSWORD (master user FGAC)")
        raise SystemExit(1)

    creds = _creds()
    urls = candidate_elasticsearch_urls(os.getenv("ELASTICSEARCH_URL", ""))

    es = None
    used_url = ""
    for url in urls:
        try:
            es = build_elasticsearch_client(url=url, force_iam=False, **creds)
            es.info()
            used_url = url
            break
        except Exception:
            continue

    if es is None:
        print("❌ Master user không đăng nhập được (401).")
        print("   1. Chạy: python who_ingestion/scripts/describe_opensearch_domain.py")
        print("   2. Lấy đúng MasterUserName từ AWS")
        print("   3. AWS Console → OpenSearch → healytics-who → Edit → đổi master password nếu quên")
        raise SystemExit(1)

    print(f"✅ Master user OK — {used_url}\n")

    path = f"/_plugins/_security/api/rolesmapping/{ROLE}"
    try:
        current = es.transport.perform_request("GET", path)
    except Exception as exc:
        print(f"❌ Không đọc role mapping '{ROLE}': {exc}")
        raise SystemExit(1)

    users = list(current.get("users", []) or [])
    if IAM_ARN in users:
        print(f"ℹ️  IAM ARN đã có trong role '{ROLE}':")
        print(f"   {IAM_ARN}")
        print("\n→ Thử lại: ELASTICSEARCH_USE_AWS_IAM=true && python who_ingestion/scripts/test_es_connection.py")
        return

    users.append(IAM_ARN)
    body = {
        "users": users,
        "backend_roles": current.get("backend_roles", []),
        "hosts": current.get("hosts", []),
    }

    try:
        es.transport.perform_request("PUT", path, body=body)
    except Exception as exc:
        print(f"❌ Không ghi role mapping: {exc}")
        print("\nMap thủ công trong Dashboards:")
        print(f"  Security → Roles → {ROLE} → Mapped users → Add: {IAM_ARN}")
        raise SystemExit(1)

    print(f"✅ Đã map IAM user vào role '{ROLE}':")
    print(f"   {IAM_ARN}")
    print("\n→ Cập nhật .env:")
    print(f"   ELASTICSEARCH_URL={used_url}")
    print("   ELASTICSEARCH_USE_AWS_IAM=true")
    print("\n→ Kiểm tra: python who_ingestion/scripts/test_es_connection.py")


if __name__ == "__main__":
    main()
