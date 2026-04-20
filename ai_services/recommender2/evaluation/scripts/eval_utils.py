import json
import os
import sys
from typing import List, Dict, Tuple, Any
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(ROOT_DIR))

from src.recommender.vector_store import Vector_Database
from src.recommender.embedding_model import Embedding_Model

def load_dataset(path: Path | str) -> List[Dict[str, Any]]:
    """Load an evaluation dataset (JSON array)."""
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def load_services_catalog() -> List[Dict[str, Any]]:
    """Load services catalog used for synthetic evaluation datasets."""
    services_path = ROOT_DIR / "data" / "raw" / "services.json"
    with open(services_path, "r", encoding="utf-8") as f:
        return json.load(f)

def get_distance_type(collection) -> str:
    """Read the distance metric from a ChromaDB collection's metadata."""
    meta = getattr(collection, "metadata", None) or {}
    if "hnsw:space" not in meta:
        print("  ⚠️  Warning: hnsw:space not found in collection metadata. Defaulting to 'l2'.")
    return meta.get("hnsw:space", "l2")

def convert_distances_to_scores(distances: List[float], dist_type: str) -> List[float]:
    """Convert raw ChromaDB distances to similarity scores (higher = better)."""
    if dist_type == "cosine":
        return [(1.0 - float(d)) for d in distances]
    elif dist_type == "ip":
        return [float(d) for d in distances]
    else:
        # L2 distance
        return [1.0 / (1.0 + float(d)) for d in distances]

def resolve_score_mode(requested_mode: str, dist_type: str = "l2") -> str:
    """Resolve score mode for a query."""
    if requested_mode in {"distance", "similarity"}:
        return requested_mode
    if dist_type == "ip":
        return "similarity"
    return "distance"

def align_scores_and_rank(
    retrieved_ids: List[str],
    raw_scores: List[float],
    resolved_score_mode: str,
    dist_type: str = "l2",
) -> Tuple[List[str], List[float]]:
    """Return re-ranked ids and analysis scores where higher is better."""
    pairs = list(zip(retrieved_ids, raw_scores))
    if not pairs:
        return [], []

    if resolved_score_mode == "distance":
        ids = [pid for pid, _ in pairs]
        if dist_type == "cosine":
            aligned_scores = [1.0 - float(raw) for _, raw in pairs]
        else:
            aligned_scores = [1.0 / (1.0 + float(raw)) for _, raw in pairs]
        return ids, aligned_scores

    ids = [pid for pid, _ in pairs]
    aligned_scores = [float(raw) for _, raw in pairs]
    return ids, aligned_scores

def ensure_eval_collection(db_name: str, target_eval_name: str, dataset: List[Dict[str, Any]]) -> str:
    """Ensure evaluation collection exists and IDs are compatible with dataset."""
    expected_ids = {
        rid
        for item in dataset
        for rid in item.get("relevant_ids", [])
    }

    vector_db = Vector_Database(db_name=db_name)
    count = vector_db.collection.count()

    ids_in_collection = set()
    if count > 0:
        sample_ids = list(expected_ids)[:50]
        try:
            result = vector_db.collection.get(ids=sample_ids)
            ids_in_collection.update(result.get("ids", []))
        except Exception:
            sample = vector_db.collection.peek(limit=min(100, count))
            ids_in_collection.update(sample.get("ids", []))
            for meta in sample.get("metadatas", []):
                if isinstance(meta, dict):
                    sid = meta.get("service_id")
                    if sid:
                        ids_in_collection.add(sid)

    overlap = len(expected_ids & ids_in_collection)
    if count > 0 and overlap > 0:
        return db_name

    eval_db = Vector_Database(db_name=target_eval_name)
    eval_count = eval_db.collection.count()
    if eval_count > 0:
        return target_eval_name

    print(
        "⚠️  Collection is empty or incompatible with eval dataset IDs. "
        f"Building '{target_eval_name}' from data/raw/services.json..."
    )

    services = load_services_catalog()
    embedder = Embedding_Model()
    for service in services:
        tags_str = ", ".join(service.get("tags", []))
        examples_str = "; ".join(service.get("example_queries", []))
        service_document = f"{service.get('name', '')} {service.get('description', '')} Tags: {tags_str} Ví dụ: {examples_str}"
        embedding = embedder.encode(service_document)
        eval_db.upsert_service(
            service_id=str(service["id"]),
            name=service.get("name", ""),
            description=service.get("description", ""),
            category=service.get("category", ""),
            embedding=embedding,
        )

    print(f"✅ Built '{target_eval_name}' with {len(services)} services")
    return target_eval_name

def print_eval_summary(run_output: Dict[str, Any], title: str, eval_type_name: str) -> None:
    """Pretty-print the aggregate metrics."""
    agg = run_output["aggregate"]
    config = run_output["config"]

    print("=" * 60)
    print(f"  {title.upper()} — {run_output['run_name']}")
    print("=" * 60)
    print(f"  Model      : {config['embedding_model']}")
    print(f"  Collection : {config['collection']}")
    print(f"  Top-K      : {config['top_k']}")
    print(f"  {eval_type_name:<10} : {agg['num_queries']}")
    print("-" * 60)

    metric_names = ["Hit", "Prec", "Recall", "MRR", "NDCG"]
    k_values = config["k_values"]

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

    if any(f"NDCG_G@{k}" in agg for k in k_values):
        row = f"{'NDCG_G':<12}"
        for k in k_values:
            key = f"NDCG_G@{k}"
            val = agg.get(key, 0.0)
            row += f"{val:>10.4f}"
        print(row)

    if any(f"HNR@{k}" in agg for k in k_values):
        row = f"{'HNR ↓':<12}"
        for k in k_values:
            key = f"HNR@{k}"
            val = agg.get(key, 0.0)
            row += f"{val:>10.4f}"
        print(row)

    if any(f"Diversity@{k}" in agg for k in k_values):
        row = f"{'Diversity':<12}"
        for k in k_values:
            key = f"Diversity@{k}"
            val = agg.get(key, 0.0)
            row += f"{val:>10.4f}"
        print(row)

    print("=" * 60)
