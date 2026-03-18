import argparse
import json
from pathlib import Path


def _load_labeled_samples(path: Path) -> list[dict]:
    samples: list[dict] = []
    with path.open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                row = json.loads(line)
            except json.JSONDecodeError:
                continue

            score = row.get("intent_score")
            label = row.get("label")
            if score is None or label not in (0, 1, False, True):
                continue

            samples.append({
                "score": float(score),
                "label": int(bool(label)),
            })
    return samples


def _metrics(samples: list[dict], threshold: float) -> dict:
    tp = fp = tn = fn = 0
    for s in samples:
        pred = 1 if s["score"] >= threshold else 0
        gold = s["label"]
        if pred == 1 and gold == 1:
            tp += 1
        elif pred == 1 and gold == 0:
            fp += 1
        elif pred == 0 and gold == 0:
            tn += 1
        else:
            fn += 1

    precision = tp / (tp + fp) if (tp + fp) else 0.0
    recall = tp / (tp + fn) if (tp + fn) else 0.0
    f1 = (2 * precision * recall / (precision + recall)) if (precision + recall) else 0.0
    accuracy = (tp + tn) / (tp + tn + fp + fn) if (tp + tn + fp + fn) else 0.0

    return {
        "threshold": round(threshold, 3),
        "precision": round(precision, 4),
        "recall": round(recall, 4),
        "f1": round(f1, 4),
        "accuracy": round(accuracy, 4),
        "tp": tp,
        "fp": fp,
        "tn": tn,
        "fn": fn,
    }


def calibrate(path: Path, min_threshold: float, max_threshold: float, step: float) -> None:
    samples = _load_labeled_samples(path)
    if not samples:
        print("No labeled samples found. Add `label` field (0/1) to JSONL first.")
        return

    best = None
    t = min_threshold
    while t <= max_threshold + 1e-9:
        m = _metrics(samples, t)
        if best is None or m["f1"] > best["f1"]:
            best = m
        t += step

    print(f"Labeled samples: {len(samples)}")
    print("Best threshold by F1:")
    print(json.dumps(best, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Calibrate semantic location-intent threshold from labeled JSONL")
    parser.add_argument(
        "--input",
        default="data/intent_logs/location_intent.jsonl",
        help="Path to JSONL logs with intent_score + label",
    )
    parser.add_argument("--min", type=float, default=0.3)
    parser.add_argument("--max", type=float, default=0.9)
    parser.add_argument("--step", type=float, default=0.01)
    args = parser.parse_args()

    calibrate(Path(args.input), args.min, args.max, args.step)
