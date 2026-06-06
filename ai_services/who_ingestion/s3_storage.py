"""
s3_storage.py — Upload / tải PDF WHO lên AWS S3.

Cấu trúc object key:
  {S3_PREFIX}/{domain}/{publication_id}/{filename}.pdf

Ví dụ:
  who-publications/nutrition/a1b2c3d4e5f6/nutrition_a1b2c3d4e5f6.pdf

IAM user cần quyền: PutObject, GetObject, HeadObject, ListBucket (xem HUONG_DAN_SETUP_AWS.md).
"""

from __future__ import annotations

from pathlib import Path

import boto3
from botocore.exceptions import ClientError

from who_ingestion.config import WhoIngestionSettings


class WhoS3Storage:
    def __init__(self, settings: WhoIngestionSettings) -> None:
        self.settings = settings
        session_kwargs = {"region_name": settings.aws_region}
        if settings.aws_access_key_id and settings.aws_secret_access_key:
            session_kwargs["aws_access_key_id"] = settings.aws_access_key_id
            session_kwargs["aws_secret_access_key"] = settings.aws_secret_access_key

        self._client = boto3.client(
            "s3",
            endpoint_url=settings.s3_endpoint_url or None,
            **session_kwargs,
        )

    def build_object_key(self, domain: str, publication_id: str, filename: str) -> str:
        """Ghép key chuẩn — domain giúp phân loại khi audit S3."""
        prefix = self.settings.s3_prefix.rstrip("/")
        return f"{prefix}/{domain}/{publication_id}/{filename}"

    def upload_file(self, local_path: Path, object_key: str) -> str:
        """Upload PDF local → S3. Trả URI dạng s3://bucket/key."""
        if not self.settings.s3_enabled:
            raise ValueError("S3_BUCKET is not configured.")

        try:
            self._client.upload_file(
                str(local_path),
                self.settings.s3_bucket,
                object_key,
                ExtraArgs={"ContentType": "application/pdf"},
            )
        except ClientError as exc:
            raise RuntimeError(f"S3 upload failed for {object_key}: {exc}") from exc

        return f"s3://{self.settings.s3_bucket}/{object_key}"

    def download_file(self, object_key: str, local_path: Path) -> Path:
        """Tải PDF từ S3 về local (dùng khi re-ingest không crawl lại)."""
        local_path.parent.mkdir(parents=True, exist_ok=True)
        self._client.download_file(self.settings.s3_bucket, object_key, str(local_path))
        return local_path

    def object_exists(self, object_key: str) -> bool:
        """Kiểm tra đã upload chưa — tránh upload trùng khi chạy lại pipeline."""
        try:
            self._client.head_object(Bucket=self.settings.s3_bucket, Key=object_key)
            return True
        except ClientError:
            return False
