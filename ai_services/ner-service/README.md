# NER Service

**Named Entity Recognition microservice** cho Healytics — trích xuất và chuẩn hóa entities từ câu truy vấn tiếng Việt để phục vụ bộ lọc (pre-filtering) trước khi đưa vào recommendation engine.

> **Note:** Service này chạy nội bộ, được gọi bởi **gateway-service** (qua `NERClient`) trong pipeline `POST /prefilter/search`. Endpoint `/ner/extract` trên gateway chỉ là proxy debug, tạm giữ. User cuối không gọi trực tiếp NER service.

## Tech Stack

| Công nghệ | Vai trò |
|---|---|
| **FastAPI** | Web framework (async, tự sinh OpenAPI docs) |
| **underthesea** | NLP tiếng Việt — chạy local, không cần API key, latency ~10-50ms |
| **RapidFuzz** | Fuzzy string matching (Levenshtein) — map text thô → backend IDs |
| **cachetools** | LRU cache cho query dedup |
| **httpx** | HTTP client để load data từ backend API |
| **Pydantic v2** | Schema validation + settings |

## Cấu trúc thư mục

```
ner-service/
├── requirements.txt          # Dependencies
├── pytest.ini                # Pytest async config
├── Dockerfile                # Production image (pre-download underthesea model)
├── .env.example              # Template env vars
│
├── app/
│   ├── main.py               # FastAPI app, lifespan (load cache lúc startup)
│   │
│   ├── core/
│   │   └── config.py         # Settings (BACKEND_API_URL, cache TTLs, port)
│   │
│   ├── schemas/
│   │   └── ner_schema.py     # NerRequest, NerEntity, NerResponse
│   │
│   ├── ner/                  # ★ NER Pipeline (core logic)
│   │   ├── cache.py          # RAM cache: 63 tỉnh hardcode + district/ward/category từ backend
│   │   ├── extractor.py      # underthesea + keyword scan + price/rating regex + LRU
│   │   └── normalizer.py     # Entity Linking: cache lookup + RapidFuzz fuzzy match
│   │
│   └── api/
│       └── ner_routes.py     # POST /ner/extract + POST /internal/clear-cache
│
└── tests/
    ├── test_extractor.py     # Unit test regex, keyword scan, tag merging
    ├── test_normalizer.py    # Unit test entity linking, fuzzy match, graceful degradation
    └── test_api.py           # Integration test endpoints
```

## Pipeline xử lý

```
User Query: "Tìm spa ở Quận 1 giá dưới 500k trên 4 sao"
                │
                ▼
┌─────────────────────────────┐
│  LRU Query Cache            │ ← cache hit? return ngay (<1ms)
└─────────────┬───────────────┘
              │ cache miss
              ▼
┌─────────────────────────────┐
│  1a. underthesea.ner(text)  │ → LOC("Quận 1"), ORG("spa")
│  1b. Keyword Scan (song song)│ → BUSINESS_TYPE("spa" → SPA_BEAUTY)
│  2.  Regex Price/Rating     │ → PRICE("dưới 500k"), RATING("trên 4 sao")
└─────────────┬───────────────┘
              │ raw entities
              ▼
┌─────────────────────────────┐
│  3. Normalizer              │
│  ├─ LOC → cache.find_location() → location_code="760"
│  ├─ ORG → BUSINESS_TYPE_ALIASES exact match
│  │       → RapidFuzz fuzzy match (≥75%)
│  │       → Category cache fuzzy match
│  ├─ PRICE → operator="lte", amount=500000
│  └─ RATING → operator="gte", amount=4.0
└─────────────┬───────────────┘
              │ normalized entities
              ▼
         NerResponse JSON
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

# 4. Test
pytest tests/ -v
```

## API Endpoints

### `POST /ner/extract`

Trích xuất + chuẩn hóa entities từ text.

**Request:**
```json
{
  "conversation_id": "123e4567-e89b-12d3-a456-426614174000",
  "text": "Tìm spa ở Hà Nội giá dưới 500k"
}
```

**Response:**
```json
{
  "conversation_id": "123e4567-e89b-12d3-a456-426614174000",
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
  "details": { "district_ward_entries": 0, "category_entries": 0 }
}
```

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
| `BACKEND_API_URL` | `http://localhost:3000` | URL backend để load cache |
| `LOCATION_CACHE_TTL` | `86400` (24h) | TTL cache district/ward |
| `CATEGORY_CACHE_TTL` | `300` (5 phút) | TTL cache categories |
| `QUERY_CACHE_MAXSIZE` | `512` | Max entries LRU query cache |
| `PORT` | `8002` | Port chạy service |

## Thiết kế chống lỗi

- **Backend chưa chạy?** → Cache rỗng, chỉ dùng PROVINCE_MAP hardcode. Service vẫn hoạt động.
- **underthesea miss entity?** → Keyword scan chạy song song bắt bổ sung.
- **Entity không map được?** → Trả `normalized_id=None` + giảm confidence. Không crash.
- **Cache hết hạn nhưng backend lỗi?** → Giữ cache cũ (stale-while-revalidate).
