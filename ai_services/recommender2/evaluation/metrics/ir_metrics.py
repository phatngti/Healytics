"""
evaluation/metrics/ir_metrics.py

Information Retrieval metrics for evaluating the Healytics recommender system.
All functions operate on a single query at a time. Use `compute_all_metrics`
to aggregate across an entire evaluation dataset.

Metrics implemented:
    - Hit@K        : Was ≥1 relevant item retrieved in top-K?
    - Precision@K  : Fraction of top-K that are relevant
    - Recall@K     : Fraction of all relevant items found in top-K
    - MRR@K        : Reciprocal rank of the first relevant item in top-K
    - NDCG@K       : Normalised Discounted Cumulative Gain at K (binary)
    - NDCG_G@K     : Normalised Discounted Cumulative Gain at K (graded)
    - HNR@K        : Hard Negative Rate at K
    - Diversity@K  : Intra-List Diversity at K (1 - avg pairwise cosine sim)

All scores are in [0, 1].
"""

from __future__ import annotations

import math
from typing import Dict, List, Mapping, Sequence


# ---------------------------------------------------------------------------
# Single-query metrics (original)
# ---------------------------------------------------------------------------

def hit_at_k(retrieved_ids: Sequence[str],
             relevant_ids: Sequence[str],
             k: int) -> float:
    """Return 1.0 if ≥1 relevant item appears in the first *k* retrieved."""
    top_k = set(retrieved_ids[:k])
    return 1.0 if top_k & set(relevant_ids) else 0.0


def precision_at_k(retrieved_ids: Sequence[str],
                   relevant_ids: Sequence[str],
                   k: int) -> float:
    """Fraction of top-K retrieved items that are relevant."""
    top_k = retrieved_ids[:k]
    if not top_k:
        return 0.0
    relevant_set = set(relevant_ids)
    hits = sum(1 for doc_id in top_k if doc_id in relevant_set)
    return hits / len(top_k)


def recall_at_k(retrieved_ids: Sequence[str],
                relevant_ids: Sequence[str],
                k: int) -> float:
    """Fraction of all relevant items that appear in the top-K retrieved."""
    if not relevant_ids:
        return 0.0
    top_k = set(retrieved_ids[:k])
    relevant_set = set(relevant_ids)
    hits = len(top_k & relevant_set)
    return hits / len(relevant_set)


def mrr_at_k(retrieved_ids: Sequence[str],
             relevant_ids: Sequence[str],
             k: int) -> float:
    """Reciprocal Rank: 1 / (rank of first relevant item).

    Returns 0 if no relevant item appears in the first *k* results.
    """
    relevant_set = set(relevant_ids)
    for rank, doc_id in enumerate(retrieved_ids[:k], start=1):
        if doc_id in relevant_set:
            return 1.0 / rank
    return 0.0


def ndcg_at_k(retrieved_ids: Sequence[str],
              relevant_ids: Sequence[str],
              k: int) -> float:
    """Normalised Discounted Cumulative Gain at K.

    Uses *binary* relevance: 1 if the item is in `relevant_ids`, else 0.
    """
    relevant_set = set(relevant_ids)

    # DCG for the actual ranking
    dcg = 0.0
    for i, doc_id in enumerate(retrieved_ids[:k]):
        if doc_id in relevant_set:
            dcg += 1.0 / math.log2(i + 2)  # i+2 because rank starts at 1

    # Ideal DCG: all relevant items placed at the top
    ideal_hits = min(len(relevant_set), k)
    idcg = sum(1.0 / math.log2(i + 2) for i in range(ideal_hits))

    if idcg == 0.0:
        return 0.0
    return dcg / idcg


# ---------------------------------------------------------------------------
# New: Graded NDCG
# ---------------------------------------------------------------------------

def ndcg_at_k_graded(
    retrieved_ids: Sequence[str],
    relevance_grades: Mapping[str, int],
    k: int,
) -> float:
    """Normalised Discounted Cumulative Gain at K with *graded* relevance.

    Parameters
    ----------
    retrieved_ids : sequence of str
        Ranked list of retrieved document IDs.
    relevance_grades : mapping str -> int
        Maps document IDs to relevance grades.
        Convention for healthcare context:
            2 = Directly solves the problem (trực tiếp giải quyết vấn đề)
            1 = Somewhat related (có liên quan một chút)
            0 = Not relevant (không liên quan — default for missing IDs)
    k : int
        Cutoff.

    Returns
    -------
    float
        NDCG score in [0, 1].
    """
    # DCG for the actual ranking
    dcg = 0.0
    for i, doc_id in enumerate(retrieved_ids[:k]):
        grade = relevance_grades.get(doc_id, 0)
        if grade > 0:
            dcg += grade / math.log2(i + 2)

    # Ideal DCG: sort all grades descending and place at top
    all_grades = sorted(relevance_grades.values(), reverse=True)
    ideal_grades = all_grades[:k]
    idcg = sum(g / math.log2(i + 2) for i, g in enumerate(ideal_grades) if g > 0)

    if idcg == 0.0:
        return 0.0
    return dcg / idcg


# ---------------------------------------------------------------------------
# New: Hard Negative Rate
# ---------------------------------------------------------------------------

def hard_negative_rate_at_k(
    retrieved_ids: Sequence[str],
    hard_negative_ids: Sequence[str],
    k: int,
) -> float:
    """Fraction of top-K retrieved items that are hard negatives.

    Hard negatives are semantically similar but NOT actually relevant.
    A *lower* score is better (0.0 = no hard negatives retrieved).

    Parameters
    ----------
    retrieved_ids : sequence of str
        Ranked list of retrieved document IDs.
    hard_negative_ids : sequence of str
        IDs of hard-negative documents for this query.
    k : int
        Cutoff.

    Returns
    -------
    float
        Rate in [0, 1].  Lower is better.
    """
    top_k = retrieved_ids[:k]
    if not top_k:
        return 0.0
    hn_set = set(hard_negative_ids)
    hits = sum(1 for doc_id in top_k if doc_id in hn_set)
    return hits / len(top_k)


# ---------------------------------------------------------------------------
# New: Intra-List Diversity
# ---------------------------------------------------------------------------

def _cosine_similarity(a: List[float], b: List[float]) -> float:
    """Compute cosine similarity between two vectors."""
    dot = sum(ai * bi for ai, bi in zip(a, b))
    norm_a = math.sqrt(sum(ai * ai for ai in a))
    norm_b = math.sqrt(sum(bi * bi for bi in b))
    if norm_a == 0.0 or norm_b == 0.0:
        return 0.0
    return dot / (norm_a * norm_b)


def intra_list_similarity(
    retrieved_embeddings: Sequence[List[float]],
    k: int,
) -> float:
    """Intra-List Diversity score for top-K results.

    Computes ``1 - mean(pairwise cosine similarities)`` among the top-K
    retrieved embeddings.

    A *higher* score means more diverse results (better UX).
    Returns 0.0 if fewer than 2 items.

    Parameters
    ----------
    retrieved_embeddings : sequence of vectors
        Embedding vectors corresponding to retrieved items, in rank order.
    k : int
        Cutoff.

    Returns
    -------
    float
        Diversity score in [0, 1].  Higher is more diverse.
    """
    top_k = list(retrieved_embeddings[:k])
    n = len(top_k)
    if n < 2:
        return 0.0

    total_sim = 0.0
    pairs = 0
    for i in range(n):
        for j in range(i + 1, n):
            total_sim += _cosine_similarity(top_k[i], top_k[j])
            pairs += 1

    avg_sim = total_sim / pairs if pairs > 0 else 0.0
    return 1.0 - avg_sim


# ---------------------------------------------------------------------------
# Aggregate across an evaluation dataset
# ---------------------------------------------------------------------------

def compute_all_metrics(
    predictions: List[Dict],
    k_values: List[int] | None = None,
) -> Dict[str, Dict[str, float]]:
    """Compute all IR metrics across a list of predictions.

    Parameters
    ----------
    predictions : list of dict
        Each dict must have:
            - ``"retrieved_ids"`` : list[str]  —  ranked results from the model
            - ``"relevant_ids"``  : list[str]  —  ground-truth relevant items
        Optionally:
            - ``"id"``            : str        —  query identifier
            - ``"scores"``        : list[float] — cosine similarity scores
            - ``"hard_negative_ids"`` : list[str] — hard negative IDs
            - ``"relevance_grades"``  : dict[str, int] — graded relevance
            - ``"retrieved_embeddings"`` : list[list[float]] — embedding vectors
            - ``"latency_ms"``    : float — retrieval latency in milliseconds
    k_values : list[int], optional
        K cut-offs to evaluate.  Defaults to [1, 3, 5, 10].

    Returns
    -------
    dict
        Structure::

            {
                "per_query": [   # one entry per prediction
                    {"id": "CB_001", "Hit@3": 1.0, "Prec@3": 0.33, ...},
                    ...
                ],
                "aggregate": {   # macro-averaged over all queries
                    "Hit@1":  0.72,
                    ...,
                    "NDCG_G@3": 0.65,    # graded (if grades present)
                    "HNR@3":    0.10,     # hard neg rate (if HN present)
                    "Diversity@3": 0.45,  # diversity (if embeddings)
                    "Latency_avg_ms": 12.3,
                    "num_queries": 50
                }
            }
    """
    if k_values is None:
        k_values = [1, 3, 5, 10]

    # Core metric functions (binary relevance)
    metric_fns = {
        "Hit":   hit_at_k,
        "Prec":  precision_at_k,
        "Recall": recall_at_k,
        "MRR":   mrr_at_k,
        "NDCG":  ndcg_at_k,
    }

    # Detect which optional features are available
    has_grades = any(pred.get("relevance_grades") for pred in predictions)
    has_hard_negatives = any(pred.get("hard_negative_ids") for pred in predictions)
    has_embeddings = any(pred.get("retrieved_embeddings") for pred in predictions)
    has_latency = any(pred.get("latency_ms") is not None for pred in predictions)

    per_query_results: List[Dict] = []
    totals: Dict[str, float] = {}
    optional_totals: Dict[str, float] = {}
    optional_counts: Dict[str, int] = {}
    latencies: List[float] = []

    for pred in predictions:
        retrieved = pred["retrieved_ids"]
        relevant = pred["relevant_ids"]
        row: Dict[str, object] = {"id": pred.get("id", "")}

        # --- Core metrics ---
        for metric_name, fn in metric_fns.items():
            for k in k_values:
                key = f"{metric_name}@{k}"
                score = fn(retrieved, relevant, k)
                row[key] = round(score, 4)
                totals[key] = totals.get(key, 0.0) + score

        # --- Graded NDCG ---
        if has_grades:
            grades = pred.get("relevance_grades", {})
            if grades:
                for k in k_values:
                    key = f"NDCG_G@{k}"
                    score = ndcg_at_k_graded(retrieved, grades, k)
                    row[key] = round(score, 4)
                    optional_totals[key] = optional_totals.get(key, 0.0) + score
                    optional_counts[key] = optional_counts.get(key, 0) + 1

        # --- Hard Negative Rate ---
        if has_hard_negatives:
            hn_ids = pred.get("hard_negative_ids", [])
            if hn_ids:
                for k in k_values:
                    key = f"HNR@{k}"
                    score = hard_negative_rate_at_k(retrieved, hn_ids, k)
                    row[key] = round(score, 4)
                    optional_totals[key] = optional_totals.get(key, 0.0) + score
                    optional_counts[key] = optional_counts.get(key, 0) + 1

        # --- Diversity ---
        if has_embeddings:
            embeddings = pred.get("retrieved_embeddings")
            if embeddings:
                for k in k_values:
                    key = f"Diversity@{k}"
                    score = intra_list_similarity(embeddings, k)
                    row[key] = round(score, 4)
                    optional_totals[key] = optional_totals.get(key, 0.0) + score
                    optional_counts[key] = optional_counts.get(key, 0) + 1

        # --- Latency ---
        if has_latency and pred.get("latency_ms") is not None:
            row["latency_ms"] = round(pred["latency_ms"], 2)
            latencies.append(pred["latency_ms"])

        per_query_results.append(row)

    # --- Aggregate ---
    n = len(predictions)
    aggregate = {key: round(val / n, 4) for key, val in totals.items()} if n else {}

    # Optional metrics: average only over queries that have the data
    for key, total in optional_totals.items():
        count = optional_counts.get(key, 1)
        aggregate[key] = round(total / count, 4) if count > 0 else 0.0

    # Latency statistics
    if latencies:
        latencies_sorted = sorted(latencies)
        aggregate["Latency_avg_ms"] = round(sum(latencies) / len(latencies), 2)
        aggregate["Latency_p50_ms"] = round(
            latencies_sorted[len(latencies_sorted) // 2], 2
        )
        p95_idx = min(int(len(latencies_sorted) * 0.95), len(latencies_sorted) - 1)
        aggregate["Latency_p95_ms"] = round(latencies_sorted[p95_idx], 2)
        p99_idx = min(int(len(latencies_sorted) * 0.99), len(latencies_sorted) - 1)
        aggregate["Latency_p99_ms"] = round(latencies_sorted[p99_idx], 2)
        aggregate["Latency_max_ms"] = round(latencies_sorted[-1], 2)

    aggregate["num_queries"] = n

    return {
        "per_query": per_query_results,
        "aggregate": aggregate,
    }
