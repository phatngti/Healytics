from sentence_transformers import SentenceTransformer
from sklearn.linear_model import LogisticRegression
import pandas as pd
import joblib
import os

if __name__ == "__main__":
    BASE_DIR = os.path.dirname(__file__)
    dataset_path = os.path.join(BASE_DIR, "intent_binary_dataset.csv")

    df = pd.read_csv(dataset_path)

    model = SentenceTransformer("all-MiniLM-L6-v2")
    X = model.encode(df["text"].tolist(), show_progress_bar=True)
    y = df["label"].tolist()

    clf = LogisticRegression(max_iter=1000)
    clf.fit(X, y)

    os.makedirs("models", exist_ok=True)
    joblib.dump(clf, "models/intent_classifier.pkl")
    model.save("models/intent_encoder")
    print("Saved classifier + encoder models")