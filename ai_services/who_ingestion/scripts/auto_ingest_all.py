#!/usr/bin/env python3
"""
Crawl + ingest toàn bộ WHO corpus vào OpenSearch (không cần S3).

Chạy:
  cd ai_services
  PYTHONUNBUFFERED=1 python -m who_ingestion.scripts.auto_ingest_all

Tuỳ chọn:
  --recreate-index   Xóa và tạo lại index ES (dọn data trùng cũ)
  --append           Crawl thêm doc mới (50/domain), giữ data ES + manifest cũ
  --from-manifest    Bỏ qua crawl, ingest từ manifest có sẵn
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

AI_SERVICES = Path(__file__).resolve().parents[2]


def main() -> None:
    parser = argparse.ArgumentParser(description="Auto crawl + ingest WHO → OpenSearch")
    parser.add_argument("--recreate-index", action="store_true")
    parser.add_argument("--append", action="store_true", help="Batch 2+: thêm doc mới, không trùng manifest cũ")
    parser.add_argument("--from-manifest", type=Path)
    parser.add_argument("--limit", type=int, help="Giới hạn docs/domain (test)")
    args = parser.parse_args()

    import os

    env = dict(os.environ)
    for key in ("HTTP_PROXY", "HTTPS_PROXY", "http_proxy", "https_proxy", "ALL_PROXY", "all_proxy"):
        env.pop(key, None)
    env["NO_PROXY"] = "*"
    if args.recreate_index:
        env["ELASTICSEARCH_RECREATE_INDEX"] = "true"

    cmd = [sys.executable, "-m", "who_ingestion.pipeline", "--all"]
    if args.from_manifest:
        cmd = [sys.executable, "-m", "who_ingestion.pipeline", "--from-manifest", str(args.from_manifest)]
    else:
        if args.append:
            cmd.append("--append")
        if args.limit:
            cmd.extend(["--limit", str(args.limit)])

    print("▶", " ".join(cmd))
    result = subprocess.run(cmd, cwd=AI_SERVICES, env=env)
    raise SystemExit(result.returncode)


if __name__ == "__main__":
    main()
