"""Generated models for s3_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class DeleteFileResponseDto(DtoModel):
    message: str


@dataclass(slots=True)
class FileUrlResponseDto(DtoModel):
    url: str


@dataclass(slots=True)
class PresignRequestDto(DtoModel):
    fileName: str
    contentType: str


@dataclass(slots=True)
class PresignResponseDto(DtoModel):
    uploadUrl: str
    key: str


__all__ = [
    "DeleteFileResponseDto",
    "FileUrlResponseDto",
    "PresignRequestDto",
    "PresignResponseDto",
]
