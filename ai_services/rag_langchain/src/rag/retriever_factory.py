"""
retriever_factory.py — Factory chọn retriever theo RAG_MODE.

Đây là điểm duy nhất quyết định dùng RAG cũ hay RAG mới.
offline_rag.py KHÔNG cần sửa — vẫn nhận retriever và gọi retriever.invoke(question).

Sơ đồ Advanced RAG:
  User question
       │
       ├─► [Dense]  embedding search (VI hoặc EN)
       │
       └─► [Sparse] BM25 search (query EN sau dịch Mistral)
                │
                ▼
           RRF Fusion (gộp 2 list, lấy top_k)
                │
                ▼
           CrossEncoder Reranker (lấy rerank_top_n chunk tốt nhất)
                │
                ▼
           Đưa vào prompt [WELLNESS KNOWLEDGE BASE]
"""

from __future__ import annotations

from typing import List, Sequence

from langchain_core.documents import Document
from langchain_core.retrievers import BaseRetriever
from langchain_core.callbacks import CallbackManagerForRetrieverRun
from pydantic import Field

from src.rag.settings import RagSettings, load_rag_settings


def _rrf_fuse_doc_lists(
    ranked_lists: Sequence[Sequence[Document]],
    *,
    k: int = 60,
    top_n: int,
) -> List[Document]:
    """
    RRF trên danh sách Document (dùng cho hybrid local Chroma + BM25).
    Khác elasticsearch_retriever._rrf_fuse: làm việc với doc_id trong metadata.
    """
    scores: dict[str, float] = {}
    doc_map: dict[str, Document] = {}

    for docs in ranked_lists:
        for rank, doc in enumerate(docs, start=1):
            doc_id = str(
                doc.metadata.get("doc_id")
                or doc.metadata.get("chunk_id")
                or hash(doc.page_content)
            )
            scores[doc_id] = scores.get(doc_id, 0.0) + 1.0 / (k + rank)
            doc_map[doc_id] = doc

    ordered = sorted(scores.items(), key=lambda item: item[1], reverse=True)
    return [doc_map[doc_id] for doc_id, _ in ordered[:top_n]]


def _wrap_with_reranker(base_retriever: BaseRetriever, settings: RagSettings):
    """
    Bọc retriever bằng CrossEncoder reranker.

    CrossEncoder chấm cặp (query, chunk) chính xác hơn bi-encoder (embedding),
    nhưng chậm hơn → chỉ rerank top_k ứng viên, giữ rerank_top_n.
    """
    from langchain.retrievers import ContextualCompressionRetriever
    from langchain.retrievers.document_compressors import CrossEncoderReranker
    from langchain_community.cross_encoders import HuggingFaceCrossEncoder

    cross_encoder = HuggingFaceCrossEncoder(model_name=settings.reranker_model)
    reranker = CrossEncoderReranker(
        model=cross_encoder,
        top_n=settings.rerank_top_n,
    )
    return ContextualCompressionRetriever(
        base_compressor=reranker,
        base_retriever=base_retriever,
    )


class LocalHybridRetriever(BaseRetriever):
    """
    Hybrid khi CHƯA có Elasticsearch — chạy trên PDF local trong RAM.

    - Dense: Chroma + HuggingFaceEmbeddings (giống standard nhưng chỉ là 1 nhánh)
    - Sparse: BM25Retriever (rank-bm25) trên cùng tập chunk
    - Fusion: RRF trong _rrf_fuse_doc_lists
    """

    settings: RagSettings = Field(...)
    documents: List[Document] = Field(default_factory=list)

    def _ensure_retrievers(self) -> None:
        """Lazy init — tránh build BM25/Chroma lúc import module."""
        if getattr(self, "_dense_retriever", None) is not None:
            return
        from langchain_community.retrievers import BM25Retriever
        from src.rag.vectorstore import VectorDB, _build_embedding_model

        embedding = _build_embedding_model()
        dense_db = VectorDB(documents=self.documents, embedding=embedding)
        self._dense_retriever = dense_db.get_retriever(search_kwargs={"k": self.settings.top_k})
        self._bm25_retriever = BM25Retriever.from_documents(self.documents)
        self._bm25_retriever.k = self.settings.top_k

    def _get_relevant_documents(
        self,
        query: str,
        *,
        run_manager: CallbackManagerForRetrieverRun | None = None,
    ) -> List[Document]:
        from src.rag.query_translator import translate_query_to_english

        self._ensure_retrievers()

        # Dense dùng query gốc; BM25 dùng bản dịch EN
        sparse_query = query
        if self.settings.query_translation_enabled:
            sparse_query = translate_query_to_english(
                query,
                model=self.settings.translation_model,
            )

        dense_docs = list(self._dense_retriever.invoke(query))
        sparse_docs = list(self._bm25_retriever.invoke(sparse_query))

        return _rrf_fuse_doc_lists(
            [dense_docs, sparse_docs],
            top_n=self.settings.top_k,
        )


class ElasticsearchQueryAwareRetriever(BaseRetriever):
    """
    Wrapper ES hybrid + dịch query cho nhánh sparse.

    Tách lớp này để elasticsearch_retriever.py chỉ lo search,
    còn logic dịch nằm ở đây (dễ test / đọc code).
    """

    settings: RagSettings = Field(...)

    def _get_relevant_documents(
        self,
        query: str,
        *,
        run_manager: CallbackManagerForRetrieverRun | None = None,
    ) -> List[Document]:
        from src.rag.elasticsearch_retriever import ElasticsearchHybridRetriever
        from src.rag.query_translator import translate_query_to_english

        sparse_query = query
        if self.settings.query_translation_enabled:
            sparse_query = translate_query_to_english(
                query,
                model=self.settings.translation_model,
            )

        inner = ElasticsearchHybridRetriever(
            settings=self.settings,
            sparse_query=sparse_query,
        )
        return inner.invoke(query)


def build_retriever(
    documents: Sequence[Document] | None = None,
    settings: RagSettings | None = None,
):
    """
    Hàm chính — được gọi từ main.build_rag_chain().

    Returns:
        Retriever tương thích Offline_RAG.get_chain(retriever).

    Raises:
        ValueError nếu thiếu documents (standard) hoặc thiếu ES+documents (advanced).
    """
    settings = settings or load_rag_settings()

    # ── STANDARD: hành vi cũ 100% ──
    if not settings.is_advanced:
        if not documents:
            raise ValueError("Standard RAG mode requires documents.")
        from src.rag.vectorstore import VectorDB

        retriever = VectorDB(documents=list(documents)).get_retriever(
            search_kwargs={"k": settings.top_k},
        )
        print(f"✅ RAG mode: standard (top_k={settings.top_k})")
        return retriever

    # ── ADVANCED: hybrid + fusion + rerank ──
    print(
        "✅ RAG mode: advanced "
        f"(top_k={settings.top_k}, rerank_top_n={settings.rerank_top_n}, "
        f"es={'on' if settings.elasticsearch_enabled else 'off'})"
    )

    if settings.elasticsearch_enabled:
        # Corpus WHO đã ingest vào OpenSearch
        base = ElasticsearchQueryAwareRetriever(settings=settings)
    else:
        # Dev local: PDF trong data_source/generative_ai
        if not documents:
            raise ValueError(
                "Advanced RAG without Elasticsearch requires local PDF documents."
            )
        base = LocalHybridRetriever(settings=settings, documents=list(documents))

    return _wrap_with_reranker(base, settings)
