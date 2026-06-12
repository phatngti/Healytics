"""
domains.py — 4 nhóm chủ đề Healytics × 50 tài liệu WHO/domain (200 unique).

Mỗi domain có:
  - keywords: tìm who.int + IRIS (đa dạng, tránh overlap)
  - iris_queries: cú pháp Solr/Lucene cho IRIS Discovery
  - hubs_filters: OData filter cho WHO Hubs API (nếu hỗ trợ)
"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, List


@dataclass(frozen=True)
class WhoDomain:
    key: str
    label_vi: str
    keywords: List[str]
    iris_queries: List[str] = field(default_factory=list)
    hubs_title_terms: List[str] = field(default_factory=list)

    def all_search_terms(self) -> List[str]:
        """Danh sách query duy nhất — keywords + iris + hubs."""
        seen: set[str] = set()
        ordered: List[str] = []
        for term in [*self.keywords, *self.iris_queries, *self.hubs_title_terms]:
            norm = term.strip().lower()
            if norm and norm not in seen:
                seen.add(norm)
                ordered.append(term.strip())
        return ordered


WHO_DOMAINS: Dict[str, WhoDomain] = {
    "nutrition": WhoDomain(
        key="nutrition",
        label_vi="Dinh dưỡng",
        keywords=[
            "nutrition policy",
            "healthy diet guidelines",
            "micronutrient deficiency",
            "infant feeding",
            "breastfeeding guidelines",
            "food fortification",
            "obesity prevention children",
            "sodium reduction",
            "sugar intake",
            "malnutrition treatment",
            "dietary guidelines",
            "food safety standards",
            "undernutrition",
            "stunting prevention",
            "anaemia iron deficiency",
        ],
        iris_queries=[
            "subject:nutrition",
            "title:nutrition",
            "subject:\"diet\"",
            "subject:\"food supply\"",
            "title:\"healthy diet\"",
            "subject:malnutrition",
            "title:obesity",
            "subject:breastfeeding",
        ],
        hubs_title_terms=["nutrition", "healthy diet", "malnutrition", "obesity", "breastfeeding"],
    ),
    "physical_activity": WhoDomain(
        key="physical_activity",
        label_vi="Tập luyện",
        keywords=[
            "physical activity guidelines",
            "exercise recommendations",
            "sedentary behaviour",
            "active transport walking",
            "youth physical activity",
            "workplace physical activity",
            "sports for health",
            "fitness promotion",
            "active ageing",
            "community exercise",
            "physical education schools",
            "leisure-time physical activity",
            "musculoskeletal activity",
            "cardiovascular exercise",
            "disability inclusive physical activity",
        ],
        iris_queries=[
            "subject:\"physical activity\"",
            "title:\"physical activity\"",
            "subject:exercise",
            "title:exercise",
            "subject:\"sedentary behavior\"",
            "title:fitness",
            "subject:\"health promotion\" AND exercise",
        ],
        hubs_title_terms=["physical activity", "exercise", "sedentary", "active ageing", "fitness"],
    ),
    "mental_health": WhoDomain(
        key="mental_health",
        label_vi="Trị liệu tâm lý",
        keywords=[
            "mental health action plan",
            "depression treatment guidelines",
            "anxiety disorders management",
            "psychological first aid",
            "suicide prevention",
            "child adolescent mental health",
            "post-traumatic stress",
            "substance use mental health",
            "community mental health services",
            "psychosocial support",
            "cognitive behavioural therapy",
            "mental health workplace",
            "perinatal mental health",
            "dementia mental health",
            "self-help psychological interventions",
        ],
        iris_queries=[
            "subject:\"mental health\"",
            "title:\"mental health\"",
            "subject:depression",
            "subject:anxiety",
            "title:\"psychological\"",
            "subject:psychosocial",
            "title:\"suicide prevention\"",
            "subject:PTSD",
        ],
        hubs_title_terms=["mental health", "depression", "anxiety", "psychological", "psychosocial"],
    ),
    "wellness": WhoDomain(
        key="wellness",
        label_vi="Spa & Làm đẹp / Wellness",
        keywords=[
            "healthy ageing",
            "self-care interventions",
            "well-being guidelines",
            "quality of life health",
            "rehabilitation services",
            "palliative care",
            "skin health sun exposure",
            "cosmetic product safety",
            "spa hygiene standards",
            "massage therapy safety",
            "aesthetic procedures safety",
            "relaxation stress reduction",
            "sleep health guidelines",
            "holistic health promotion",
            "lifestyle medicine",
        ],
        iris_queries=[
            "subject:\"healthy ageing\"",
            "title:\"self-care\"",
            "subject:rehabilitation",
            "subject:well-being",
            "title:wellness",
            "subject:\"quality of life\"",
            "title:palliative",
            "subject:\"skin\" AND health",
        ],
        hubs_title_terms=["healthy ageing", "self-care", "rehabilitation", "well-being", "palliative"],
    ),
}


def all_domain_keys() -> List[str]:
    return list(WHO_DOMAINS.keys())
