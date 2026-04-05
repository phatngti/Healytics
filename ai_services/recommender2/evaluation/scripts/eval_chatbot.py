"""
evaluation/scripts/eval_chatbot.py

Evaluate the Chatbot_Recommender against the ground-truth dataset.

Usage (from the recommender2/ root):
    python -m evaluation.scripts.eval_chatbot
    python -m evaluation.scripts.eval_chatbot --top-k 5 --run-name "baseline_v1"
    python -m evaluation.scripts.eval_chatbot --top-k 10 --k-values 1 3 5 10
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from datetime import datetime
from typing import List, Dict

# ---------------------------------------------------------------------------
# Path setup — ensure recommender2/ is on sys.path
# ---------------------------------------------------------------------------
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.insert(0, ROOT_DIR)

from config import settings
from src.recommender.chatbot_recommender import Chatbot_Recommender
from evaluation.metrics import compute_all_metrics

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
EVAL_DIR = os.path.join(ROOT_DIR, "evaluation")
DATASET_PATH = os.path.join(EVAL_DIR, "datasets", "chatbot_eval.json")
RESULTS_DIR = os.path.join(EVAL_DIR, "results")
RUNS_DIR = os.path.join(RESULTS_DIR, "runs")


def load_dataset(path: str) -> List[Dict]:
    """Load the chatbot evaluation dataset (JSON array)."""
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
    """Run full chatbot evaluation and return the metrics dict.

    Parameters
    ----------
    top_k : int
        Number of results to retrieve from the recommender per query.
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
    print(f"📂 Loaded {len(dataset)} chatbot evaluation queries")

    # 2. Initialise recommender
    print(f"🔧 Initialising Chatbot_Recommender (collection={db_name})")
    recommender = Chatbot_Recommender(db_name)

    # 3. Run predictions
    predictions: List[Dict] = []
    for i, item in enumerate(dataset):
        query_id = item["id"]
        query = item["query"]
        relevant_ids = item["relevant_ids"]

        # Call the recommender
        raw = recommender.recommend(query, top_k=top_k)
        retrieved_ids = raw["ids"][0] if raw["ids"] else []
        scores = raw["distances"][0] if raw["distances"] else []

        predictions.append({
            "id": query_id,
            "query": query,
            "category": item.get("category", ""),
            "relevant_ids": relevant_ids,
            "retrieved_ids": retrieved_ids,
            # ChromaDB returns cosine distance (1 - similarity).
            # Convert to similarity so higher = more similar.
            "scores": [(1.0 - float(s)) for s in scores],
        })

        if (i + 1) % 10 == 0:
            print(f"   ✅ Processed {i + 1}/{len(dataset)} queries")

    print(f"   ✅ All {len(dataset)} queries processed\n")

    # 4. Compute metrics
    results = compute_all_metrics(predictions, k_values=k_values)

    # 5. Attach run metadata
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    run_label = run_name or f"chatbot_{timestamp}"

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
    print(f"  CHATBOT EVALUATION RESULTS — {run_output['run_name']}")
    print("=" * 60)
    print(f"  Model      : {config['embedding_model']}")
    print(f"  Collection : {config['collection']}")
    print(f"  Top-K      : {config['top_k']}")
    print(f"  Queries    : {agg['num_queries']}")
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

    # Category breakdown
    preds = run_output["predictions"]
    categories = sorted(set(p.get("category", "") for p in preds if p.get("category")))
    if categories:
        print(f"\n{'Category':<16}{'Count':>8}{'Hit@3':>10}{'Recall@3':>10}{'MRR@3':>10}")
        print("-" * 54)
        per_query = run_output["per_query"]
        pq_by_id = {pq["id"]: pq for pq in per_query}

        for cat in categories:
            cat_preds = [p for p in preds if p.get("category") == cat]
            n = len(cat_preds)
            hit_sum = sum(pq_by_id[p["id"]].get("Hit@3", 0) for p in cat_preds)
            recall_sum = sum(pq_by_id[p["id"]].get("Recall@3", 0) for p in cat_preds)
            mrr_sum = sum(pq_by_id[p["id"]].get("MRR@3", 0) for p in cat_preds)
            print(f"{cat:<16}{n:>8}{hit_sum/n:>10.4f}{recall_sum/n:>10.4f}{mrr_sum/n:>10.4f}")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Evaluate chatbot recommender against ground truth"
    )
    parser.add_argument(
        "--top-k", type=int, default=10,
        help="Number of results to retrieve per query (default: 10)"
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
