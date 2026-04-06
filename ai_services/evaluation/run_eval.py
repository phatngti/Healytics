import logging
import os
import random
import sys
from typing import Any, Dict, List


# Ensure `import src.*` resolves to rag_langchain/src (no changes to src/)
EVAL_DIR = os.path.dirname(os.path.abspath(__file__))
RAG_LANGCHAIN_DIR = os.path.abspath(os.path.join(EVAL_DIR, "..", "rag_langchain"))
if RAG_LANGCHAIN_DIR not in sys.path:
    sys.path.insert(0, RAG_LANGCHAIN_DIR)


from config import (  # noqa: E402
    API_KEY,
    BASE_URL,
    DATASET_PATH,
    EMBEDDING_DEVICE,
    LOG_LEVEL,
    MAX_NEW_TOKENS,
    MODE,
    MODEL_NAME,
    SEED,
    TEMPERATURE,
    TOP_K,
    VECTORSTORE_BACKEND,
)
from dataset_loader import load_eval_dataset  # noqa: E402
from judge_eval import judge_sample  # noqa: E402
from llm_eval import build_rag_chain, generate_answer, get_llm  # noqa: E402
from metrics import hit_at_k, mrr, recall_at_k  # noqa: E402
from retriever_eval import build_retriever, retrieve_top_k_doc_ids  # noqa: E402


def _setup_logging():
    logging.basicConfig(
        level=getattr(logging, LOG_LEVEL, logging.INFO),
        format="%(asctime)s | %(levelname)s | %(message)s",
    )


def main():
    _setup_logging()
    logger = logging.getLogger("eval")

    random.seed(SEED)

    try:
        from tqdm import tqdm
    except Exception:
        tqdm = None

    logger.info("Loading dataset: %s", DATASET_PATH)
    documents, eval_dataset, docid_to_content = load_eval_dataset(DATASET_PATH)
    logger.info("Documents: %d | Samples: %d", len(documents), len(eval_dataset))

    logger.info("Building retriever (backend=%s, top_k=%s, embedding_device=%s)", VECTORSTORE_BACKEND, TOP_K, EMBEDDING_DEVICE)
    retriever = build_retriever(
        documents=documents,
        top_k=TOP_K,
        vectorstore_backend=VECTORSTORE_BACKEND,
        embedding_device=EMBEDDING_DEVICE,
    )

    logger.info("Loading LLM (mode=%s, model=%s)", MODE, MODEL_NAME)
    llm = get_llm(
        mode=MODE,
        model_name=MODEL_NAME,
        base_url=BASE_URL,
        api_key=API_KEY,
        temperature=TEMPERATURE,
        max_new_tokens=MAX_NEW_TOKENS,
    )

    rag_chain = build_rag_chain(mode=MODE, llm=llm, retriever=retriever)

    totals: Dict[str, float] = {
        f"hit@{TOP_K}": 0.0,
        f"recall@{TOP_K}": 0.0,
        "mrr": 0.0,
        "faithfulness": 0.0,
        "correctness": 0.0,
        "context_relevance": 0.0,
    }

    iterable = eval_dataset
    if tqdm is not None:
        iterable = tqdm(eval_dataset, desc="Evaluating", unit="sample")

    n = 0
    for sample in iterable:
        n += 1
        qid = sample.get("id", f"sample_{n}")
        query = sample.get("query", "")
        ground_truth = sample.get("ground_truth", "")
        relevant_doc_ids = sample.get("relevant_doc_ids", []) or []

        try:
            retrieved_doc_ids, retrieved_docs = retrieve_top_k_doc_ids(retriever, query, TOP_K)

            totals[f"hit@{TOP_K}"] += hit_at_k(retrieved_doc_ids, relevant_doc_ids, TOP_K)
            totals[f"recall@{TOP_K}"] += recall_at_k(retrieved_doc_ids, relevant_doc_ids, TOP_K)
            totals["mrr"] += mrr(retrieved_doc_ids, relevant_doc_ids)

            context_chunks: List[str] = []
            for d in retrieved_docs:
                # prefer original dataset mapping (doc_id -> content) to avoid any vectorstore text modifications
                doc_id = ""
                if hasattr(d, "metadata") and isinstance(d.metadata, dict):
                    doc_id = str(d.metadata.get("doc_id") or "")
                if doc_id and doc_id in docid_to_content:
                    context_chunks.append(docid_to_content[doc_id])
                else:
                    context_chunks.append(getattr(d, "page_content", str(d)))
            retrieved_context = "\n\n".join(context_chunks)

            answer = generate_answer(rag_chain, query=query, history="", services="")

            judge_scores = judge_sample(
                llm=llm,
                question=query,
                context=retrieved_context,
                answer=answer,
                ground_truth=ground_truth,
            )

            totals["faithfulness"] += judge_scores["faithfulness"]
            totals["correctness"] += judge_scores["correctness"]
            totals["context_relevance"] += judge_scores["context_relevance"]

        except Exception as e:
            logger.exception("Failed sample id=%s: %s", qid, e)

    if n == 0:
        logger.error("No samples found in eval_dataset.")
        return

    report = {
        f"avg_hit@{TOP_K}": totals[f"hit@{TOP_K}"] / n,
        f"avg_recall@{TOP_K}": totals[f"recall@{TOP_K}"] / n,
        "avg_mrr": totals["mrr"] / n,
        "avg_faithfulness": totals["faithfulness"] / n,
        "avg_correctness": totals["correctness"] / n,
        "avg_context_relevance": totals["context_relevance"] / n,
        "n_samples": n,
        "top_k": TOP_K,
        "mode": MODE,
        "model_name": MODEL_NAME,
        "vectorstore_backend": VECTORSTORE_BACKEND,
        "embedding_device": EMBEDDING_DEVICE,
    }

    logger.info("==== EVAL REPORT ====")
    for k, v in report.items():
        if isinstance(v, float):
            logger.info("%s: %.4f", k, v)
        else:
            logger.info("%s: %s", k, v)


if __name__ == "__main__":
    main()

