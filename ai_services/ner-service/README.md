# NER Service

**Named Entity Recognition microservice** cho Healytics — trích xuất và chuẩn hóa entities từ câu truy vấn tiếng Việt để phục vụ bộ lọc (pre-filtering) trước khi đưa vào recommendation engine.

> **Note:** Service này chạy nội bộ, được gọi bởi **gateway-service** (qua `NERClient`) trong pipeline `POST /prefilter/search`. Endpoint `/ner/extract` trên gateway chỉ là proxy debug, tạm giữ. User cuối không gọi trực tiếp NER service.

## Tech Stack

| Công nghệ | Vai trò |
|---|---|
| **FastAPI** | Web framework (async, tự sinh OpenAPI docs) |
| **Gemini API (optional)** | LLM-based NER (primary mode when enabled) |
| **underthesea** | NLP tiếng Việt — local fallback khi LLM không khả dụng |
| **RapidFuzz** | Fuzzy string matching (Levenshtein) — map text thô → backend IDs |
| **sentence-transformers** | Semantic matching cho business type/category/feature tags |
| **cachetools** | LRU cache cho query dedup |
| **httpx** | HTTP client để load data từ backend API |
| **PostgreSQL + PostGIS** | Truy vấn candidate + lọc khoảng cách không gian |
| **SQLAlchemy (async) + asyncpg** | Data access layer bất đồng bộ |
| **Pydantic v2** | Schema validation + settings |

## Cấu trúc thư mục

```
ner-service/
├── requirements.txt          # Dependencies
├── pytest.ini                # Pytest async config
├── Dockerfile                # Production image (pre-download underthesea model)
├── .env.example              # Template env vars
├── seed_local.py             # Seed local DB (accounts/locations/categories/products/tags)
├── run_prefilter_cases.py    # Batch test runner cho extract + prefilter + postgis
│
├── app/
│   ├── main.py               # FastAPI app, lifespan (load cache lúc startup)
│   │
│   ├── core/
│   │   ├── config.py         # Settings (Gemini, semantic thresholds, cache, spatial)
│   │   └── database.py       # SQLAlchemy async engine/session
│   │
│   ├── schemas/
│   │   └── ner_schema.py     # NerRequest/NerResponse + PreFilter request/candidate schemas
│   │
│   ├── ner/                  # ★ NER Pipeline (core logic)
│   │   ├── cache.py          # RAM cache: 63 tỉnh hardcode + district/ward/category từ backend
│   │   ├── extractor.py      # Gemini-first NER + local fallback + price/rating regex + LRU
│   │   ├── gemini_ner.py     # Gemini client + JSON parsing/sanitization
│   │   ├── normalizer.py     # Entity Linking: cache lookup + RapidFuzz fuzzy match
│   │   ├── semantic_matcher.py
│   │   ├── distance_extractor.py
│   │   └── spatial_context.py
│   │
│   └── api/
│       ├── ner_routes.py     # POST /ner/extract + POST /internal/clear-cache
│       └── prefilter_routes.py # POST /prefilter/search (list-only response)
│
├── app/utils/
│   ├── query_builder.py
│   ├── db_fetcher.py
│   └── postgis_query_builder.py
│
└── tests/
  ├── test_extractor.py
  ├── test_normalizer.py
  ├── test_distance_extractor.py
  ├── test_spatial_context.py
  ├── test_query_builder.py
  ├── test_postgis_query_builder.py
  └── test_api.py
```

## Pipeline xử lý

```
User Query: "Tìm massage cổ vai gáy gần đây dưới 200k ở quận 10"
                │
                ▼
┌─────────────────────────────┐
│  1) Extractor               │
│  Gemini NER (nếu bật)       │
│  + Local fallback           │
│  + Regex Price/Rating       │
│  + Distance extractor       │
└─────────────┬───────────────┘
    │ raw entities
              ▼
┌─────────────────────────────┐
│  2) Normalizer              │
│  - map BUSINESS_TYPE        │
│  - map LOCATION code/level  │
│  - normalize PRICE/RATING   │
└─────────────┬───────────────┘
    │ normalized entities
              ▼
┌─────────────────────────────┐
│  3) Semantic Adjudication   │
│  - business type            │
│  - feature tags             │
│  - category                 │
└─────────────┬───────────────┘
    │ query params
              ▼
┌─────────────────────────────┐
│  4) Spatial Context         │
│  - current_lat/lng => PostGIS
│  - fallback address (optional)
└─────────────┬───────────────┘
    │
    ▼
┌─────────────────────────────┐
│  5) DB Fetcher              │
│  PostgreSQL + PostGIS       │
└─────────────┬───────────────┘
    │
    ▼
  List[ServiceCandidate]
```

## Cách chạy

```bash
# 1. Cài dependencies
cd ai_services/ner-service
pip install -r requirements.txt

# 2. Tạo .env từ template
cp .env.example .env

# 3. Chạy dev server
uvicorn app.main:app --port 8002 --reload

# 4. Seed data local (khuyến nghị)
python seed_local.py --clean

# 5. Test unit/integration
pytest tests/ -v

# 6. Chạy batch functional cases (extract + prefilter + postgis)
python run_prefilter_cases.py --timeout 180
```

## API Endpoints

### `POST /ner/extract`

Trích xuất + chuẩn hóa entities từ text.

**Request:**
```json
{
  "text": "Tìm spa ở Hà Nội giá dưới 500k"
}
```

**Response:**
```json
{
  "entities": [
    {
      "type": "BUSINESS_TYPE",
      "value": "spa",
      "confidence": 0.9,
      "business_type": "SPA_BEAUTY"
    },
    {
      "type": "LOCATION",
      "value": "Hà Nội",
      "confidence": 0.85,
      "location_code": "01",
      "location_level": "PROVINCE"
    },
    {
      "type": "PRICE",
      "value": "dưới 500k",
      "confidence": 1.0,
      "operator": "lte",
      "amount": 500000.0
    }
  ]
}
```

### `POST /internal/clear-cache`

Force refresh tất cả caches (gọi khi admin thêm category mới).

**Response:**
```json
{
  "status": "ok",
  "message": "All caches cleared and reloaded",
  "details": {
    "location_entries": 0,
    "category_entries": 0,
    "feature_tag_entries": 0
  }
}
```

### `POST /prefilter/search`

Prefilter end-to-end: extract + normalize + semantic + spatial + DB fetch.

**Request (ví dụ có tọa độ):**
```json
{
  "text": "Tìm massage cổ vai gáy gần đây dưới 200k ở quận 10",
  "limit": 20,
  "current_lat": 10.7735,
  "current_lng": 106.6672
}
```

**Response:**
```json
[
  {
    "service_id": "...",
    "name": "Massage cổ vai gáy 45 phút",
    "price": {"amount": 169000, "currency": "VND"},
    "rating": {"average": 4.5, "total_reviews": 0},
    "distance_meters": 1200.0
  }
]
```

> Lưu ý: Endpoint này hiện trả về **list-only** (không bọc `text`, `entities`, `query_params`, `total`).

## Entity Types

| Type | Giải thích | Nguồn backend | Trường normalized |
|---|---|---|---|
| `BUSINESS_TYPE` | Loại hình doanh nghiệp | 11 enum values trong `business-type.enum.ts` | `business_type` (VD: `"SPA_BEAUTY"`) |
| `LOCATION` | Địa điểm (tỉnh/quận/phường) | `location` table (PROVINCE/DISTRICT/WARD) | `location_code`, `location_level` |
| `PRICE` | Điều kiện giá | `products.basePrice` | `operator` (`lte`/`gte`/`between`), `amount`, `amount_max` |
| `RATING` | Điều kiện đánh giá | `product_reviews` | `operator` (`gte`/`lte`), `amount` |
| `CATEGORY` | Danh mục dịch vụ | `categories` table (dynamic) | `category_slug` |

## Caching Strategy

| Cache | Dữ liệu | TTL | Nguồn |
|---|---|---|---|
| **PROVINCE_MAP** | 63 tỉnh + aliases (~80 entries) | ∞ (hardcode) | Code |
| **District/Ward** | ~10,000 quận/phường | 24h | Backend API |
| **Category** | Dynamic categories | 5 phút | Backend API |
| **Query LRU** | 512 câu query gần nhất | Eviction khi đầy | In-memory |

## Env Variables

| Variable | Default | Mô tả |
|---|---|---|
| `BACKEND_API_URL` | `http://localhost:3000/api` | URL backend để load cache |
| `LOCATION_CACHE_TTL` | `3600` | TTL cache district/ward |
| `CATEGORY_CACHE_TTL` | `3600` | TTL cache categories |
| `QUERY_CACHE_MAXSIZE` | `1000` | Max entries LRU query cache |
| `LLM_NER_ENABLED` | `true` | Bật Gemini làm primary NER extractor |
| `GEMINI_API_KEY` | `""` | API key Gemini |
| `GEMINI_MODEL` | `gemini-2.5-flash` | Model Gemini để extract NER |
| `GEMINI_API_BASE_URL` | `https://generativelanguage.googleapis.com/v1beta` | Base URL Gemini API |
| `GEMINI_TIMEOUT_MS` | `1500` | Timeout gọi Gemini (ms) |
| `SEMANTIC_BT_HIGH_THRESHOLD` | `0.60` | Ngưỡng hard cho business type semantic |
| `SEMANTIC_CATEGORY_HIGH_THRESHOLD` | `0.60` | Ngưỡng hard cho category semantic |
| `SEMANTIC_TAG_HIGH_THRESHOLD` | `0.80` | Ngưỡng hard cho feature tag semantic |
| `PORT` | `8002` | Port chạy service |

## Thiết kế chống lỗi

- **Backend chưa chạy?** → Cache rỗng, chỉ dùng PROVINCE_MAP hardcode. Service vẫn hoạt động.
- **underthesea miss entity?** → Keyword scan chạy song song bắt bổ sung.
- **Entity không map được?** → Trả `normalized_id=None` + giảm confidence. Không crash.
- **Cache hết hạn nhưng backend lỗi?** → Giữ cache cũ (stale-while-revalidate).
