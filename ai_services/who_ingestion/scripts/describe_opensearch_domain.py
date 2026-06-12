#!/usr/bin/env python3
"""
Đọc cấu hình domain OpenSearch từ AWS API (không cần master password).

Chạy: cd ai_services && python who_ingestion/scripts/describe_opensearch_domain.py
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

DOMAIN = os.getenv("OPENSEARCH_DOMAIN_NAME", "healytics-who")
REGION = os.getenv("AWS_REGION", "ap-southeast-1")


def main() -> None:
    try:
        import boto3
    except ImportError:
        print("Cần boto3: pip install boto3")
        raise SystemExit(1)

    client = boto3.client(
        "opensearch",
        region_name=REGION,
        aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID") or None,
        aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY") or None,
    )

    try:
        resp = client.describe_domain(DomainName=DOMAIN)
    except Exception as exc:
        err = str(exc)
        if "AccessDenied" not in err and "not authorized" not in err:
            print(f"❌ Không đọc được domain '{DOMAIN}': {exc}")
            raise SystemExit(1)
        print(f"❌ IAM user thiếu quyền es:DescribeDomain trên domain '{DOMAIN}'.\n")
        print("Cách 1 — Gắn policy (AWS Console, cần quyền admin IAM):")
        print("  IAM → Users → healytics-who-ingestion → Add permissions")
        print("  → Create inline policy → JSON → dán file:")
        print("  who_ingestion/aws/iam-healytics-who-ingestion-policy.json")
        print("  → Save → chạy lại script này.\n")
        print("Cách 2 — Xem master user không cần API:")
        print("  AWS Console → Amazon OpenSearch Service → Domains → healytics-who")
        print("  → tab Security configuration → mục Fine-grained access control")
        print("  → Master user → copy Username (thường healytics_admin)")
        print("  → Điền vào who_ingestion/.env:")
        print("     ELASTICSEARCH_USERNAME=<username đó>")
        print("     ELASTICSEARCH_PASSWORD=<password khi tạo domain>")
        print("  Quên password → Actions → Edit security configuration → đổi master password")
        raise SystemExit(1)

    status = resp["DomainStatus"]
    endpoints = status.get("Endpoints") or {}
    adv = status.get("AdvancedSecurityOptions") or {}
    master = adv.get("MasterUserOptions") or {}

    print(f"=== Domain: {DOMAIN} ({REGION}) ===\n")
    print(f"Trạng thái:     {status.get('Processing') and 'Processing' or status.get('DomainProcessingStatus', 'Active')}")
    print(f"Engine:         {status.get('EngineVersion')}")
    print(f"FGAC bật:       {adv.get('Enabled', False)}")
    print(f"Master user:    {master.get('MasterUserName', '(không có / dùng IAM only)')}")
    print()
    print("Endpoints:")
    for key, url in endpoints.items():
        print(f"  {key}: {url}")
    if status.get("Endpoint"):
        print(f"  legacy: {status['Endpoint']}")
    print()
    print("--- Giải thích lỗi test_es_connection ---")
    print("401 Unauthorized (basic):")
    print("  → Sai ELASTICSEARCH_USERNAME hoặc ELASTICSEARCH_PASSWORD")
    print("  → 'healytics-who-ingestion' / 'healytics-who' là IAM user, KHÔNG phải master user FGAC")
    print(f"  → Master user đúng thường là: {master.get('MasterUserName', 'xem AWS Console')}")
    print()
    print("403 IAM (security_exception):")
    print("  → IAM đã vào cluster nhưng chưa map FGAC role")
    print("  → Chạy: python who_ingestion/scripts/setup_fgac_iam_mapping.py")
    print("     (cần master user đúng trước)")
    print()
    print("Dashboards (mở browser):")
    ep = endpoints.get("vpc") or endpoints.get("dashboard") or status.get("Endpoint") or ""
    if ep:
        dash = ep if ep.startswith("http") else f"https://{ep}"
        print(f"  {dash}/_dashboards")


if __name__ == "__main__":
    main()
