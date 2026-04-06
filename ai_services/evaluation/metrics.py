from typing import Iterable, List, Sequence


def hit_at_k(retrieved_docs: Sequence[str], relevant_docs: Iterable[str], k: int) -> float:
    rel = set(relevant_docs)
    topk = list(retrieved_docs)[:k]
    return 1.0 if any(d in rel for d in topk) else 0.0


def recall_at_k(retrieved_docs: Sequence[str], relevant_docs: Iterable[str], k: int) -> float:
    rel = set(relevant_docs)
    if not rel:
        return 0.0
    topk = set(list(retrieved_docs)[:k])
    return len(topk.intersection(rel)) / float(len(rel))


def mrr(retrieved_docs: Sequence[str], relevant_docs: Iterable[str]) -> float:
    rel = set(relevant_docs)
    for idx, doc_id in enumerate(retrieved_docs, start=1):
        if doc_id in rel:
            return 1.0 / float(idx)
    return 0.0

