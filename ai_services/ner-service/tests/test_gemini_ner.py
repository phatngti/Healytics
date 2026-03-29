from app.ner.gemini_ner import _extract_outermost_json_block, _sanitize_entities


def test_extract_outermost_json_object_with_padding():
    text = 'Here is the result:\n{"type":"LOC","value":"Ha Noi"}\nHope this helps :]'
    assert _extract_outermost_json_block(text) == '{"type":"LOC","value":"Ha Noi"}'


def test_extract_outermost_json_array_with_padding():
    text = 'Answer:\n[{"type":"PRICE","amount":100000}]\nDone :)'
    assert _extract_outermost_json_block(text) == '[{"type":"PRICE","amount":100000}]'


def test_extract_outermost_json_prefers_earliest_parseable_block():
    text = '{"meta":"x"}\n[{"type":"RATING","amount":4.5}]\n'
    assert _extract_outermost_json_block(text) == '[{"type":"RATING","amount":4.5}]'


def test_extract_outermost_json_returns_original_if_no_json_bounds():
    text = 'No structured payload available.'
    assert _extract_outermost_json_block(text) == text


def test_sanitize_entities_explodes_business_type_array():
    raw = {
        "type": "BUSINESS_TYPE",
        "value": "spa va gym",
        "confidence": 0.9,
        "business_type": ["SPA_BEAUTY", "FITNESS"],
        "business_evidence": "spa va gym",
    }
    cleaned = _sanitize_entities(raw, "tim spa va gym")

    assert len(cleaned) == 2
    assert {item["business_type"] for item in cleaned} == {"SPA_BEAUTY", "FITNESS"}
    assert all(item["type"] == "BUSINESS_TYPE" for item in cleaned)


def test_sanitize_entities_filters_invalid_business_type_items():
    raw = {
        "type": "BUSINESS_TYPE",
        "value": "spa va xyz",
        "confidence": 0.8,
        "business_type": ["SPA_BEAUTY", "UNKNOWN", "SPA_BEAUTY"],
    }
    cleaned = _sanitize_entities(raw, "tim spa va xyz")

    assert len(cleaned) == 1
    assert cleaned[0]["business_type"] == "SPA_BEAUTY"


def test_sanitize_entities_keeps_single_business_type_string():
    raw = {
        "type": "BUSINESS_TYPE",
        "value": "nha khoa",
        "confidence": 0.85,
        "business_type": "DENTAL",
    }
    cleaned = _sanitize_entities(raw, "tim nha khoa")

    assert len(cleaned) == 1
    assert cleaned[0]["business_type"] == "DENTAL"


def test_sanitize_entities_keeps_distance_range_fields():
    raw = {
        "type": "DISTANCE",
        "value": "từ 2km đến 5km",
        "confidence": 0.95,
        "operator": "between",
        "amount": 2000,
        "amount_max": 5000,
        "radius_meters": 5000,
        "distance_unit": "km",
        "proximity_intent": False,
    }

    cleaned = _sanitize_entities(raw, "tim spa tu 2km den 5km")
    assert len(cleaned) == 1
    item = cleaned[0]
    assert item["type"] == "DISTANCE"
    assert item["operator"] == "between"
    assert item["amount"] == 2000.0
    assert item["amount_max"] == 5000.0
    assert item["radius_meters"] == 5000
