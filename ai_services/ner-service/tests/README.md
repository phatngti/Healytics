# NER Service — Test Documentation

Tài liệu giải thích chi tiết từng test case và kết quả chạy.

**Kết quả cuối cùng: ✅ 38/38 passed (66.94s)**

---

## `tests/test_extractor.py` — 22 tests

Kiểm tra toàn bộ pipeline trích xuất thô: regex price/rating, keyword scan, tag merging, dedup, và LRU cache.

### TestParsePrice (6 tests)

Kiểm tra hàm `_parse_price()` — hàm tách riêng để dễ thêm slang sau này.

| Test | Input | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_price_under_500k` | `"giá dưới 500k"` | `operator="lte"`, `amount=500000` | Regex bắt "dưới" + đơn vị "k" |
| `test_price_above_300k` | `"trên 300k"` | `operator="gte"`, `amount=300000` | Regex bắt "trên" |
| `test_price_range_200k_to_1_trieu` | `"từ 200k đến 1 triệu"` | `operator="between"`, `amount=200000`, `amount_max=1000000` | Range pattern "từ X đến Y" |
| `test_price_trieu_unit` | `"dưới 2 triệu"` | `amount=2000000` | Đơn vị "triệu" nhân 1,000,000 |
| `test_price_tr_abbreviation` | `"từ 1tr đến 3tr"` | `amount=1000000`, `amount_max=3000000` | Viết tắt "tr" = triệu |
| `test_no_price_in_text` | `"tìm spa ở Hà Nội"` | `[]` (rỗng) | Không match false positive |

### TestParseRating (3 tests)

Kiểm tra hàm `_parse_rating()`.

| Test | Input | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_rating_above_4` | `"trên 4 sao"` | `operator="gte"`, `amount=4.0` | Regex bắt "trên X sao" |
| `test_rating_at_least_4_5` | `"ít nhất 4.5 điểm"` | `operator="gte"`, `amount=4.5` | Regex bắt "ít nhất" + "điểm" |
| `test_no_rating_in_text` | `"tìm spa giá rẻ"` | `[]` (rỗng) | Không match false positive |

### TestKeywordScan (6 tests)

Kiểm tra hàm `_keyword_scan()` — chạy song song với underthesea để bắt domain wellness terms.

| Test | Input | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_keyword_scan_spa` | `"tìm spa gần đây"` | `business_type="SPA_BEAUTY"` | Bắt keyword "spa" |
| `test_keyword_scan_gym` | `"gym ở quận 1"` | `business_type="FITNESS"` | Bắt keyword "gym" |
| `test_keyword_scan_massage_tri_lieu` | `"massage trị liệu ở đà nẵng"` | `MASSAGE_REHABILITATION` (1 entity) | **Ưu tiên cụm dài** — "massage trị liệu" thắng "massage" |
| `test_keyword_scan_nha_khoa` | `"nha khoa gần nhà"` | `business_type="DENTAL"` | Bắt keyword 2 từ |
| `test_keyword_scan_domain_specific` | `"tìm chỗ nắn xương khớp"` | `MASSAGE_REHABILITATION` | **Corner case**: term mà underthesea thường miss |
| `test_keyword_scan_empty` | `"tôi muốn đặt lịch"` | `[]` (rỗng) | Không có false positive |

### TestMergeNerTags (3 tests)

Kiểm tra hàm `_merge_ner_tags()` — gộp B-/I- tags từ underthesea thành spans.

| Test | Input (simulated underthesea output) | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_merge_b_i_loc` | `[("Hà","B-LOC"), ("Nội","I-LOC")]` | 1 entity: `LOC "Hà Nội"` | Gộp B-LOC + I-LOC thành 1 span |
| `test_merge_multiple_entities` | `[..spa(B-ORG).. Hồ(B-LOC) Chí(I-LOC) Minh(I-LOC)]` | 2 entities: ORG + LOC | Nhiều entity types khác nhau |
| `test_merge_only_o_tags` | `[("tìm","O"), ("cái","O"), ("gì","O")]` | `[]` (rỗng) | Không tạo entity từ O tags |

### TestDeduplicate (2 tests)

Kiểm tra hàm `_deduplicate()` — giữ entity confidence cao nhất khi trùng.

| Test | Scenario | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_dedup_same_type_same_value` | 2x LOC "Hà Nội" (0.85 và 0.90) | Giữ 1 entity, confidence=0.90 | Giữ confidence cao nhất |
| `test_dedup_different_type` | LOC "spa" + BUSINESS_TYPE "spa" | Giữ cả 2 | Khác type → không dedup |

### TestQueryCache (1 test)

| Test | Kiểm tra gì |
|---|---|
| `test_cache_hit` | Gọi `extract_entities()` 2 lần cùng text → kết quả giống nhau (LRU cache hit) |

---

## `tests/test_normalizer.py` — 11 tests

Kiểm tra Entity Linking — map raw text → backend IDs/enums.

### TestNormalizeLocation (4 tests)

| Test | Input | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_province_hanoi` | LOC "Hà Nội" | `location_code="01"`, `level="PROVINCE"` | PROVINCE_MAP lookup O(1) |
| `test_province_hcm_alias` | LOC "HCM" | `location_code="79"` | Alias "HCM" → Hồ Chí Minh |
| `test_province_saigon_alias` | LOC "Sài Gòn" | `location_code="79"` | Alias "Sài Gòn" → HCM |
| `test_unknown_location_returns_none` | LOC "Hành Tinh Mars" | `location_code=None`, confidence giảm | **Hallucination-safe** — không crash |

### TestNormalizeBusinessType (1 test)

| Test | Input | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_business_type_from_keyword_scan` | BUSINESS_TYPE "spa" (đã có `business_type="SPA_BEAUTY"`) | `business_type="SPA_BEAUTY"` | Pass-through từ keyword scan |

### TestNormalizeOrgMisc (3 tests)

| Test | Input | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_org_exact_match_business_type` | ORG "spa" | `type="BUSINESS_TYPE"`, `business_type="SPA_BEAUTY"` | Exact match trong ALIASES dict |
| `test_org_fuzzy_match_business_type` | ORG "spaa" (typo) | `business_type="SPA_BEAUTY"` | **RapidFuzz fuzzy match** ≥75% |
| `test_org_unknown_returns_none` | ORG "xyzabc123" | `business_type=None`, `category_slug=None` | Entity lạ → None, không crash |

### TestNormalizePrice (2 tests)

| Test | Input | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_price_passthrough` | PRICE `operator="lte"`, `amount=500000` | Pass-through y nguyên | Extractor đã parse sẵn |
| `test_price_range_passthrough` | PRICE `operator="between"`, `amount/amount_max` | Pass-through y nguyên | Range pass-through |

### TestNormalizeRating (1 test)

| Test | Input | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_rating_passthrough` | RATING `operator="gte"`, `amount=4.0` | Pass-through y nguyên | Extractor đã parse sẵn |

### TestSkipUnknown (1 test)

| Test | Input | Expected | Kiểm tra gì |
|---|---|---|---|
| `test_per_type_skipped` | PER "Nguyễn Văn A" | `[]` (rỗng) | Tên người bị skip, không normalize |

---

## `tests/test_api.py` — 5 tests

Integration tests — gọi HTTP endpoints thật qua `httpx.AsyncClient`.

### TestNerExtractEndpoint (4 tests)

| Test | Kiểm tra gì |
|---|---|
| `test_extract_returns_200` | `POST /ner/extract` trả 200 OK |
| `test_extract_response_schema` | Response có `conversation_id` + `entities` (list) |
| `test_extract_finds_entities` | Với input "spa ở Hà Nội giá dưới 500k trên 4 sao" → tìm được ≥1 entity |
| `test_extract_empty_text_returns_422` | Text rỗng `""` → 422 Validation Error (Pydantic `min_length=1`) |

### TestClearCacheEndpoint (1 test)

| Test | Kiểm tra gì |
|---|---|
| `test_clear_cache_returns_200` | `POST /internal/clear-cache` trả 200 + `{"status": "ok"}` (graceful khi backend unavailable) |

---

## Chạy tests

```bash
cd ai_services/ner-service

# Chạy tất cả
pytest tests/ -v

# Chỉ chạy 1 file
pytest tests/test_extractor.py -v

# Chỉ chạy 1 class
pytest tests/test_normalizer.py::TestNormalizeLocation -v

# Chỉ chạy 1 test
pytest tests/test_extractor.py::TestParsePrice::test_price_under_500k -v
```
