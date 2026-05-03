"""Generated models for audit_controller. Do not edit manually."""

from __future__ import annotations

from typing import Any, TypeAlias


AuditLog: TypeAlias = dict[str, Any]


AuditControllerGetAuditLogsResponseDto: TypeAlias = list[AuditLog]  # GET /admin/audit-logs [200]


__all__ = [
    "AuditLog",
    "AuditControllerGetAuditLogsResponseDto",
]
