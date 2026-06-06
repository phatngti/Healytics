"""
domains.py — Định nghĩa 4 nhóm chủ đề crawl WHO (50 tài liệu / nhóm).

Mỗi domain có danh sách keyword tiếng Anh dùng để search trên who.int/publications.
Keyword càng sát domain → PDF crawl được càng relevant cho RAG Healytics.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List


@dataclass(frozen=True)
class WhoDomain:
    key: str  # Mã lưu trong metadata (nutrition, mental_health, ...)
    label_vi: str  # Tên hiển thị tiếng Việt (cho log / báo cáo)
    keywords: List[str]  # Từ khóa search WHO, thử lần lượt đến đủ 50 docs


WHO_DOMAINS: Dict[str, WhoDomain] = {
    "nutrition": WhoDomain(
        key="nutrition",
        label_vi="Dinh dưỡng",
        keywords=[
            "nutrition",
            "healthy diet",
            "nutrition and food safety",
            "malnutrition",
            "obesity",
        ],
    ),
    "physical_activity": WhoDomain(
        key="physical_activity",
        label_vi="Tập luyện",
        keywords=[
            "physical activity",
            "exercise",
            "fitness",
            "sedentary behaviour",
            "healthy lifestyle",
        ],
    ),
    "mental_health": WhoDomain(
        key="mental_health",
        label_vi="Trị liệu tâm lý",
        keywords=[
            "mental health",
            "mental well-being",
            "depression",
            "anxiety",
            "stress",
        ],
    ),
    "wellness": WhoDomain(
        key="wellness",
        label_vi="Spa & Làm đẹp",
        keywords=[
            "healthy ageing",
            "self-care",
            "well-being",
            "quality of life",
            "rehabilitation",
        ],
    ),
}


def all_domain_keys() -> List[str]:
    """Trả danh sách key cho argparse --domain."""
    return list(WHO_DOMAINS.keys())
