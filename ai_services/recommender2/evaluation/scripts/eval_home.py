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
import time
from datetime import datetime
from typing import List, Dict, Tuple, Any
from pathlib import Path

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
ROOT_DIR = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(ROOT_DIR))

from evaluation.metrics import compute_all_metrics
from src.recommender.vector_store import Vector_Database
from src.recommender.embedding_model import Embedding_Model
from src.recommender.home_recommender import Home_Recommender
from evaluation.scripts.eval_utils import (
    load_dataset,
    get_distance_type,
    resolve_score_mode,
    align_scores_and_rank,
    ensure_eval_collection,
    print_eval_summary
)
from config import settings

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
EVAL_DIR = Path(ROOT_DIR) / "evaluation"
DATASET_PATH = EVAL_DIR / "datasets" / "home_eval.json"
RESULTS_DIR = EVAL_DIR / "results"
RUNS_DIR = RESULTS_DIR / "runs"
EVAL_COLLECTION_NAME = "healytics_eval_home"


def _clean_text(text: str) -> str:
    """Lowercase and collapse repeated whitespace."""
    return " ".join(str(text).strip().lower().split())


def _stable_unique(values: List[str]) -> List[str]:
    """Preserve insertion order while removing duplicates."""
    return list(dict.fromkeys(values))


def _build_profile_inputs(item: Dict, query_mode: str) -> Tuple[List[str], List[str], List[str], List[str]]:
    """Build inputs for Home_Recommender using evaluation-side query formulation.

    Modes
    -----
    profile:
        Use all available profile fields (health_conditions, interests, goals,
        service_history_ids). This is the default behavior.
    keyword:
        Use only condensed keywords from health_conditions + interests,
        and ignore goals/history to emulate a lightweight keyword query.
    """
    health_conditions = item.get("health_conditions", [])
    interests = item.get("interests", [])
    goals = item.get("goals", [])
    service_history_ids = item.get("service_history_ids", [])

    if query_mode == "keyword":
        # Condensed keyword formulation: conditions + goals + interests.
        cond = _stable_unique([_clean_text(x) for x in health_conditions if _clean_text(x)])
        intr = _stable_unique([_clean_text(x) for x in interests if _clean_text(x)])
        goal = _stable_unique([_clean_text(x) for x in goals if _clean_text(x)])
        merged = cond + goal + intr
        return merged, [], [], []

    return health_conditions, interests, goals, service_history_ids



def _get_embeddings_for_ids(
    recommender: Home_Recommender,
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
            id_to_emb = dict(zip(result["ids"], embeddings))
            return [id_to_emb[did] for did in doc_ids if did in id_to_emb]
        return embeddings
    except Exception:
        return None


def run_evaluation(
    top_k: int = 5,
    k_values: List[int] | None = None,
    run_name: str | None = None,
    dataset_path: str = str(DATASET_PATH),
    db_name: str = EVAL_COLLECTION_NAME,
    score_mode: str = "auto",
    query_mode: str = "profile",
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
    score_mode : str
        Score interpretation mode: ``auto`` | ``distance`` | ``similarity``.
    query_mode : str
        Evaluation-side query formulation: ``profile`` | ``keyword``.
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
    dataset_path = Path(dataset_path)
    if not dataset_path.exists():
        print(f"Error: dataset not found at {dataset_path}")
        return {}
    dataset = load_dataset(dataset_path)
    print(f"📂 Loaded {len(dataset)} home evaluation profiles")
    print(f"🧭 Query mode: {query_mode} | Score mode: {score_mode}")

    # Ensure the collection is compatible with evaluation IDs.
    db_name = ensure_eval_collection(db_name, EVAL_COLLECTION_NAME, dataset)

    # 2. Initialise recommender
    print(f"🔧 Initialising Home_Recommender (collection={db_name})")
    recommender = Home_Recommender(db_name)

    # 3. Handle score direction via dist_type
    dist_type = get_distance_type(recommender.vector_database.collection)
    print(f"📐 Distance metric: {dist_type}")

    # 4. Run predictions
    resolved_modes: List[str] = []
    predictions: List[Dict[str, Any]] = []
    for i, item in enumerate(dataset):
        profile_id = item["id"]
        health_conditions, interests, goals, service_history_ids = _build_profile_inputs(
            item,
            query_mode=query_mode,
        )
        relevant_ids = item["relevant_ids"]

        # --- Latency measurement ---
        t_start = time.perf_counter()
        raw = recommender.recommend(
            health_conditions=health_conditions,
            interests=interests,
            goals=goals,
            service_history_ids=service_history_ids,
            top_k_home_results=top_k,
        )
        retrieved_ids = raw["ids"][0] if raw["ids"] else []
        raw_scores = raw["distances"][0] if raw["distances"] else []
        t_end = time.perf_counter()
        
        if not retrieved_ids:
            print(f"  ⚠️  Warning: empty results for profile {profile_id}")

        resolved_mode = resolve_score_mode(
            requested_mode=score_mode, dist_type=dist_type)
        retrieved_ids, aligned_scores = align_scores_and_rank(
            retrieved_ids,
            raw_scores,
            resolved_score_mode=resolved_mode,
            dist_type=dist_type,
        )
        latency_ms = (t_end - t_start) * 1000.0
        resolved_modes.append(resolved_mode)

        pred: Dict = {
            "id": profile_id,
            "description": item.get("description", ""),
            "health_conditions": health_conditions,
            "interests": interests,
            "goals": goals,
            "service_history_ids": service_history_ids,
            "relevant_ids": relevant_ids,
            "retrieved_ids": retrieved_ids,
            # Stored scores are aligned for analysis where "higher is better".
            "scores": aligned_scores,
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
            "dataset": dataset_path.name,
            "collection": db_name,
            "embedding_model": settings.EMBEDDING_MODEL_NAME,
            "distance_metric": dist_type,
            "query_mode": query_mode,
            "score_mode_requested": score_mode,
            "score_mode_resolved": (
                max(set(resolved_modes), key=resolved_modes.count)
                if resolved_modes else score_mode
            ),
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
    """Pretty-print the aggregate metrics."""
    agg = run_output["aggregate"]
    config = run_output["config"]
    k_values = config["k_values"]

    # Print baseline summary from utils
    print_eval_summary(run_output, "HOME EVALUATION RESULTS", "Profiles")

    # --- Latency stats ---
    if "Latency_avg_ms" in agg:
        print("\n  ⏱️  Latency:")
        print(f"    Avg: {agg['Latency_avg_ms']:.2f}ms  |  "
              f"P50: {agg.get('Latency_p50_ms', 0):.2f}ms  |  "
              f"P95: {agg.get('Latency_p95_ms', 0):.2f}ms  |  "
              f"P99: {agg.get('Latency_p99_ms', 0):.2f}ms  |  "
              f"Max: {agg.get('Latency_max_ms', 0):.2f}ms")

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
            print("\n  Search Score Distribution (higher is better):")
            print(f"    Min: {min_score:.4f}  |  Avg: {avg_score:.4f}  |  Max: {max_score:.4f}")

    # Worst performing profiles
    per_query = run_output["per_query"]
    if per_query:
        display_k = 5 if 5 in k_values else (k_values[0] if k_values else 5)
        
        sorted_pq = sorted(per_query, key=lambda x: x.get(f"Recall@{display_k}", 0))
        print(f"\n  Worst Recall@{display_k} profiles:")
        for pq in sorted_pq[:5]:
            pid = pq["id"]
            desc = next(
                (p["description"] for p in predictions if p["id"] == pid), ""
            )
            print(f"    {pid}: Recall@{display_k}={pq.get(f'Recall@{display_k}', 0):.4f} — {desc}")


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
        "--collection", type=str, default=EVAL_COLLECTION_NAME,
        help="ChromaDB collection name"
    )
    parser.add_argument(
        "--score-mode", choices=["auto", "distance", "similarity"], default="auto",
        help=(
            "Interpret backend score semantics (auto=heuristic, "
            "distance=lower is better, similarity=higher is better)"
        ),
    )
    parser.add_argument(
        "--query-mode", choices=["profile", "keyword"], default="profile",
        help=(
            "Evaluation-side input formulation: profile=all fields, "
            "keyword=health_conditions+interests only"
        ),
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
        score_mode=args.score_mode,
        query_mode=args.query_mode,
        save=not args.no_save,
    )


if __name__ == "__main__":
    main()
