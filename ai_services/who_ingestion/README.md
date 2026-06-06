# WHO Ingestion Pipeline

> **Chưa có AWS?** Đọc trước: [HUONG_DAN_SETUP_AWS.md](./HUONG_DAN_SETUP_AWS.md) — hướng dẫn từng bước tạo S3 + OpenSearch.

Tự động hóa quy trình:

1. Crawl ~200 tài liệu WHO (50/domain × 4 domain)
2. Tải PDF → upload S3
3. Extract text → chunk theo token
4. Embed + ingest Elasticsearch
5. Advanced RAG (`RAG_MODE=advanced`) đọc trực tiếp từ Elasticsearch

## Domains

| Key | Chủ đề | Keywords |
|-----|--------|----------|
| `nutrition` | Dinh dưỡng | nutrition, healthy diet, malnutrition, obesity, ... |
| `physical_activity` | Tập luyện | physical activity, exercise, fitness, ... |
| `mental_health` | Trị liệu tâm lý | mental health, depression, anxiety, stress, ... |
| `wellness` | Spa & Làm đẹp | healthy ageing, self-care, well-being, rehabilitation, ... |

## Thông tin bạn cần cung cấp

### AWS S3

| Biến | Mô tả |
|------|-------|
| `S3_BUCKET` | Tên bucket (ví dụ `healytics-who-docs`) |
| `S3_PREFIX` | Prefix object (mặc định `who-publications/`) |
| `AWS_REGION` | Region (ví dụ `ap-southeast-1`) |
| `AWS_ACCESS_KEY_ID` | IAM access key có quyền `s3:PutObject`, `s3:GetObject`, `s3:HeadObject` |
| `AWS_SECRET_ACCESS_KEY` | IAM secret key |
| `S3_ENDPOINT_URL` | *(tuỳ chọn)* nếu dùng MinIO/LocalStack |

### Elasticsearch

| Biến | Mô tả |
|------|-------|
| `ELASTICSEARCH_URL` | URL cluster (AWS OpenSearch hoặc Elastic Cloud) |
| `ELASTICSEARCH_INDEX` | Tên index (mặc định `healytics_who_chunks`) |
| `ELASTICSEARCH_API_KEY` | API key *(hoặc username/password)* |
| `ELASTICSEARCH_USERNAME` / `ELASTICSEARCH_PASSWORD` | Basic auth nếu không dùng API key |
| `ELASTICSEARCH_VERIFY_CERTS` | `true`/`false` |

**Yêu cầu cluster:** hỗ trợ `dense_vector` (kNN) + full-text search (BM25).

### RAG (rag_langchain/.env)

Sau khi ingest xong, bật advanced RAG:

```env
RAG_MODE=advanced
ELASTICSEARCH_URL=...
ELASTICSEARCH_INDEX=healytics_who_chunks
ELASTICSEARCH_API_KEY=...
RAG_QUERY_TRANSLATION_ENABLED=true
MISTRAL_API_KEY=...
```

## Cài đặt

```bash
cd ai_services/who_ingestion
cp .env.example .env
pip install -r requirements.txt
```

## Chạy pipeline

```bash
# Crawl + ingest tất cả 4 domain (mục tiêu 200 PDF)
python -m who_ingestion.pipeline --all

# Một domain
python -m who_ingestion.pipeline --domain nutrition --limit 50

# Dùng manifest đã crawl (không crawl lại)
python -m who_ingestion.pipeline --from-manifest ./data/staging/who/manifest.json
```

## Lưu ý crawl WHO

- Trang WHO có thể thay đổi HTML; nếu crawl thiếu kết quả, cần kiểm tra log và cân nhắc bổ sung Playwright.
- Tuân thủ `WHO_CRAWL_DELAY_SECONDS` để tránh rate limit.
- PDF không tải được sẽ được skip và ghi log.
