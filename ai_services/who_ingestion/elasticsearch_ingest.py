"""
elasticsearch_ingest.py — Tạo index ES và bulk-ingest chunk + embedding.

Index `healytics_who_chunks` phục vụ Advanced RAG:
  - BM25 trên content_en, title
  - kNN trên embedding (768 dims, cosine)

Mapping phải khớp elasticsearch_retriever.py trong rag_langchain.
"""

from __future__ import annotations

import copy
from typing import Iterable, List, Sequence, Tuple

from who_ingestion.chunker import WhoChunk
from who_ingestion.config import WhoIngestionSettings

# Domain AWS 3-AZ: copies = shards × (1 + replicas) phải chia hết cho 3.
_AWARENESS_SHARD_CONFIGS: Tuple[Tuple[int, int], ...] = (
    (1, 2),  # hay nhất cho domain AWS 3-AZ dev (1 primary + 2 replica = 3 copies)
    (3, 0),
    (6, 0),
    (3, 2),
)


def _build_client(settings: WhoIngestionSettings):
    """Kết nối ES — dùng common/es_client.py (hỗ trợ IAM + basic auth + API key)."""
    from opensearchpy.helpers import bulk

    from common.es_client import build_elasticsearch_client

    client = build_elasticsearch_client(
        url=settings.elasticsearch_url,
        api_key=settings.elasticsearch_api_key,
        username=settings.elasticsearch_username,
        password=settings.elasticsearch_password,
        verify_certs=settings.elasticsearch_verify_certs,
        aws_region=settings.aws_region,
        aws_access_key_id=settings.aws_access_key_id,
        aws_secret_access_key=settings.aws_secret_access_key,
    )
    return client, bulk


def _index_mapping(settings: WhoIngestionSettings) -> dict:
    """
    Schema index cho AWS OpenSearch — field quan trọng:
      content_en: full-text BM25 (tiếng Anh)
      embedding: knn_vector (HNSW, cosine) cho semantic search

    Lưu ý OpenSearch (khác Elasticsearch):
      - vector field type = knn_vector + dimension (không phải dense_vector + dims)
      - cần settings index.knn = true để bật kNN
    """
    return {
        "settings": {
            # Shards/replicas đặt ở root khi create (đảm bảo OpenSearch đọc đúng).
            "index.knn": True,
            "analysis": {
                "analyzer": {
                    "english_medical": {
                        "type": "standard",
                    }
                }
            },
        },
        "mappings": {
            "properties": {
                "chunk_id": {"type": "keyword"},
                "doc_id": {"type": "keyword"},
                "domain": {"type": "keyword"},
                "title": {"type": "text"},
                "source_url": {"type": "keyword"},
                "s3_key": {"type": "keyword"},
                "keyword": {"type": "keyword"},
                "content": {"type": "text"},
                "content_en": {"type": "text", "analyzer": "english_medical"},
                "token_count": {"type": "integer"},
                "chunk_index": {"type": "integer"},
                "embedding": {
                    "type": "knn_vector",
                    "dimension": settings.embedding_dims,
                    "method": {
                        "name": "hnsw",
                        "space_type": "cosinesimil",
                        # OpenSearch 3.x: nmslib deprecated → bắt buộc lucene (hoặc faiss)
                        "engine": "lucene",
                    },
                },
            }
        },
    }


def _awareness_copies(shards: int, replicas: int) -> int:
    return shards * (1 + replicas)


def _create_index_with_awareness(client, index: str, base_mapping: dict, settings: WhoIngestionSettings) -> Tuple[int, int]:
    """
    Thử lần lượt các cấu hình shard hợp lệ với zone awareness 3-AZ.
    """
    preferred = (settings.elasticsearch_number_of_shards, settings.elasticsearch_number_of_replicas)
    candidates: list[Tuple[int, int]] = []
    for cfg in (preferred, *_AWARENESS_SHARD_CONFIGS):
        if cfg not in candidates and _awareness_copies(cfg[0], cfg[1]) % 3 == 0:
            candidates.append(cfg)

    last_exc: Exception | None = None
    for shards, replicas in candidates:
        body = copy.deepcopy(base_mapping)
        body["settings"]["number_of_shards"] = shards
        body["settings"]["number_of_replicas"] = replicas
        try:
            client.indices.create(index=index, body=body)
            return shards, replicas
        except Exception as exc:
            err = str(exc).lower()
            if "awareness attributes" in err or "awareness attribute" in err:
                last_exc = exc
                print(f"⚠️  shards={shards}, replicas={replicas} không hợp lệ 3-AZ — thử cấu hình khác...")
                continue
            raise

    if last_exc:
        raise last_exc
    raise RuntimeError("Không tìm được cấu hình shard hợp lệ cho domain 3-AZ.")


class WhoElasticsearchIngestor:
    def __init__(self, settings: WhoIngestionSettings) -> None:
        self.settings = settings
        self._embedding_model = None

    def _embed(self, texts: Sequence[str]) -> List[List[float]]:
        """Embed batch chunk — cùng model với RAG (RAG_EMBEDDING_MODEL)."""
        if self._embedding_model is None:
            from langchain_community.embeddings import HuggingFaceEmbeddings

            self._embedding_model = HuggingFaceEmbeddings(
                model_name=self.settings.embedding_model,
                model_kwargs={"device": "cpu"},
            )
        return self._embedding_model.embed_documents(list(texts))

    def ensure_index(self) -> None:
        """Tạo index nếu chưa có; xóa+tạo lại nếu ELASTICSEARCH_RECREATE_INDEX=true."""
        client, _ = _build_client(self.settings)
        index = self.settings.elasticsearch_index

        exists = client.indices.exists(index=index)
        if exists and self.settings.elasticsearch_recreate_index:
            client.indices.delete(index=index)
            exists = False

        if not exists:
            mapping = _index_mapping(self.settings)
            shards, replicas = _create_index_with_awareness(
                client, index, mapping, self.settings
            )
            print(f"✅ Created OpenSearch index: {index} (shards={shards}, replicas={replicas})")
        else:
            print(f"ℹ️ OpenSearch index already exists: {index}")

    def ingest_chunks(self, chunks: Iterable[WhoChunk]) -> int:
        """
        Bulk index danh sách chunk.

        Mỗi document ES có cả text lẫn vector → RAG hybrid đọc được ngay.
        """
        client, bulk = _build_client(self.settings)
        chunk_list = list(chunks)
        if not chunk_list:
            return 0

        texts_for_embedding = [c.content_en or c.content for c in chunk_list]
        vectors = self._embed(texts_for_embedding)

        actions = []
        for chunk, vector in zip(chunk_list, vectors):
            actions.append(
                {
                    "_op_type": "index",
                    "_index": self.settings.elasticsearch_index,
                    "_id": chunk.chunk_id,
                    "_source": {
                        "chunk_id": chunk.chunk_id,
                        "doc_id": chunk.doc_id,
                        "domain": chunk.domain,
                        "title": chunk.title,
                        "source_url": chunk.source_url,
                        "s3_key": chunk.s3_key,
                        "content": chunk.content,
                        "content_en": chunk.content_en,
                        "token_count": chunk.token_count,
                        "chunk_index": chunk.chunk_index,
                        "embedding": vector,
                    },
                }
            )

        success, errors = bulk(client, actions, raise_on_error=False)
        if errors:
            print(f"⚠️ Elasticsearch bulk ingest had {len(errors)} errors")
        print(f"✅ Indexed {success} chunks into {self.settings.elasticsearch_index}")
        return int(success)
