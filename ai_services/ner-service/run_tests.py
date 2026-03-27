"""
Quick functional test suite for NER service.
Run with: python run_tests.py
Server must be running on http://127.0.0.1:8002
"""

import json
import sys
import urllib.request
import urllib.error

BASE = "http://127.0.0.1:8002"
PASS = 0
FAIL = 0


def post(path, body):
    data = json.dumps(body).encode()
    req = urllib.request.Request(
        f"{BASE}{path}",
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            return json.loads(resp.read())
    except urllib.error.HTTPError as e:
        return {"error": e.code, "body": e.read().decode()}
    except Exception as e:
        return {"error": str(e)}


def parse(result):
    """Extract common fields from NER result."""
    ents  = result.get("entities", [])
    types = [e["type"] for e in ents]
    bts   = [e.get("business_type") for e in ents]
    locs  = [(e.get("location_code"), e.get("location_level")) for e in ents if e["type"] == "LOCATION"]
    radii = [e.get("radius_meters") for e in ents if e["type"] == "DISTANCE"]
    ops   = [(e.get("operator"), e.get("amount")) for e in ents if e["type"] in ("PRICE", "RATING")]
    return ents, types, bts, locs, radii, ops


def check(label, assertions):
    global PASS, FAIL
    failures = [desc for desc, cond in assertions if not cond]
    status = "PASS" if not failures else "FAIL"
    if status == "PASS":
        PASS += 1
    else:
        FAIL += 1
    print(f"  [{status}] {label}")
    for f in failures:
        print(f"         ✗ {f}")


def fmt(ents):
    lines = []
    for e in ents:
        parts = [f"  [{e['type']}] \"{e['value']}\" conf={e['confidence']:.2f}"]
        if e.get("business_type"):
            parts.append(f"    → business_type: {e['business_type']}")
        if e.get("location_code"):
            parts.append(f"    → location_code: {e['location_code']} ({e.get('location_level', '')})")
        if e.get("operator"):
            parts.append(f"    → {e['type'].lower()}: {e['operator']} {e.get('amount')} ~ {e.get('amount_max')}")
        if e.get("radius_meters") is not None:
            parts.append(f"    → radius_meters: {e['radius_meters']} | unit={e.get('distance_unit')} | implicit={e.get('proximity_intent')}")
        lines.append("\n".join(parts))
    return "\n".join(lines) if lines else "  (no entities)"


SEP = "=" * 65
print(SEP)
print("NER SERVICE v2 — FUNCTIONAL TESTS")
print(SEP)

# ── Setup ─────────────────────────────────────────────────────────────────────
print("\n--- Setup ---")
r = post("/internal/clear-cache", {})
locations = r.get("details", {}).get("location_entries", "?") if "details" in r else "?"
print(f"  Cache cleared: {r.get('status', 'error')} | locations={locations}")

# ── Tests ─────────────────────────────────────────────────────────────────────
print("\n--- /ner/extract ---")

r = post("/ner/extract", {"text": "Mình cần tìm phòng khám nha sĩ ở HCM, chi phí khoảng 400k"})
ents, types, bts, locs, radii, ops = parse(r)
check("nha sĩ + location HCM + price khoảng 400k", [
    ("DENTAL extracted",         "DENTAL" in bts),
    ("LOCATION code=79",         ("79", "PROVINCE") in locs),
    ("PRICE between ~340k",      any(op == "between" and 330000 < amt < 350000 for op, amt in ops)),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Tìm spa trong vòng 5km"})
ents, types, bts, locs, radii, ops = parse(r)
check("explicit distance 5km", [
    ("SPA_BEAUTY extracted",     "SPA_BEAUTY" in bts),
    ("radius_meters=5000",       5000 in radii),
    ("proximity_intent=False",   any(e.get("proximity_intent") is False for e in ents if e["type"] == "DISTANCE")),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Tìm gym gần đây"})
ents, types, bts, locs, radii, ops = parse(r)
check("implicit proximity gần đây → 5km default", [
    ("FITNESS extracted",        "FITNESS" in bts),
    ("radius_meters=5000",       5000 in radii),
    ("proximity_intent=True",    any(e.get("proximity_intent") is True for e in ents if e["type"] == "DISTANCE")),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Tìm spa trên 3km"})
ents, types, bts, locs, radii, ops = parse(r)
check("trên 3km → DISTANCE (not RATING false positive)", [
    ("DISTANCE extracted",       "DISTANCE" in types),
    ("no RATING extracted",      "RATING" not in types),
    ("radius_meters=3000",       3000 in radii),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Tìm spa đánh giá trên 4 sao"})
ents, types, bts, locs, radii, ops = parse(r)
check("trên 4 sao → RATING gte 4.0", [
    ("RATING extracted",         "RATING" in types),
    ("operator=gte, amt=4.0",    any(op == "gte" and amt == 4.0 for op, amt in ops)),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Tìm massage dưới 1 triệu"})
ents, types, bts, locs, radii, ops = parse(r)
check("price dưới 1 triệu → lte 1,000,000", [
    ("MASSAGE_THERAPY extracted",  "MASSAGE_THERAPY" in bts),
    ("operator=lte, amt=1000000",  any(op == "lte" and amt == 1_000_000 for op, amt in ops)),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Tìm spa giá 500k"})
ents, types, bts, locs, radii, ops = parse(r)
check("no-modifier price giá 500k → between ±15%", [
    ("PRICE extracted",          "PRICE" in types),
    ("operator=between",         any(op == "between" for op, _ in ops)),
    ("amount~425k",              any(op == "between" and 420000 < amt < 430000 for op, amt in ops)),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Dịch vụ nha khoa khoảng 1.5 triệu"})
ents, types, bts, locs, radii, ops = parse(r)
check("decimal price 1.5 triệu → ~1,275,000", [
    ("DENTAL extracted",         "DENTAL" in bts),
    ("amount~1275000",           any(op == "between" and 1_270_000 < amt < 1_280_000 for op, amt in ops)),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Tìm bệnh viện cách 2 cây số"})
ents, types, bts, locs, radii, ops = parse(r)
check("2 cây số = 2000m", [
    ("radius_meters=2000",       2000 in radii),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Tìm spa ở Quận 1 TPHCM"})
ents, types, bts, locs, radii, ops = parse(r)
check("Quận 1 (760/DISTRICT) + TPHCM (79/PROVINCE)", [
    ("SPA_BEAUTY extracted",     "SPA_BEAUTY" in bts),
    ("Quận 1 code=760",          ("760", "DISTRICT") in locs),
    ("TPHCM code=79",            ("79", "PROVINCE") in locs),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Hiệu thuốc gần đây bán thuốc cảm"})
ents, types, bts, locs, radii, ops = parse(r)
check("hiệu thuốc → PHARMACY, no false LOC for 'hiệu'", [
    ("PHARMACY extracted",       "PHARMACY" in bts),
    ("no spurious LOC",          len([e for e in ents if e["type"] == "LOCATION"]) == 0),
])
print(fmt(ents))

r = post("/ner/extract", {"text": "Tìm tiệm làm đẹp phù hợp"})
ents, types, bts, locs, radii, ops = parse(r)
check("làm đẹp → SPA_BEAUTY, no false LOC for 'làm'", [
    ("SPA_BEAUTY extracted",     "SPA_BEAUTY" in bts),
    ("no spurious LOC",          len([e for e in ents if e["type"] == "LOCATION"]) == 0),
])
print(fmt(ents))

# ── Summary ───────────────────────────────────────────────────────────────────
total = PASS + FAIL
print(f"\n{SEP}")
print(f"RESULT: {PASS}/{total} passed" + (" ✓" if FAIL == 0 else f" — {FAIL} FAILED"))
print(SEP)
sys.exit(0 if FAIL == 0 else 1)
