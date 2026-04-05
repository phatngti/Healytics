"""
evaluation/scripts/eval_home.py

Evaluate the Home_Recommender against the ground-truth dataset.

Usage (from the recommender2/ root):
    python -m evaluation.scripts.eval_home
    python -m evaluation.scripts.eval_home --top-k 5 --run-name "home_baseline_v1"
    python -m evaluation.scripts.eval_home --top-k 10 --k-values 1 3 5 10
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from datetime import datetime
from typing import List, Dict

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.insert(0, ROOT_DIR)

from config import settings
from src.recommender.home_recommender import Home_Recommender
from evaluation.metrics import compute_all_metrics

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
EVAL_DIR = os.path.join(ROOT_DIR, "evaluation")
DATASET_PATH = os.path.join(EVAL_DIR, "datasets", "home_eval.json")
RESULTS_DIR = os.path.join(EVAL_DIR, "results")
RUNS_DIR = os.path.join(RESULTS_DIR, "runs")


def load_dataset(path: str) -> List[Dict]:
    """Load the home evaluation dataset (JSON array)."""
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def run_evaluation(
    top_k: int = 5,
    k_values: List[int] | None = None,
    run_name: str | None = None,
    dataset_path: str = DATASET_PATH,
    db_name: str = settings.DATABASE_NAME,
    save: bool = True,
) -> Dict:
    """Run full home recommender evaluation and return the metrics dict.

    Parameters
    ----------
    top_k : int
        Number of results to retrieve from the recommender per profile.
    k_values : list[int]
        K cut-offs for metric computation.
    run_name : str | None
        Label for this run. Used in the output filename.
    dataset_path : str
        Path to the evaluation dataset JSON.
    db_name : str
        ChromaDB collection name.
    save : bool
        Whether to persist results to disk.

    Returns
    -------
    dict
        Full metrics result from ``compute_all_metrics`` plus run metadata.
    """
    if k_values is None:
        k_values = [1, 3, 5, 10]

    # 1. Load dataset
    dataset = load_dataset(dataset_path)
    print(f"📂 Loaded {len(dataset)} home evaluation profiles")

    # 2. Initialise recommender
    print(f"🔧 Initialising Home_Recommender (collection={db_name})")
    recommender = Home_Recommender(db_name)

    # 3. Run predictions
    predictions: List[Dict] = []
    for i, item in enumerate(dataset):
        profile_id = item["id"]
        health_conditions = item.get("health_conditions", [])
        interests = item.get("interests", [])
        goals = item.get("goals", [])
        service_history_ids = item.get("service_history_ids", [])
        relevant_ids = item["relevant_ids"]

        # Call the recommender
        raw = recommender.recommend(
            health_conditions=health_conditions,
            interests=interests,
            goals=goals,
            service_history_ids=service_history_ids,
            top_k_home_results=top_k,
        )

        retrieved_ids = raw["ids"][0] if raw["ids"] else []
        scores = raw["distances"][0] if raw["distances"] else []

        predictions.append({
            "id": profile_id,
            "description": item.get("description", ""),
            "health_conditions": health_conditions,
            "interests": interests,
            "goals": goals,
            "service_history_ids": service_history_ids,
            "relevant_ids": relevant_ids,
            "retrieved_ids": retrieved_ids,
            # ChromaDB returns cosine distance (1 - similarity).
            # Convert to similarity so higher = more similar.
            "scores": [(1.0 - float(s)) for s in scores],
        })

        if (i + 1) % 10 == 0:
            print(f"   ✅ Processed {i + 1}/{len(dataset)} profiles")

    print(f"   ✅ All {len(dataset)} profiles processed\n")

    # 4. Compute metrics
    results = compute_all_metrics(predictions, k_values=k_values)

    # 5. Attach run metadata
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    run_label = run_name or f"home_{timestamp}"

    run_output = {
        "run_name": run_label,
        "timestamp": datetime.now().isoformat(),
        "config": {
            "top_k": top_k,
            "k_values": k_values,
            "dataset": os.path.basename(dataset_path),
            "collection": db_name,
            "embedding_model": settings.EMBEDDING_MODEL_NAME,
        },
        "aggregate": results["aggregate"],
        "per_query": results["per_query"],
        "predictions": predictions,
    }

    # 6. Print summary
    _print_summary(run_output)

    # 7. Save results
    if save:
        os.makedirs(RUNS_DIR, exist_ok=True)
        out_path = os.path.join(RUNS_DIR, f"{run_label}.json")
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(run_output, f, ensure_ascii=False, indent=2)
        print(f"\n💾 Results saved to: {out_path}")

    return run_output


def _print_summary(run_output: Dict) -> None:
    """Pretty-print the aggregate metrics."""
    agg = run_output["aggregate"]
    config = run_output["config"]

    print("=" * 60)
    print(f"  HOME EVALUATION RESULTS — {run_output['run_name']}")
    print("=" * 60)
    print(f"  Model      : {config['embedding_model']}")
    print(f"  Collection : {config['collection']}")
    print(f"  Top-K      : {config['top_k']}")
    print(f"  Profiles   : {agg['num_queries']}")
    print("-" * 60)

    # Group metrics by type
    metric_names = ["Hit", "Prec", "Recall", "MRR", "NDCG"]
    k_values = config["k_values"]

    # Header row
    header = f"{'Metric':<12}" + "".join(f"{'@' + str(k):>10}" for k in k_values)
    print(header)
    print("-" * len(header))

    for metric in metric_names:
        row = f"{metric:<12}"
        for k in k_values:
            key = f"{metric}@{k}"
            val = agg.get(key, 0.0)
            row += f"{val:>10.4f}"
        print(row)

    print("=" * 60)

    # Per-profile score distribution
    predictions = run_output["predictions"]
    if predictions:
        all_scores = []
        for p in predictions:
            all_scores.extend(p.get("scores", []))

        if all_scores:
            avg_score = sum(all_scores) / len(all_scores)
            min_score = min(all_scores)
            max_score = max(all_scores)
            print(f"\n  Cosine Similarity Distribution:")
            print(f"    Min: {min_score:.4f}  |  Avg: {avg_score:.4f}  |  Max: {max_score:.4f}")

    # Worst performing profiles
    per_query = run_output["per_query"]
    if per_query:
        sorted_pq = sorted(per_query, key=lambda x: x.get("Recall@5", 0))
        print(f"\n  Worst Recall@5 profiles:")
        for pq in sorted_pq[:5]:
            pid = pq["id"]
            desc = next(
                (p["description"] for p in predictions if p["id"] == pid), ""
            )
            print(f"    {pid}: Recall@5={pq.get('Recall@5', 0):.4f} — {desc}")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Evaluate home recommender against ground truth"
    )
    parser.add_argument(
        "--top-k", type=int, default=10,
        help="Number of results to retrieve per profile (default: 10)"
    )
    parser.add_argument(
        "--k-values", type=int, nargs="+", default=[1, 3, 5, 10],
        help="K cut-offs for metrics (default: 1 3 5 10)"
    )
    parser.add_argument(
        "--run-name", type=str, default=None,
        help="Label for this evaluation run"
    )
    parser.add_argument(
        "--dataset", type=str, default=DATASET_PATH,
        help="Path to evaluation dataset JSON"
    )
    parser.add_argument(
        "--collection", type=str, default=settings.DATABASE_NAME,
        help="ChromaDB collection name"
    )
    parser.add_argument(
        "--no-save", action="store_true",
        help="Don't save results to disk"
    )
    args = parser.parse_args()

    run_evaluation(
        top_k=args.top_k,
        k_values=args.k_values,
        run_name=args.run_name,
        dataset_path=args.dataset,
        db_name=args.collection,
        save=not args.no_save,
    )


if __name__ == "__main__":
    main()
