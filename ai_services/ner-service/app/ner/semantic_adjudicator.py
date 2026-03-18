from dataclasses import dataclass
from typing import Optional

from app.core.config import settings
from app.ner.semantic_matcher import SemanticMatcher


@dataclass
class SemanticDecision:
    slot: str
    value: str
    score: float
    uncertainty: float
    policy: str  # hard | soft | skip
    rationale: str
    payload: Optional[dict] = None


class SemanticAdjudicator:
    """
    Unified semantic decision layer.

    Candidate generation can differ per slot, but final decision policy and
    output format are standardized here.
    """

    def __init__(self):
        self.bt_high = settings.SEMANTIC_BT_HIGH_THRESHOLD
        self.bt_medium = settings.SEMANTIC_BT_MEDIUM_THRESHOLD
        self.cat_high = settings.SEMANTIC_CATEGORY_HIGH_THRESHOLD
        self.cat_medium = settings.SEMANTIC_CATEGORY_MEDIUM_THRESHOLD
        self.tag_high = settings.SEMANTIC_TAG_HIGH_THRESHOLD
        self.tag_medium = settings.SEMANTIC_TAG_MEDIUM_THRESHOLD

    @staticmethod
    def _policy(score: float, high: float, medium: float) -> str:
        if score >= high:
            return "hard"
        if score >= medium:
            return "soft"
        return "skip"

    def adjudicate_business_type(
        self,
        text: str,
        matcher: SemanticMatcher,
        candidate_keys: list[str],
        semantic_ctx: Optional[dict] = None,
    ) -> Optional[SemanticDecision]:
        query_emb = (semantic_ctx or {}).get("query_emb")
        scored = matcher.score_business_type_candidates(text, candidate_keys, query_emb=query_emb)
        if not scored:
            return None

        best = scored[0]
        score = float(best["score"])
        policy = self._policy(score, self.bt_high, self.bt_medium)
        return SemanticDecision(
            slot="BUSINESS_TYPE",
            value=best["business_type"],
            score=score,
            uncertainty=round(1.0 - score, 4),
            policy=policy,
            rationale=f"Top semantic BT={best['business_type']} with score={score:.4f}",
            payload=best,
        )

    def adjudicate_category(
        self,
        text: str,
        matcher: SemanticMatcher,
        categories: list[dict],
        semantic_ctx: Optional[dict] = None,
    ) -> Optional[SemanticDecision]:
        query_emb = (semantic_ctx or {}).get("query_emb")
        scored = matcher.score_categories(text, categories, query_emb=query_emb)
        if not scored:
            return None

        best = scored[0]
        score = float(best["score"])
        policy = self._policy(score, self.cat_high, self.cat_medium)
        return SemanticDecision(
            slot="CATEGORY",
            value=best["slug"],
            score=score,
            uncertainty=round(1.0 - score, 4),
            policy=policy,
            rationale=f"Top semantic category={best['slug']} with score={score:.4f}",
            payload=best,
        )

    def adjudicate_tags(self, tag_matches: list[dict]) -> list[SemanticDecision]:
        decisions: list[SemanticDecision] = []
        for m in tag_matches:
            score = float(m["score"])
            policy = self._policy(score, self.tag_high, self.tag_medium)
            decisions.append(
                SemanticDecision(
                    slot="FEATURE_TAG",
                    value=m["tag_id"],
                    score=score,
                    uncertainty=round(1.0 - score, 4),
                    policy=policy,
                    rationale=f"Semantic tag={m['tag_name']} score={score:.4f}",
                    payload=m,
                )
            )
        return decisions
