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
import time
from datetime import datetime
from typing import List, Dict, Any
from pathlib import Path

# ---------------------------------------------------------------------------
# Path setup — ensure recommender2/ is on sys.path
# ---------------------------------------------------------------------------
ROOT_DIR = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(ROOT_DIR))

from evaluation.metrics import compute_all_metrics
from src.recommender.vector_store import Vector_Database
from src.recommender.embedding_model import Embedding_Model
from src.recommender.chatbot_recommender import Chatbot_Recommender
from evaluation.scripts.eval_utils import (
    load_dataset,
    get_distance_type,
    convert_distances_to_scores,
    ensure_eval_collection,
    print_eval_summary
)
from config import settings

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
EVAL_DIR = Path(ROOT_DIR) / "evaluation"
DATASET_PATH = EVAL_DIR / "datasets" / "chatbot_eval.json"
RESULTS_DIR = EVAL_DIR / "results"
RUNS_DIR = RESULTS_DIR / "runs"
EVAL_COLLECTION_NAME = "healytics_eval_chatbot"



def _get_embeddings_for_ids(
    recommender: Chatbot_Recommender,
    doc_ids: List[str],
) -> List[List[float]] | None:
    """Retrieve embedding vectors from the ChromaDB collection.

    Returns None if the collection is unavailable or IDs are empty.
    """
    if not doc_ids:
        return None
    try:
        collection = recommender.collection
        result = collection.get(ids=doc_ids, include=["embeddings"])
        embeddings = result.get("embeddings")
        if embeddings and len(embeddings) == len(doc_ids):
            # Re-order to match doc_ids order
            id_to_emb = dict(zip(result["ids"], embeddings))
            return [id_to_emb[did] for did in doc_ids if did in id_to_emb]
        return embeddings
    except Exception:
        return None


def run_evaluation(
    top_k: int = 5,
    k_values: List[int] | None = None,
    run_name: str | None = None,
    dataset_path: str = DATASET_PATH,
    db_name: str = EVAL_COLLECTION_NAME,
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

    # Ensure the collection is compatible with evaluation IDs.
    db_name = ensure_eval_collection(db_name, EVAL_COLLECTION_NAME, dataset)

    # 2. Initialise recommender
    print(f"🔧 Initialising Chatbot_Recommender (collection={db_name})")
    recommender = Chatbot_Recommender(db_name)

    # Detect distance type for score conversion
    dist_type = get_distance_type(recommender.vector_database.collection)
    print(f"📐 Distance metric: {dist_type}")

    # 3. Run predictions
    predictions: List[Dict[str, Any]] = []
    for i, item in enumerate(dataset):
        query_id = item["id"]
        query = item["query"]
        relevant_ids = item["relevant_ids"]

        # --- Latency measurement ---
        t_start = time.perf_counter()
        raw = recommender.recommend(query, top_k=top_k)
        t_end = time.perf_counter()
        latency_ms = (t_end - t_start) * 1000.0

        retrieved_ids = raw["ids"][0] if raw["ids"] else []
        raw_distances = raw["distances"][0] if raw["distances"] else []

        if not retrieved_ids:
            print(f"  ⚠️  Warning: empty results for query {query_id}")

        pred: Dict = {
            "id": query_id,
            "query": query,
            "category": item.get("category", ""),
            "relevant_ids": relevant_ids,
            "retrieved_ids": retrieved_ids,
            # Convert distance to similarity (higher = more similar),
            # adapting to the collection's configured distance metric.
            "scores": convert_distances_to_scores(raw_distances, dist_type),
            "latency_ms": round(latency_ms, 2),
        }

        # --- Hard negatives (if present in dataset) ---
        if "hard_negative_ids" in item:
            pred["hard_negative_ids"] = item["hard_negative_ids"]

        # --- Graded relevance (if present in dataset) ---
        if "relevance_grades" in item:
            pred["relevance_grades"] = item["relevance_grades"]

        # --- Embeddings for diversity metric ---
        embeddings = _get_embeddings_for_ids(recommender, retrieved_ids)
        if embeddings:
            pred["retrieved_embeddings"] = embeddings

        predictions.append(pred)

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
            "dataset": Path(dataset_path).name,
            "collection": db_name,
            "embedding_model": settings.EMBEDDING_MODEL_NAME,
            "distance_metric": dist_type,
        },
        "aggregate": results["aggregate"],
        "per_query": results["per_query"],
        # Strip embeddings from saved output (too large)
        "predictions": [
            {k: v for k, v in p.items() if k != "retrieved_embeddings"}
            for p in predictions
        ],
    }

    # 6. Print summary
    _print_summary(run_output)

    # 7. Save results
    if save:
        out_path = RUNS_DIR / f"{run_label}.json"
        out_path.parent.mkdir(parents=True, exist_ok=True)
        with open(out_path, "w", encoding="utf-8") as f:
            json.dump(run_output, f, ensure_ascii=False, indent=2)
        print(f"\n💾 Results saved to: {out_path}")

    return run_output


def _print_summary(run_output: Dict[str, Any]) -> None:
    """Pretty-print aggregate metrics, latency, and category breakdown."""
    agg = run_output["aggregate"]

    # Print baseline summary from utils
    print_eval_summary(run_output, "CHATBOT EVALUATION RESULTS", "Queries")

    # --- Latency stats ---
    if "Latency_avg_ms" in agg:
        print("\n  ⏱️  Latency:")
        print(
            f"    Avg: {agg['Latency_avg_ms']:.2f}ms  |  "
            f"P50: {agg.get('Latency_p50_ms', 0):.2f}ms  |  "
            f"P95: {agg.get('Latency_p95_ms', 0):.2f}ms  |  "
            f"P99: {agg.get('Latency_p99_ms', 0):.2f}ms  |  "
            f"Max: {agg.get('Latency_max_ms', 0):.2f}ms"
        )

    # --- Category breakdown ---
    preds = run_output["predictions"]
    categories = sorted({p.get("category", "") for p in preds if p.get("category")})
    if not categories:
        return

    config = run_output.get("config", {})
    k_values = config.get("k_values", [1, 3, 5, 10])
    display_k = 3 if 3 in k_values else (k_values[0] if k_values else 3)

    print(
        f"\n{'Category':<16}{'Count':>8}{f'Hit@{display_k}':>10}"
        f"{f'Recall@{display_k}':>12}{f'MRR@{display_k}':>10}"
    )
    print("-" * 56)

    per_query = run_output["per_query"]
    pq_by_id = {pq.get("id", ""): pq for pq in per_query}

    for cat in categories:
        cat_preds = [p for p in preds if p.get("category") == cat]
        n = len(cat_preds)
        if n == 0:
            continue
        hit_sum = sum(
            pq_by_id.get(p.get("id", ""), {}).get(f"Hit@{display_k}", 0)
            for p in cat_preds
        )
        recall_sum = sum(
            pq_by_id.get(p.get("id", ""), {}).get(f"Recall@{display_k}", 0)
            for p in cat_preds
        )
        mrr_sum = sum(
            pq_by_id.get(p.get("id", ""), {}).get(f"MRR@{display_k}", 0)
            for p in cat_preds
        )
        print(
            f"{cat:<16}{n:>8}{(hit_sum / n):>10.4f}{(recall_sum / n):>12.4f}{(mrr_sum / n):>10.4f}"
        )


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
        "--collection", type=str, default=EVAL_COLLECTION_NAME,
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
