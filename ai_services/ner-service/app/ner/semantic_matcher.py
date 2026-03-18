import logging
import re
from dataclasses import dataclass
from typing import Any, Optional

import numpy as np
import torch
from sentence_transformers import SentenceTransformer, util

from app.core.config import settings

logger = logging.getLogger(__name__)

MODEL_NAME = "sentence-transformers/paraphrase-multilingual-mpnet-base-v2"

# Multi-prototype descriptors.
# Mỗi BT có nhiều phrase ngắn → encode riêng → score = max(similarity(query, phrase_i))
# Hiệu quả hơn hẳn so với 1 string dài vì tránh "embedding trung bình bị pha loãng".
BUSINESS_TYPE_PHRASES: dict[str, list[str]] = {
    "SPA_BEAUTY": [
        "spa làm đẹp thẩm mỹ viện nail",
        "chăm sóc da dưỡng da trẻ hóa da",
        "waxing lông mày làm móng tay chân",
        "tôi muốn chăm sóc làm đẹp bản thân",
    ],
    "FITNESS": [
        "gym yoga pilates thể hình cardio",
        "tập gym thể dục thể thao",
        "giảm mỡ tăng cơ giữ dáng vóc",
        "tôi muốn tập luyện thể dục thể thao",
    ],
    "DENTAL": [
        "nha khoa nha sĩ bác sĩ răng",
        "nhổ răng trám răng niềng răng trồng răng implant",
        "đau răng ê buốt sâu răng vỡ răng nhổ răng khôn",
        "viêm nướu chảy máu nướu tẩy trắng răng răng sứ",
        "tôi bị đau răng muốn đi khám nha khoa",
        "răng đau quá cần đi nhổ hoặc trám lại",
    ],
    "MASSAGE_THERAPY": [
        "massage thư giãn mát xa xoa bóp",
        "foot massage massage toàn thân đầu vai",
        "tôi muốn đi massage thư giãn giải tỏa",
        "thư giãn cơ thể giảm mệt mỏi căng thẳng",
    ],
    "MASSAGE_REHABILITATION": [
        "vật lý trị liệu phục hồi chức năng",
        "nắn xương khớp trị liệu cột sống",
        "đau lưng mỏi lưng đau cổ vai gáy đau khớp",
        "thoát vị đĩa đệm tê bì tay chân đau thần kinh tọa",
        "tôi bị đau lưng muốn đi vật lý trị liệu",
        "đau vai cứng cổ đau nhức xương khớp cần trị liệu",
    ],
    "PSYCHOLOGY": [
        "tư vấn tâm lý trị liệu tâm lý chuyên gia tâm lý",
        "stress lo âu trầm cảm burnout",
        "mất ngủ khủng hoảng tâm lý sức khỏe tâm thần",
        "tôi đang bị căng thẳng lo lắng cần tư vấn",
        "tôi cảm thấy buồn mệt mỏi tinh thần muốn gặp chuyên gia",
    ],
    "PSYCHIATRY": [
        "tâm thần kinh chuyên khoa tâm thần",
        "rối loạn tâm thần tâm thần phân liệt",
        "bệnh viện tâm thần điều trị tâm thần",
    ],
    "DERMATOLOGY": [
        "da liễu bác sĩ da laser da trị liệu da",
        "trị mụn trị nám thẩm mỹ da chăm sóc da",
        "mụn trứng cá da dầu da khô dị ứng da viêm da",
        "tôi bị nổi mụn dị ứng ngứa da muốn đi khám da liễu",
    ],
    "NUTRITION": [
        "dinh dưỡng tư vấn dinh dưỡng chuyên gia dinh dưỡng",
        "giảm cân ăn kiêng kiểm soát cân nặng",
        "béo phì thừa cân chế độ ăn healthy",
        "tôi muốn giảm cân cần tư vấn ăn uống đúng cách",
    ],
    "TRADITIONAL_MEDICINE": [
        "đông y châm cứu bấm huyệt y học cổ truyền",
        "bốc thuốc nam thuốc bắc cạo gió giác hơi",
        "tôi muốn châm cứu đông y chữa bệnh",
        "tôi muốn dùng thuốc nam thuốc bắc trị bệnh tự nhiên",
    ],
    "PHARMACY": [
        "nhà thuốc hiệu thuốc quầy thuốc",
        "mua thuốc dược phẩm đơn thuốc",
        "tôi cần mua thuốc tìm nhà thuốc gần đây",
    ],
}


class SemanticMatcher:
    def __init__(self):
        logger.info(f"[SemanticMatcher] Loading model {MODEL_NAME}...")
        self.model = SentenceTransformer(MODEL_NAME)
        self.bt_keys = list(BUSINESS_TYPE_PHRASES.keys())

        # Encode từng phrase riêng lẻ: {bt_key: tensor[n_phrases, dim]}
        self.bt_phrase_embeddings: dict = {}
        for bt_key, phrases in BUSINESS_TYPE_PHRASES.items():
            self.bt_phrase_embeddings[bt_key] = self.model.encode(
                phrases, convert_to_tensor=True
            )

        # Tag embedding cache: {tag_id: (content_hash, tensor)} — tránh re-encode
        self._tag_emb_cache: dict[str, tuple[str, Any]] = {}
        # Category embedding cache: {slug: (content_hash, tensor)}
        self._cat_emb_cache: dict[str, tuple[str, Any]] = {}
        # Location-intent embedding cache: {location_name: {"pos": tensor, "neg": tensor}}
        self._loc_intent_cache: dict[str, dict[str, Any]] = {}

        total_phrases = sum(len(v) for v in BUSINESS_TYPE_PHRASES.values())
        logger.info(
            f"[SemanticMatcher] Loaded {len(self.bt_keys)} business types, "
            f"{total_phrases} prototype phrases."
        )

    def extract_semantic_context(self, text: str) -> dict:
        """Extract query-level semantic representation once for downstream slot matching."""
        if not text:
            return {"query_emb": None}
        return {"query_emb": self.model.encode(text, convert_to_tensor=True)}

    def _resolve_query_embedding(self, text: str, query_emb: Any | None = None) -> Any:
        if query_emb is not None:
            return query_emb
        return self.model.encode(text, convert_to_tensor=True)

    def _get_category_embeddings(self, categories: list[dict]) -> Any:
        """Return stacked category embeddings in the same order as input categories."""
        new_cats: list[dict] = []
        new_texts: list[str] = []
        for cat in categories:
            content_hash = f"cat|{cat['slug']}|{cat['name']}"
            cached = self._cat_emb_cache.get(cat["slug"])
            if cached is None or cached[0] != content_hash:
                new_cats.append(cat)
                new_texts.append(cat["name"])

        if new_texts:
            new_embs = self.model.encode(new_texts, convert_to_tensor=True)
            for cat, emb in zip(new_cats, new_embs):
                content_hash = f"cat|{cat['slug']}|{cat['name']}"
                self._cat_emb_cache[cat["slug"]] = (content_hash, emb)

        return torch.stack([self._cat_emb_cache[cat["slug"]][1] for cat in categories])

    def match_business_type(self, text: str, threshold: float = 0.45) -> Optional[str]:
        """
        Max-of-prototypes matching:
          score(BT) = max(cos_sim(query, phrase_i) for phrase_i in BT.phrases)

        Chính xác hơn vì query khớp trực tiếp với phrase gần nhất,
        không bị pha loãng bởi embedding trung bình của cả description dài.
        """
        scored = self.score_business_type_candidates(text, self.bt_keys)
        if not scored:
            return None

        best_bt = scored[0]["business_type"]
        best_score = float(scored[0]["score"])

        logger.debug(
            f"[SemanticMatcher] '{text[:60]}' -> {best_bt} "
            f"(score={best_score:.4f}, threshold={threshold})"
        )

        if best_score >= threshold:
            return best_bt
        return None

    def score_business_type_candidates(self, text: str, candidates: list[str], query_emb: Any | None = None) -> list[dict]:
        """Score business type candidates and return sorted list by score desc."""
        if not text or not candidates:
            return []

        query_emb = self._resolve_query_embedding(text, query_emb=query_emb)
        results: list[dict] = []
        for bt_key in candidates:
            phrase_embs = self.bt_phrase_embeddings.get(bt_key)
            if phrase_embs is None:
                continue
            score = float(util.cos_sim(query_emb, phrase_embs)[0].max())
            results.append({"business_type": bt_key, "score": round(score, 4)})

        results.sort(key=lambda x: x["score"], reverse=True)
        return results

    def match_feature_tags(
        self,
        text: str,
        tags: list[dict],
        threshold: float = 0.35,
        top_k: int = 5,
        query_emb: Any | None = None,
    ) -> list[dict]:
        """
        Match query text against feature tags từ DB.

        Mỗi tag được encode dưới dạng "name. description" (nếu có description)
        hoặc chỉ "name". Embeddings được cache theo content để tránh re-encode
        cho các tag không thay đổi.

        Returns: list[{tag_id, tag_name, score}] sorted by score desc, >= threshold.
        """
        if not text or not tags:
            return []

        query_emb = self._resolve_query_embedding(text, query_emb=query_emb)

        # Tìm tags cần encode mới (chưa có trong cache hoặc content thay đổi)
        new_tags_idx: list[int] = []
        new_tags_text: list[str] = []
        for idx, t in enumerate(tags):
            tag_text = (
                f"{t['name']}. {t['description']}".strip()
                if t.get("description") else t["name"]
            )
            content_hash = f"{t['id']}|{tag_text}"
            cached = self._tag_emb_cache.get(t["id"])
            if cached is None or cached[0] != content_hash:
                new_tags_idx.append(idx)
                new_tags_text.append(tag_text)

        # Batch encode tags mới
        if new_tags_text:
            new_embs = self.model.encode(new_tags_text, convert_to_tensor=True)
            for pos, idx in enumerate(new_tags_idx):
                t = tags[idx]
                tag_text = new_tags_text[pos]
                content_hash = f"{t['id']}|{tag_text}"
                self._tag_emb_cache[t["id"]] = (content_hash, new_embs[pos])

        # Build tensor của tất cả tag embeddings (theo thứ tự tags)
        tag_emb_list = [self._tag_emb_cache[t["id"]][1] for t in tags]
        tag_embs = torch.stack(tag_emb_list)

        scores = util.cos_sim(query_emb, tag_embs)[0]

        results = []
        for i, score in enumerate(scores):
            s = float(score)
            if s >= threshold:
                results.append({
                    "tag_id": tags[i]["id"],
                    "tag_name": tags[i]["name"],
                    "score": round(s, 4),
                })

        results.sort(key=lambda x: x["score"], reverse=True)
        matched = results[:top_k]

        logger.debug(
            f"[SemanticMatcher] match_feature_tags '{text[:50]}' -> "
            f"{[m['tag_name'] for m in matched]}"
        )
        return matched

    def match_category(
        self,
        text: str,
        categories: list[dict],
        threshold: float = 0.45,
    ) -> Optional[dict]:
        """
        Tìm category phù hợp nhất với query text bằng semantic similarity.
        Dùng để fallback khi underthesea NER không detect được CATEGORY.

        categories: list[{slug, name}] từ cache.get_category_list()

        Returns: {slug, name, score} hoặc None nếu không có category nào vượt threshold.
        """
        scored = self.score_categories(text, categories)
        if not scored:
            return None

        best = scored[0]
        best_score = float(best["score"])

        logger.debug(
            f"[SemanticMatcher] match_category '{text[:50]}' -> "
            f"{best['slug']} (score={best_score:.4f})"
        )

        if best_score >= threshold:
            return {
                "slug":  best["slug"],
                "name":  best["name"],
                "score": round(best_score, 4),
            }
        return None

    def score_categories(self, text: str, categories: list[dict], query_emb: Any | None = None) -> list[dict]:
        """Score all category candidates and return sorted list by score desc."""
        if not text or not categories:
            return []

        query_emb = self._resolve_query_embedding(text, query_emb=query_emb)

        cat_embs = self._get_category_embeddings(categories)
        scores = util.cos_sim(query_emb, cat_embs)[0]

        results = [
            {
                "slug": cat["slug"],
                "name": cat["name"],
                "score": round(float(scores[i]), 4),
            }
            for i, cat in enumerate(categories)
        ]
        results.sort(key=lambda x: x["score"], reverse=True)
        return results

    def score_location_filter_intent(
        self,
        text: str,
        location_name: str,
        threshold: float = 0.58,
    ) -> dict:
        """
        Score whether user intends to FILTER by location, not just mention it.

        Uses semantic margin between:
          - Positive hypotheses: "search constrained to <location>"
          - Negative hypotheses: "location only as context, no filtering"

        Returns dict with score in [0,1], boolean intent, and diagnostics.
        """
        if not text or not location_name:
            return {
                "score": 0.0,
                "intent": False,
                "pos_score": 0.0,
                "neg_score": 0.0,
                "margin": -1.0,
            }

        query_emb = self.model.encode(text, convert_to_tensor=True)
        hyp_embs = self._get_location_intent_hypothesis_embeddings(location_name)

        pos_scores = util.cos_sim(query_emb, hyp_embs["pos"])[0]
        neg_scores = util.cos_sim(query_emb, hyp_embs["neg"])[0]

        pos = float(pos_scores.max())
        neg = float(neg_scores.max())
        margin = pos - neg

        # Convert semantic margin to probability-like score.
        score = float(1.0 / (1.0 + np.exp(-6.0 * margin)))
        intent = score >= threshold

        logger.debug(
            "[SemanticMatcher] location_intent '%s' @ '%s' -> score=%.4f pos=%.4f neg=%.4f margin=%.4f",
            text[:60],
            location_name,
            score,
            pos,
            neg,
            margin,
        )

        return {
            "score": round(score, 4),
            "intent": intent,
            "pos_score": round(pos, 4),
            "neg_score": round(neg, 4),
            "margin": round(margin, 4),
        }

    def _get_location_intent_hypothesis_embeddings(self, location_name: str) -> dict[str, Any]:
        cached = self._loc_intent_cache.get(location_name)
        if cached is not None:
            return cached

        pos_hypotheses = [
            f"Người dùng muốn tìm dịch vụ ở {location_name}.",
            f"Địa điểm {location_name} là điều kiện lọc bắt buộc của truy vấn.",
            f"Kết quả cần giới hạn trong khu vực {location_name}.",
            f"Người dùng đang yêu cầu tìm theo vị trí tại {location_name}.",
        ]
        neg_hypotheses = [
            f"Người dùng chỉ nhắc đến {location_name} như thông tin nền, không phải bộ lọc.",
            f"Đề bài không yêu cầu giới hạn kết quả theo {location_name}.",
            f"{location_name} chỉ là ngữ cảnh cá nhân, tìm kiếm không ràng buộc vị trí.",
            f"Người dùng nói về {location_name} nhưng vẫn muốn tìm dịch vụ chung.",
        ]

        cached = {
            "pos": self.model.encode(pos_hypotheses, convert_to_tensor=True),
            "neg": self.model.encode(neg_hypotheses, convert_to_tensor=True),
        }
        self._loc_intent_cache[location_name] = cached
        return cached


# Singleton
_instance: Optional[SemanticMatcher] = None


def get_matcher() -> SemanticMatcher:
    global _instance
    if _instance is None:
        _instance = SemanticMatcher()
    return _instance


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


# ── AND/OR group builder ──────────────────────────────────────────────────────

_OR_PATTERN = re.compile(r'\bhoặc\b|\bor\b', re.IGNORECASE)
_AND_PATTERN = re.compile(r'\b(?:và|kết hợp|cùng)\b', re.IGNORECASE)
_AND_SPLIT   = re.compile(r'\s+(?:và|kết hợp|cùng)\s+', re.IGNORECASE)


def group_tag_filters(text: str, matches: list[dict]) -> list[dict]:
    """
    Nhóm matched tags thành các AND/OR filter groups dựa trên từ kết nối trong query.

    Cấu trúc trả về:
        [{"ids": [...], "op": "OR"}, {"ids": [...], "op": "AND"}, ...]

    Tất cả các group được AND với nhau trong SQL WHERE.

    Quy tắc:
        - Chỉ "hoặc/or"     → 1 OR group (tất cả tags)
        - Chỉ "và/kết hợp"  → mỗi tag là 1 AND group (product phải có tất cả)
        - Cả 2              → split theo "và", mỗi segment check "hoặc" → OR/AND
        - Không có connector → 1 OR group (mặc định, kết quả rộng hơn)
    """
    if not matches:
        return []

    ids = [m["tag_id"] for m in matches]
    has_or  = bool(_OR_PATTERN.search(text))
    has_and = bool(_AND_PATTERN.search(text))

    if not has_and and not has_or:
        # Không có connector rõ ràng → OR (broad search)
        return [{"ids": ids, "op": "OR"}]

    if has_or and not has_and:
        return [{"ids": ids, "op": "OR"}]

    if has_and and not has_or:
        return [{"ids": [id_], "op": "AND"} for id_ in ids]

    # Có cả AND và OR: split by AND connector, kiểm tra OR trong từng segment
    # Assign each matched tag to the segment whose text it appears in
    segments = _AND_SPLIT.split(text)
    groups: list[dict] = []
    assigned: set[str] = set()

    for seg in segments:
        seg_lower = seg.lower()
        seg_ids = [
            m["tag_id"] for m in matches
            if m["tag_id"] not in assigned and m["tag_name"].lower() in seg_lower
        ]
        for id_ in seg_ids:
            assigned.add(id_)

        if not seg_ids:
            continue

        if _OR_PATTERN.search(seg):
            groups.append({"ids": seg_ids, "op": "OR"})
        else:
            for id_ in seg_ids:
                groups.append({"ids": [id_], "op": "AND"})

    # Fallback: tags không khớp với bất kỳ segment nào → OR group
    remaining = [m["tag_id"] for m in matches if m["tag_id"] not in assigned]
    if remaining:
        groups.append({"ids": remaining, "op": "OR"})

    return groups if groups else [{"ids": ids, "op": "OR"}]
