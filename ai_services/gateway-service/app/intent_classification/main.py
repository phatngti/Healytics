from sentence_transformers import SentenceTransformer
from sklearn.linear_model import LogisticRegression
import joblib
import os

_model = None
_clf = None

BASE_DIR = os.path.dirname(__file__)
MODEL_DIR = os.path.join(BASE_DIR, "models")

def load_model():
    global _model, _clf
    if _model is None:
        _model = SentenceTransformer(
            os.path.join(MODEL_DIR, "intent_encoder"),
            device="cpu"  
        )
    if _clf is None:
        _clf = joblib.load(os.path.join(MODEL_DIR, "intent_classifier.pkl"))
    return _model, _clf

def predict_intent(text: str, model, clf) -> bool:
    """Trả về True nếu cần recommend, False nếu không."""
    vec = model.encode([text])
    label = clf.predict(vec)[0]
    return label == 1

if __name__ == "__main__":
    model, clf = load_model()

    test_cases = [
        # Expect True
        "Tôi bị đau lưng, có spa hoặc chỗ nào chữa trị không?",
        "Gợi ý dịch vụ cho người bị stress",
        "Can you suggest a service for cardiovascular health?",
        "Có chỗ nào massage trị liệu không?",

        # Expect False
        "Xin chào!",
        "Tôi có nên uống nước lúc ăn không?",
        "Hủy lịch hẹn thứ 3 giúp tôi",
        "Hello, how are you?",
        "Huyết áp cao có nguy hiểm không?",
    ]

    print("=" * 50)
    for text in test_cases:
        result = predict_intent(text, model, clf)
        tag = "✅ RECOMMEND" if result else "⛔ NO RECOMMEND"
        print(f"{tag} | {text}")
    print("=" * 50)