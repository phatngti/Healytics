import os
from unittest.mock import patch


class _LightweightSemanticMatcher:
    """Small test-only matcher to avoid loading heavy transformer weights."""

    _BT_KEYWORDS = {
        "SPA_BEAUTY": ("spa", "lam dep", "làm đẹp", "tham my", "thẩm mỹ"),
        "FITNESS": ("gym", "yoga", "pilates", "fitness", "the hinh", "thể hình"),
        "DENTAL": ("nha", "nha khoa", "nha si", "nha sĩ", "rang", "răng"),
        "MASSAGE_THERAPY": ("massage", "mát xa", "thu gian", "thư giãn"),
        "MASSAGE_REHABILITATION": (
            "vat ly tri lieu",
            "vật lý trị liệu",
            "phuc hoi chuc nang",
            "phục hồi chức năng",
            "tri lieu",
            "trị liệu",
        ),
        "PSYCHOLOGY": ("tam ly", "tâm lý", "stress", "tram cam", "trầm cảm"),
        "PSYCHIATRY": ("tam than", "tâm thần"),
        "DERMATOLOGY": ("da lieu", "da liễu", "mun", "mụn"),
        "NUTRITION": ("dinh duong", "dinh dưỡng", "giam can", "giảm cân"),
        "TRADITIONAL_MEDICINE": ("dong y", "đông y", "cham cuu", "châm cứu"),
        "PHARMACY": ("nha thuoc", "nhà thuốc", "hieu thuoc", "hiệu thuốc", "thuoc", "thuốc"),
    }

    _REHAB_CUES = (
        "tri lieu",
        "trị liệu",
        "vat ly tri lieu",
        "vật lý trị liệu",
        "phuc hoi chuc nang",
        "phục hồi chức năng",
    )

    @staticmethod
    def _norm(text: str) -> str:
        return " ".join((text or "").lower().split())

    def extract_semantic_context(self, text: str) -> dict:
        return {"query_emb": None}

    def match_business_type(self, text: str, threshold: float = 0.45):
        scored = self.score_business_type_candidates(text, list(self._BT_KEYWORDS.keys()))
        if not scored:
            return None
        best = scored[0]
        if float(best["score"]) >= float(threshold):
            return best["business_type"]
        return None

    def score_business_type_candidates(self, text: str, candidates: list[str], query_emb=None) -> list[dict]:
        norm = self._norm(text)
        if not norm or not candidates:
            return []

        results = []
        has_rehab_cue = any(cue in norm for cue in self._REHAB_CUES)
        for bt in candidates:
            keywords = self._BT_KEYWORDS.get(bt, ())
            hits = [k for k in keywords if k in norm]
            if hits:
                # Reward stronger lexical overlap while keeping deterministic, test-only behavior.
                score = 0.75 + min(0.2, 0.05 * len(hits))

                # Disambiguate "massage trị liệu" toward rehabilitation.
                if bt == "MASSAGE_REHABILITATION" and has_rehab_cue:
                    score = max(score, 0.95)
                elif bt == "MASSAGE_THERAPY" and has_rehab_cue:
                    score = min(score, 0.55)
            else:
                score = 0.0
            results.append({"business_type": bt, "score": round(score, 4)})

        results.sort(key=lambda x: x["score"], reverse=True)
        return results

    def match_feature_tags(self, text: str, tags: list[dict], threshold: float = 0.40, top_k: int = 5, query_emb=None) -> list[dict]:
        return []

    def match_category(self, text: str, categories: list[dict], threshold: float = 0.45):
        scored = self.score_categories(text, categories)
        if not scored:
            return None
        best = scored[0]
        if float(best["score"]) >= float(threshold):
            return {"slug": best["slug"], "name": best["name"], "score": best["score"]}
        return None

    def score_categories(self, text: str, categories: list[dict], query_emb=None) -> list[dict]:
        norm = self._norm(text)
        if not norm or not categories:
            return []

        results = []
        for cat in categories:
            name = self._norm(cat.get("name", ""))
            tokens = [t for t in name.split(" ") if len(t) >= 3]
            if tokens and any(t in norm for t in tokens):
                score = 0.72
            else:
                score = 0.0
            results.append({
                "slug": cat.get("slug"),
                "name": cat.get("name"),
                "score": round(score, 4),
            })

        results.sort(key=lambda x: x["score"], reverse=True)
        return results

    def score_location_filter_intent(self, text: str, location_name: str, threshold: float = 0.58) -> dict:
        norm_text = self._norm(text)
        norm_loc = self._norm(location_name)
        has_loc = bool(norm_loc and norm_loc in norm_text)
        filter_cues = (" o ", " ở ", " tai ", " tại ")
        is_filter = has_loc and any(cue in f" {norm_text} " for cue in filter_cues)
        score = 0.75 if is_filter else 0.2
        return {
            "score": round(score, 4),
            "intent": score >= float(threshold),
            "pos_score": round(score, 4),
            "neg_score": round(1.0 - score, 4),
            "margin": round(score - (1.0 - score), 4),
        }


_PATCHERS = []


def pytest_configure(config):
    # Set NER_TEST_USE_REAL_SEMANTIC=1 to run tests with the real transformer model.
    if os.getenv("NER_TEST_USE_REAL_SEMANTIC") == "1":
        return

    matcher = _LightweightSemanticMatcher()

    def _get_matcher():
        return matcher

    targets = [
        "app.ner.semantic_matcher.get_matcher",
        "app.ner.normalizer.get_matcher",
        "app.api.prefilter_routes.get_matcher",
        "app.main.get_matcher",
    ]

    for target in targets:
        patcher = patch(target, new=_get_matcher)
        patcher.start()
        _PATCHERS.append(patcher)


def pytest_unconfigure(config):
    while _PATCHERS:
        _PATCHERS.pop().stop()
