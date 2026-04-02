import os
import sys
from typing import Any, Dict, List, Sequence, Tuple


# Ensure `import src.*` resolves to rag_langchain/src
EVAL_DIR = os.path.dirname(os.path.abspath(__file__))
RAG_LANGCHAIN_DIR = os.path.abspath(os.path.join(EVAL_DIR, "..", "rag_langchain"))
if RAG_LANGCHAIN_DIR not in sys.path:
    sys.path.insert(0, RAG_LANGCHAIN_DIR)


def _make_langchain_documents(documents: Sequence[Dict[str, Any]]):
    # Import lazily to avoid import-time failures if langchain package differs.
    from langchain_core.documents import Document

    lc_docs = []
    for d in documents:
        doc_id = d.get("doc_id")
        content = d.get("content", "")
        if not doc_id:
            continue
        lc_docs.append(Document(page_content=content, metadata={"doc_id": doc_id}))
    return lc_docs


def build_retriever(
    documents: Sequence[Dict[str, Any]],
    top_k: int,
    vectorstore_backend: str = "chroma",
    embedding_device: str = "cuda",
):
    from langchain_community.embeddings import HuggingFaceEmbeddings
    from langchain_chroma import Chroma
    from langchain_community.vectorstores import FAISS

    embedding = HuggingFaceEmbeddings(model_kwargs={"device": embedding_device})
    backend = Chroma if vectorstore_backend == "chroma" else FAISS

    lc_docs = _make_langchain_documents(documents)
    # Prefer using existing VectorDB wrapper from src (current pipeline).
    # If src import fails (e.g. missing optional deps like torch), fall back to backend directly.
    try:
        from src.rag.vectorstore import VectorDB  # type: ignore

        vectordb = VectorDB(documents=lc_docs, vector_db=backend, embedding=embedding)
        return vectordb.get_retriever(search_kwargs={"k": int(top_k)})
    except Exception:
        db = backend.from_documents(documents=lc_docs, embedding=embedding)
        return db.as_retriever(search_kwargs={"k": int(top_k)})


def get_retrieved_documents(retriever, query: str) -> List[Any]:
    """
    LangChain 0.2+: VectorStoreRetriever is Runnable — dùng invoke(query).
    LangChain cũ: get_relevant_documents(query).
    """
    invoke_fn = getattr(retriever, "invoke", None)
    if callable(invoke_fn):
        try:
            out = invoke_fn(query)
        except TypeError:
            out = invoke_fn({"query": query})
        if out is None:
            return []
        return list(out)

    grd = getattr(retriever, "get_relevant_documents", None)
    if callable(grd):
        return list(grd(query))

    raise TypeError(
        f"Retriever {type(retriever).__name__} không có invoke() hay get_relevant_documents()."
    )


def retrieve_top_k_doc_ids(retriever, query: str, top_k: int) -> Tuple[List[str], List[Any]]:
    """
    Returns:
      - doc_id list (length <= top_k)
      - raw langchain Document list
    """
    docs = get_retrieved_documents(retriever, query)
    docs = list(docs)[: int(top_k)]

    doc_ids: List[str] = []
    for d in docs:
        doc_id = None
        if hasattr(d, "metadata") and isinstance(d.metadata, dict):
            doc_id = d.metadata.get("doc_id")
        doc_ids.append(str(doc_id) if doc_id is not None else "")

    return doc_ids, docs

