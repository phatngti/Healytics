import logging
import numpy as np
from typing import Optional
from sentence_transformers import SentenceTransformer, util

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

        total_phrases = sum(len(v) for v in BUSINESS_TYPE_PHRASES.values())
        logger.info(
            f"[SemanticMatcher] Loaded {len(self.bt_keys)} business types, "
            f"{total_phrases} prototype phrases."
        )

    def match_business_type(self, text: str, threshold: float = 0.45) -> Optional[str]:
        """
        Max-of-prototypes matching:
          score(BT) = max(cos_sim(query, phrase_i) for phrase_i in BT.phrases)

        Chính xác hơn vì query khớp trực tiếp với phrase gần nhất,
        không bị pha loãng bởi embedding trung bình của cả description dài.
        """
        if not text:
            return None

        query_emb = self.model.encode(text, convert_to_tensor=True)

        best_bt: Optional[str] = None
        best_score = -1.0

        for bt_key, phrase_embs in self.bt_phrase_embeddings.items():
            scores = util.cos_sim(query_emb, phrase_embs)[0]
            max_score = float(scores.max())
            if max_score > best_score:
                best_score = max_score
                best_bt = bt_key

        logger.debug(
            f"[SemanticMatcher] '{text[:60]}' -> {best_bt} "
            f"(score={best_score:.4f}, threshold={threshold})"
        )

        if best_score >= threshold:
            return best_bt
        return None


# Singleton
_instance: Optional[SemanticMatcher] = None


def get_matcher() -> SemanticMatcher:
    global _instance
    if _instance is None:
        _instance = SemanticMatcher()
    return _instance
