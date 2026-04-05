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
    - NDCG@K       : Normalised Discounted Cumulative Gain at K

All scores are in [0, 1].
"""

from __future__ import annotations

import math
from typing import Dict, List, Sequence


# ---------------------------------------------------------------------------
# Single-query metrics
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
                    "Hit@3":  0.88,
                    ...
                    "num_queries": 50
                }
            }
    """
    if k_values is None:
        k_values = [1, 3, 5, 10]

    metric_fns = {
        "Hit":   hit_at_k,
        "Prec":  precision_at_k,
        "Recall": recall_at_k,
        "MRR":   mrr_at_k,
        "NDCG":  ndcg_at_k,
    }

    per_query_results: List[Dict] = []
    # accumulators:  metric_name -> running sum
    totals: Dict[str, float] = {}

    for pred in predictions:
        retrieved = pred["retrieved_ids"]
        relevant = pred["relevant_ids"]
        row: Dict[str, object] = {"id": pred.get("id", "")}

        for metric_name, fn in metric_fns.items():
            for k in k_values:
                key = f"{metric_name}@{k}"
                score = fn(retrieved, relevant, k)
                row[key] = round(score, 4)
                totals[key] = totals.get(key, 0.0) + score

        per_query_results.append(row)

    n = len(predictions)
    aggregate = {key: round(val / n, 4) for key, val in totals.items()} if n else {}
    aggregate["num_queries"] = n

    return {
        "per_query": per_query_results,
        "aggregate": aggregate,
    }
