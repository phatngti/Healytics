import logging
import re
import threading
from dataclasses import dataclass
from typing import Any, Optional

import torch
from cachetools import LRUCache
from sentence_transformers import SentenceTransformer, util

from app.core.config import settings

logger = logging.getLogger(__name__)

DEFAULT_MODEL_NAME = "sentence-transformers/paraphrase-multilingual-mpnet-base-v2"

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
        self.model_name = settings.SEMANTIC_MODEL_NAME.strip() or DEFAULT_MODEL_NAME
        self.use_retrieval_prefix = settings.SEMANTIC_USE_RETRIEVAL_PREFIX or ("e5" in self.model_name.lower())

        logger.info(f"[SemanticMatcher] Loading model {self.model_name}...")
        self.model = SentenceTransformer(self.model_name)
        self.bt_keys = list(BUSINESS_TYPE_PHRASES.keys())
        self._cache_lock = threading.RLock()

        # Encode từng phrase riêng lẻ: {bt_key: tensor[n_phrases, dim]}
        self.bt_phrase_embeddings: dict = {}
        for bt_key, phrases in BUSINESS_TYPE_PHRASES.items():
            self.bt_phrase_embeddings[bt_key] = self._encode_passages(phrases)

        # Tag embedding cache: {tag_id: (content_hash, tensor[n_prototypes, dim])}
        self._tag_emb_cache: dict[str, tuple[str, Any]] = {}
        # Category embedding cache: {slug: (content_hash, tensor)}
        self._cat_emb_cache: dict[str, tuple[str, Any]] = {}
        # Query embedding cache to reduce repeated encode calls for hot queries.
        self._query_emb_cache: LRUCache = LRUCache(maxsize=settings.SEMANTIC_QUERY_CACHE_MAXSIZE)

        total_phrases = sum(len(v) for v in BUSINESS_TYPE_PHRASES.values())
        logger.info(
            f"[SemanticMatcher] Loaded {len(self.bt_keys)} business types, "
            f"{total_phrases} prototype phrases. retrieval_prefix={self.use_retrieval_prefix}"
        )

    def _with_prefix(self, text: str, is_query: bool) -> str:
        if not self.use_retrieval_prefix:
            return text
        prefix = "query: " if is_query else "passage: "
        lowered = text.lower().lstrip()
        if lowered.startswith("query:") or lowered.startswith("passage:"):
            return text
        return f"{prefix}{text}"

    def _encode_query(self, text: str) -> Any:
        return self.model.encode(self._with_prefix(text, is_query=True), convert_to_tensor=True)

    def _encode_passages(self, texts: list[str]) -> Any:
        prepared = [self._with_prefix(t, is_query=False) for t in texts]
        return self.model.encode(prepared, convert_to_tensor=True)

    def extract_semantic_context(self, text: str) -> dict:
        """Extract query-level semantic representation once for downstream slot matching."""
        if not text:
            return {"query_emb": None}
        return {"query_emb": self._resolve_query_embedding(text)}

    def _resolve_query_embedding(self, text: str, query_emb: Any | None = None) -> Any:
        if query_emb is not None:
            return query_emb
        key = " ".join(text.lower().split())
        if not key:
            return self._encode_query(text)

        with self._cache_lock:
            cached = self._query_emb_cache.get(key)
        if cached is not None:
            return cached

        emb = self._encode_query(text)
        with self._cache_lock:
            self._query_emb_cache[key] = emb
        return emb

    def _get_category_embeddings(self, categories: list[dict]) -> Any:
        """Return stacked category embeddings in the same order as input categories."""
        new_cats: list[dict] = []
        new_texts: list[str] = []
        for cat in categories:
            content_hash = f"cat|{cat['slug']}|{cat['name']}"
            with self._cache_lock:
                cached = self._cat_emb_cache.get(cat["slug"])
            if cached is None or cached[0] != content_hash:
                new_cats.append(cat)
                new_texts.append(cat["name"])

        if new_texts:
            new_embs = self._encode_passages(new_texts)
            for cat, emb in zip(new_cats, new_embs):
                content_hash = f"cat|{cat['slug']}|{cat['name']}"
                with self._cache_lock:
                    self._cat_emb_cache[cat["slug"]] = (content_hash, emb)

        with self._cache_lock:
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
        threshold: float = 0.40,
        top_k: int = 5,
        query_emb: Any | None = None,
    ) -> list[dict]:
        """
        Match query text against feature tags từ DB.

        Mỗi tag được encode theo multi-prototype (name + các cụm mô tả ngắn),
        score(tag) = max(cos_sim(query, prototype_i)).
        Embeddings được cache theo content để tránh re-encode cho tag không đổi.

        Returns: list[{tag_id, tag_name, score}] sorted by score desc, >= threshold.
        """
        if not text or not tags:
            return []

        query_emb = self._resolve_query_embedding(text, query_emb=query_emb)

        results = []
        for t in tags:
            prototypes = self._resolve_tag_prototypes(t)
            content_hash = f"{t['id']}|{'|'.join(prototypes)}"

            with self._cache_lock:
                cached = self._tag_emb_cache.get(t["id"])

            if cached is None or cached[0] != content_hash:
                proto_embs = self._encode_passages(prototypes)
                with self._cache_lock:
                    self._tag_emb_cache[t["id"]] = (content_hash, proto_embs)
            else:
                proto_embs = cached[1]

            s = float(util.cos_sim(query_emb, proto_embs)[0].max())
            effective_threshold = self._effective_tag_threshold(t, threshold)
            if s >= effective_threshold:
                results.append({
                    "tag_id": t["id"],
                    "tag_name": t["name"],
                    "score": round(s, 4),
                })

        results.sort(key=lambda x: x["score"], reverse=True)
        matched = results[:top_k]

        logger.debug(
            f"[SemanticMatcher] match_feature_tags '{text[:50]}' -> "
            f"{[m['tag_name'] for m in matched]}"
        )
        return matched

    def prewarm_tags(self, tags: list[dict]) -> None:
        """
        Precompute tag prototype embeddings outside request path, then hot-swap cache atomically.
        Intended to be called from background refresh tasks.
        """
        if not tags:
            return

        with self._cache_lock:
            old_cache = dict(self._tag_emb_cache)

        new_cache: dict[str, tuple[str, Any]] = {}
        reused = 0
        encoded = 0

        for t in tags:
            tag_id = str(t.get("id") or "")
            if not tag_id:
                continue

            prototypes = self._resolve_tag_prototypes(t)
            content_hash = f"{tag_id}|{'|'.join(prototypes)}"

            old_entry = old_cache.get(tag_id)
            if old_entry and old_entry[0] == content_hash:
                new_cache[tag_id] = old_entry
                reused += 1
                continue

            proto_embs = self._encode_passages(prototypes)
            new_cache[tag_id] = (content_hash, proto_embs)
            encoded += 1

        with self._cache_lock:
            self._tag_emb_cache = new_cache

        logger.info(
            "[SemanticMatcher] Hot-swapped tag embeddings: total=%s reused=%s encoded=%s",
            len(new_cache),
            reused,
            encoded,
        )

    @staticmethod
    def _effective_tag_threshold(tag: dict, base_threshold: float) -> float:
        """
        Dynamic threshold:
          - If metadata exists (idf_score / match_weight), use it directly.
          - Otherwise use a lexical-specificity heuristic to tighten generic tags.
        """
        idf_score = tag.get("idf_score")
        if isinstance(idf_score, (int, float)):
            return max(0.2, min(0.9, base_threshold + (0.5 - float(idf_score)) * 0.2))

        match_weight = tag.get("match_weight")
        if isinstance(match_weight, (int, float)):
            return max(0.2, min(0.9, base_threshold + (0.5 - float(match_weight)) * 0.2))

        name = str(tag.get("name") or "").strip().lower()
        token_count = len(re.findall(r"\w+", name))
        generic_terms = {
            "thu gian", "thư giãn", "lam sach", "làm sạch", "cham soc", "chăm sóc",
            "co ban", "cơ bản", "dich vu", "dịch vụ",
        }
        is_generic = name in generic_terms

        delta = 0.0
        if is_generic:
            delta += 0.10
        if token_count <= 2:
            delta += 0.05
        if token_count >= 4:
            delta -= 0.03

        return max(0.25, min(0.85, base_threshold + delta))

    @staticmethod
    def _build_tag_prototypes(tag: dict) -> list[str]:
        """Build compact prototype phrases from tag name/description."""
        name = str(tag.get("name") or "").strip()
        description = str(tag.get("description") or "").strip()

        prototypes: list[str] = []
        if name:
            prototypes.append(name)

        if description:
            for part in re.split(r"[\.;\n,]+", description):
                p = " ".join(part.strip().split())
                if len(p) >= 3:
                    prototypes.append(p)
                if len(prototypes) >= 3:
                    break

        # Keep deterministic order while removing duplicates.
        deduped: list[str] = []
        seen: set[str] = set()
        for p in prototypes:
            k = p.lower()
            if k in seen:
                continue
            seen.add(k)
            deduped.append(p)

        return deduped or [name or "unknown"]

    @classmethod
    def _resolve_tag_prototypes(cls, tag: dict) -> list[str]:
        raw = tag.get("search_prototypes")
        if isinstance(raw, list):
            protos = [str(p).strip() for p in raw if str(p).strip()]
            if protos:
                return protos
        return cls._build_tag_prototypes(tag)

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

_OR_PATTERN = re.compile(r'\b(?:hoặc|or|hay)\b', re.IGNORECASE)
_AND_PATTERN = re.compile(r'\b(?:và|kết hợp|cùng|với)\b|,', re.IGNORECASE)
_AND_SPLIT = re.compile(r'\s*(?:,|\b(?:và|kết hợp|cùng|với)\b)\s*', re.IGNORECASE)
_NEGATION_PATTERN = re.compile(
    r'\b(?:không|ko|chua|chưa|tru|trừ|ngoại\s+trừ|không\s+cần|không\s+muốn)\b',
    re.IGNORECASE,
)


def group_tag_filters(text: str, matches: list[dict]) -> list[dict]:
    groups, _ = group_tag_filters_with_meta(text, matches)
    return groups


def group_tag_filters_with_meta(text: str, matches: list[dict]) -> tuple[list[dict], dict]:
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
        return [], {"implicit_and": False, "has_negation": False}

    positive_matches: list[dict] = []
    negated_matches: list[dict] = []
    for m in matches:
        if _is_negated_tag(text, m.get("tag_name", "")):
            negated_matches.append(m)
        else:
            positive_matches.append(m)

    ids = [m["tag_id"] for m in positive_matches]
    has_or  = bool(_OR_PATTERN.search(text))
    has_and = bool(_AND_PATTERN.search(text))
    implicit_and = False
    groups: list[dict] = []

    if ids:
        if not has_and and not has_or:
            if len(ids) > 1:
                # Multiple disjoint intents without explicit connector are usually conjunctive.
                groups.extend({"ids": [id_], "op": "AND"} for id_ in ids)
                implicit_and = True
            else:
                groups.append({"ids": ids, "op": "OR"})

        elif has_or and not has_and:
            groups.append({"ids": ids, "op": "OR"})

        elif has_and and not has_or:
            groups.extend({"ids": [id_], "op": "AND"} for id_ in ids)

        else:
            # Có cả AND và OR: split by AND connector, kiểm tra OR trong từng segment
            segments = _AND_SPLIT.split(text)
            assigned: set[str] = set()

            for seg in segments:
                seg_lower = seg.lower()
                seg_ids = [
                    m["tag_id"] for m in positive_matches
                    if m["tag_id"] not in assigned and m["tag_name"].lower() in seg_lower
                ]
                for id_ in seg_ids:
                    assigned.add(id_)

                if not seg_ids:
                    continue

                if _OR_PATTERN.search(seg):
                    groups.append({"ids": seg_ids, "op": "OR"})
                else:
                    groups.extend({"ids": [id_], "op": "AND"} for id_ in seg_ids)

            remaining = [m["tag_id"] for m in positive_matches if m["tag_id"] not in assigned]
            if remaining:
                groups.append({"ids": remaining, "op": "OR"})

    # Apply negated tags as exclusion filters.
    if negated_matches:
        groups.append({"ids": [m["tag_id"] for m in negated_matches], "op": "NOT"})

    if not groups and not ids and negated_matches:
        # Query with only negative constraints.
        groups = [{"ids": [m["tag_id"] for m in negated_matches], "op": "NOT"}]

    if not groups and ids:
        groups = [{"ids": ids, "op": "OR"}]

    return groups, {"implicit_and": implicit_and, "has_negation": bool(negated_matches)}


def _is_negated_tag(text: str, tag_name: str) -> bool:
    if not text or not tag_name:
        return False

    norm_text = " ".join(text.lower().split())
    tag_pattern = re.escape(" ".join(tag_name.lower().split())).replace(r"\ ", r"\s+")

    before_pat = re.compile(
        rf"{_NEGATION_PATTERN.pattern}(?:\W+\w+){{0,4}}\W+{tag_pattern}",
        re.IGNORECASE,
    )
    after_pat = re.compile(
        rf"{tag_pattern}(?:\W+\w+){{0,3}}\W+{_NEGATION_PATTERN.pattern}",
        re.IGNORECASE,
    )

    return bool(before_pat.search(norm_text) or after_pat.search(norm_text))
