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
import re
import sys
import time
from datetime import datetime
from typing import List, Dict, Tuple

# ---------------------------------------------------------------------------
# Path setup
# ---------------------------------------------------------------------------
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.insert(0, ROOT_DIR)

from config import settings
from src.recommender.home_recommender import Home_Recommender
from src.recommender.embedding_model import Embedding_Model
from src.recommender.vector_store import Vector_Database
from evaluation.metrics import compute_all_metrics

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
EVAL_DIR = os.path.join(ROOT_DIR, "evaluation")
DATASET_PATH = os.path.join(EVAL_DIR, "datasets", "home_eval.json")
RESULTS_DIR = os.path.join(EVAL_DIR, "results")
RUNS_DIR = os.path.join(RESULTS_DIR, "runs")
EVAL_COLLECTION_NAME = "healytics_eval_collection"


def _clean_text(text: str) -> str:
    """Lowercase and collapse repeated whitespace."""
    return " ".join(str(text).strip().lower().split())


def _stable_unique(values: List[str]) -> List[str]:
    """Preserve insertion order while removing duplicates."""
    return list(dict.fromkeys(values))


def _description_snippet(description: str, max_chars: int = 180) -> str:
    """Extract a short natural-language context snippet from profile description."""
    text = _clean_text(description)
    if not text:
        return ""

    sentences = [s.strip() for s in re.split(r"[.!?;]+", text) if s.strip()]
    if not sentences:
        return text[:max_chars]

    snippet = sentences[0]
    if len(sentences) > 1 and len(snippet) < 80:
        snippet = f"{snippet}. {sentences[1]}"
    return snippet[:max_chars]


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
        # Default v3-like single-query keyword formulation.
        cond = _stable_unique([_clean_text(x) for x in health_conditions if _clean_text(x)])
        intr = _stable_unique([_clean_text(x) for x in interests if _clean_text(x)])
        goal = _stable_unique([_clean_text(x) for x in goals if _clean_text(x)])
        snippet = _description_snippet(item.get("description", ""))
        merged = cond + goal + goal + intr
        if snippet:
            merged.append(snippet)
        return merged, [], [], []

    return health_conditions, interests, goals, service_history_ids


def _resolve_score_mode(raw_scores: List[float], requested_mode: str) -> str:
    """Resolve score mode for a query.

    - distance: lower score is better
    - similarity: higher score is better
    - auto: heuristic fallback based on value ranges
    """
    if requested_mode in {"distance", "similarity"}:
        return requested_mode

    if not raw_scores:
        return "similarity"

    min_s = min(raw_scores)
    max_s = max(raw_scores)

    # Common cosine-distance output from vector DBs is typically around [0, 2].
    if min_s >= 0.0 and max_s <= 2.0:
        return "distance"

    # Negative values are often raw similarity / inner-product-like scores.
    return "similarity"


def _align_scores_and_rank(
    retrieved_ids: List[str],
    raw_scores: List[float],
    resolved_score_mode: str,
) -> Tuple[List[str], List[float]]:
    """Return re-ranked ids and analysis scores where higher is better."""
    pairs = list(zip(retrieved_ids, raw_scores))
    if not pairs:
        return [], []

    if resolved_score_mode == "distance":
        # Lower distance is better; re-rank ascending distance.
        pairs.sort(key=lambda x: x[1], reverse=False)
        ids = [pid for pid, _ in pairs]
        # Store aligned score where higher is better for analysis/plots.
        aligned_scores = [1.0 - float(raw) for _, raw in pairs]
        return ids, aligned_scores

    # Similarity mode: higher is better.
    pairs.sort(key=lambda x: x[1], reverse=True)
    ids = [pid for pid, _ in pairs]
    aligned_scores = [float(raw) for _, raw in pairs]
    return ids, aligned_scores


def load_dataset(path: str) -> List[Dict]:
    """Load the home evaluation dataset (JSON array)."""
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)


def _load_services_catalog() -> List[Dict]:
    """Load services catalog used for synthetic evaluation datasets."""
    services_path = os.path.join(ROOT_DIR, "data", "raw", "services.json")
    with open(services_path, "r", encoding="utf-8") as f:
        return json.load(f)


def _ensure_eval_collection(db_name: str, dataset: List[Dict]) -> str:
    """Ensure evaluation collection exists and IDs are compatible with dataset.

    The synthetic eval datasets use service IDs from data/raw/services.json
    (e.g. SV001). If the configured collection has no overlap with these IDs,
    metrics collapse to 0.0. In that case, auto-build a dedicated collection.
    """
    expected_ids = {
        rid
        for item in dataset
        for rid in item.get("relevant_ids", [])
    }

    vector_db = Vector_Database(db_name=db_name)
    count = vector_db.collection.count()

    ids_in_collection = set()
    if count > 0:
        sample = vector_db.collection.peek(limit=min(2000, count))
        ids_in_collection.update(sample.get("ids", []))
        for meta in sample.get("metadatas", []):
            if isinstance(meta, dict):
                sid = meta.get("service_id")
                if sid:
                    ids_in_collection.add(sid)

    overlap = len(expected_ids & ids_in_collection)
    if count > 0 and overlap > 0:
        return db_name

    eval_db = Vector_Database(db_name=EVAL_COLLECTION_NAME)
    eval_count = eval_db.collection.count()
    if eval_count > 0:
        return EVAL_COLLECTION_NAME

    print(
        "⚠️  Collection is empty or incompatible with eval dataset IDs. "
        f"Building '{EVAL_COLLECTION_NAME}' from data/raw/services.json..."
    )

    services = _load_services_catalog()
    embedder = Embedding_Model()
    for service in services:
        service_document = f"{service.get('name', '')} {service.get('description', '')}"
        embedding = embedder.encode(service_document)
        eval_db.upsert_service(
            service_id=str(service["id"]),
            name=service.get("name", ""),
            description=service.get("description", ""),
            category=service.get("category", ""),
            embedding=embedding,
        )

    print(f"✅ Built '{EVAL_COLLECTION_NAME}' with {len(services)} services")
    return EVAL_COLLECTION_NAME


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
    dataset_path: str = DATASET_PATH,
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
    dataset = load_dataset(dataset_path)
    print(f"📂 Loaded {len(dataset)} home evaluation profiles")
    print(f"🧭 Query mode: {query_mode} | Score mode: {score_mode}")

    # Ensure the collection is compatible with evaluation IDs.
    db_name = _ensure_eval_collection(db_name, dataset)

    # 2. Initialise recommender
    print(f"🔧 Initialising Home_Recommender (collection={db_name})")
    recommender = Home_Recommender(db_name)
    resolved_modes: List[str] = []

    # 3. Run predictions
    predictions: List[Dict] = []
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
        resolved_mode = _resolve_score_mode(raw_scores, requested_mode=score_mode)
        retrieved_ids, aligned_scores = _align_scores_and_rank(
            retrieved_ids,
            raw_scores,
            resolved_score_mode=resolved_mode,
        )
        t_end = time.perf_counter()
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
            "dataset": os.path.basename(dataset_path),
            "collection": db_name,
            "embedding_model": settings.EMBEDDING_MODEL_NAME,
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

    # --- Graded NDCG (if available) ---
    if any(f"NDCG_G@{k}" in agg for k in k_values):
        row = f"{'NDCG_G':<12}"
        for k in k_values:
            key = f"NDCG_G@{k}"
            val = agg.get(key, 0.0)
            row += f"{val:>10.4f}"
        print(row)

    # --- Hard Negative Rate (if available) ---
    if any(f"HNR@{k}" in agg for k in k_values):
        row = f"{'HNR ↓':<12}"
        for k in k_values:
            key = f"HNR@{k}"
            val = agg.get(key, 0.0)
            row += f"{val:>10.4f}"
        print(row)

    # --- Diversity (if available) ---
    if any(f"Diversity@{k}" in agg for k in k_values):
        row = f"{'Diversity':<12}"
        for k in k_values:
            key = f"Diversity@{k}"
            val = agg.get(key, 0.0)
            row += f"{val:>10.4f}"
        print(row)

    print("=" * 60)

    # --- Latency stats ---
    if "Latency_avg_ms" in agg:
        print(f"\n  ⏱️  Latency:")
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
            print(f"\n  Search Score Distribution (higher is better):")
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
