"""
Simple NER Evaluation Script
- CSV-based gold dataset
- Incremental (saves progress, resume if interrupted)
- Caching (skip already-tested queries)
- Batch processing with delays (avoid rate limits)
- Error categorization: location_alias, price_parser, semantic_miss

Usage:
  python evaluate_simple.py                    # Run all
  python evaluate_simple.py --limit 20         # Test 20 queries only
  python evaluate_simple.py --resume           # Resume from last checkpoint
  python evaluate_simple.py --report-only      # Just show report from saved results
"""

import csv
import json
import time
import argparse
import urllib.request
import urllib.error
import re
from pathlib import Path
from collections import defaultdict

# ── Config ────────────────────────────────────────────────────────────────────
BASE_URL = "http://127.0.0.1:8002"
GOLD_FILE = Path(__file__).parent / "gold_simple.csv"
RESULTS_FILE = Path(__file__).parent / "eval_results.json"
BATCH_SIZE = 10  # Save checkpoint every N queries
DELAY_BETWEEN_REQUESTS = 0.5  # seconds (increase if rate limited)

# ── Location alias patterns (for error categorization) ────────────────────────
LOCATION_ALIAS_PATTERNS = [
    r'\bq\s*\.?\s*\d+',           # Q1, Q.1, Q 1
    r'\bquận\s+\w+',              # quận một, quận hai
    r'\btphcm\b', r'\bhcm\b',     # TPHCM, HCM
    r'\bsg\b', r'\bhn\b',         # Saigon, Hanoi abbrev
    r'\btp\s*\.?\s*hcm',          # TP.HCM, TP HCM
]

# ── Price patterns (for error categorization) ─────────────────────────────────
PRICE_PATTERNS = [
    r'\d+\s*k\b',                  # 500k
    r'\d+\s*tr\b',                 # 2tr
    r'\d+\s*triệu',                # 2 triệu
    r'\d+\s*nghìn',                # 500 nghìn
    r'dưới\s+\d+',                 # dưới 500k
    r'trên\s+\d+',                 # trên 500k
    r'khoảng\s+\d+',               # khoảng 500k
    r'từ\s+\d+.*đến',              # từ 100k đến 300k
]


def load_gold():
    """Load gold dataset from CSV."""
    queries = []
    with open(GOLD_FILE, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            queries.append({
                "text": row["text"],
                "expected": {
                    "business_type": row["business_type"] or None,
                    "location_code": row["location_code"] or None,
                    "price_op": row["price_op"] or None,
                    "price_amount": int(row["price_amount"]) if row["price_amount"] else None,
                    "price_max": int(row["price_max"]) if row["price_max"] else None,
                    "distance_meters": int(row["distance_meters"]) if row["distance_meters"] else None,
                    "distance_implicit": row["distance_implicit"].lower() == "true" if row["distance_implicit"] else None,
                }
            })
    return queries


def load_results():
    """Load existing results (for resume)."""
    if RESULTS_FILE.exists():
        # Accept files saved with or without UTF-8 BOM.
        return json.loads(RESULTS_FILE.read_text(encoding="utf-8-sig"))
    return {"tested": {}, "errors": []}


def save_results(results):
    """Save results to file."""
    RESULTS_FILE.write_text(json.dumps(results, ensure_ascii=False, indent=2), encoding="utf-8")


def call_ner(text: str) -> dict:
    """Call NER service."""
    data = json.dumps({"text": text}).encode()
    req = urllib.request.Request(
        f"{BASE_URL}/ner/extract",
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.loads(resp.read())
    except Exception as e:
        return {"error": str(e), "entities": []}


def extract_normalized(response: dict) -> dict:
    """Extract normalized values from NER response."""
    result = {
        "business_type": None,
        "location_code": None,
        "price_op": None,
        "price_amount": None,
        "price_max": None,
        "distance_meters": None,
        "distance_implicit": None,
        # NEW: Store confidence scores for threshold analysis
        "confidence_scores": {
            "business_type": None,
            "location": None,
            "price": None,
            "distance": None,
        },
        # NEW: Store raw entities for debugging
        "raw_entities": response.get("entities", []),
    }
    
    for ent in response.get("entities", []):
        etype = ent.get("type")
        confidence = ent.get("confidence", 0)
        
        if etype == "BUSINESS_TYPE" and not result["business_type"]:
            result["business_type"] = ent.get("business_type")
            result["confidence_scores"]["business_type"] = confidence
            
        elif etype == "LOCATION" and not result["location_code"]:
            result["location_code"] = ent.get("location_code")
            result["confidence_scores"]["location"] = confidence
            
        elif etype == "PRICE" and not result["price_op"]:
            result["price_op"] = ent.get("operator")
            result["price_amount"] = int(ent.get("amount")) if ent.get("amount") else None
            result["price_max"] = int(ent.get("amount_max")) if ent.get("amount_max") else None
            result["confidence_scores"]["price"] = confidence
            
        elif etype == "DISTANCE" and result["distance_meters"] is None:
            result["distance_meters"] = ent.get("radius_meters")
            result["distance_implicit"] = ent.get("proximity_intent")
            result["confidence_scores"]["distance"] = confidence
    
    return result


def compare(expected: dict, predicted: dict) -> dict:
    """Compare expected vs predicted, return match details."""
    matches = {}
    
    # Business type: exact match
    matches["business_type"] = expected["business_type"] == predicted["business_type"]
    
    # Location: exact match
    matches["location_code"] = expected["location_code"] == predicted["location_code"]
    
    # Price: operator must match, amount within 10% tolerance
    if expected["price_op"] is None and predicted["price_op"] is None:
        matches["price"] = True
    elif expected["price_op"] != predicted["price_op"]:
        matches["price"] = False
    elif expected["price_amount"] is None:
        matches["price"] = predicted["price_amount"] is None
    else:
        tolerance = expected["price_amount"] * 0.1
        matches["price"] = abs((predicted["price_amount"] or 0) - expected["price_amount"]) <= tolerance
    
    # Distance: meters within 20% tolerance
    if expected["distance_meters"] is None and predicted["distance_meters"] is None:
        matches["distance"] = True
    elif expected["distance_meters"] is None or predicted["distance_meters"] is None:
        matches["distance"] = False
    else:
        tolerance = expected["distance_meters"] * 0.2
        matches["distance"] = abs(predicted["distance_meters"] - expected["distance_meters"]) <= tolerance
    
    return matches


def run_evaluation(queries: list, results: dict, limit: int = None):
    """Run evaluation on queries."""
    tested = results["tested"]
    
    # Filter out already tested
    to_test = [(i, q) for i, q in enumerate(queries) if q["text"] not in tested]
    
    if limit:
        to_test = to_test[:limit]
    
    print(f"\n[i] Queries to test: {len(to_test)} (already done: {len(tested)})")
    
    for batch_idx, (i, query) in enumerate(to_test):
        text = query["text"]
        print(f"  [{batch_idx+1}/{len(to_test)}] {text[:50]}...", end=" ", flush=True)
        
        # Call NER
        t0 = time.time()
        response = call_ner(text)
        elapsed = time.time() - t0
        
        if "error" in response and response["error"]:
            print(f"[X] Error: {response['error']}")
            results["errors"].append({"text": text, "error": response["error"]})
            continue
        
        # Extract and compare
        predicted = extract_normalized(response)
        matches = compare(query["expected"], predicted)
        
        # Store result
        tested[text] = {
            "expected": query["expected"],
            "predicted": predicted,
            "matches": matches,
            "latency_ms": int(elapsed * 1000),
        }
        
        status = "[OK]" if all(matches.values()) else "[!]"
        print(f"{status} ({elapsed*1000:.0f}ms)")
        
        # Checkpoint
        if (batch_idx + 1) % BATCH_SIZE == 0:
            save_results(results)
            print(f"    [*] Checkpoint saved ({batch_idx+1} done)")
        
        # Rate limit delay
        time.sleep(DELAY_BETWEEN_REQUESTS)
    
    save_results(results)
    return results


def generate_report(results: dict):
    """Generate evaluation report with error categorization."""
    tested = results["tested"]
    
    if not tested:
        print("\n[X] No results to report. Run evaluation first.")
        return
    
    # Aggregate metrics
    metrics = defaultdict(lambda: {"correct": 0, "total": 0})
    latencies = []
    
    for text, data in tested.items():
        matches = data["matches"]
        latencies.append(data["latency_ms"])
        
        for field, matched in matches.items():
            metrics[field]["total"] += 1
            if matched:
                metrics[field]["correct"] += 1
    
    # Print report
    print("\n" + "=" * 60)
    print("NER EVALUATION REPORT")
    print("=" * 60)
    
    print(f"\n[i] Queries tested: {len(tested)}")
    print(f"[i] Avg latency: {sum(latencies)/len(latencies):.0f}ms")
    
    print("\n[+] ACCURACY BY FIELD")
    print("-" * 40)
    
    total_correct = 0
    total_all = 0
    
    for field in ["business_type", "location_code", "price", "distance"]:
        m = metrics[field]
        acc = m["correct"] / m["total"] * 100 if m["total"] > 0 else 0
        total_correct += m["correct"]
        total_all += m["total"]
        bar = "#" * int(acc / 5) + "." * (20 - int(acc / 5))
        print(f"  {field:<15} {bar} {acc:5.1f}% ({m['correct']}/{m['total']})")
    
    overall = total_correct / total_all * 100 if total_all > 0 else 0
    print("-" * 40)
    print(f"  {'OVERALL':<15} {'#' * int(overall/5)}{'.' * (20-int(overall/5))} {overall:5.1f}%")
    
    # ── Error Categorization ──────────────────────────────────────────────────
    print("\n[!] ERROR BREAKDOWN BY CATEGORY")
    print("-" * 40)
    
    error_categories = {
        "location_alias": [],    # Location alias not in dict (Q1, Q.1, etc.)
        "price_parser": [],      # Price parsing issues (500k, 2tr, etc.)
        "semantic_miss": [],     # Model didn't recognize entity
    }
    
    for text, data in tested.items():
        matches = data["matches"]
        exp = data["expected"]
        pred = data["predicted"]
        text_lower = text.lower()
        
        # Location errors
        if not matches["location_code"] and exp["location_code"]:
            # Check if text has alias patterns
            has_alias = any(re.search(p, text_lower, re.IGNORECASE) for p in LOCATION_ALIAS_PATTERNS)
            if has_alias and pred["location_code"] is None:
                error_categories["location_alias"].append({
                    "text": text,
                    "expected": exp["location_code"],
                    "predicted": pred["location_code"],
                    "reason": "Alias not in cache/dict"
                })
            elif pred["location_code"] is not None and pred["location_code"] != exp["location_code"]:
                error_categories["semantic_miss"].append({
                    "text": text,
                    "field": "location",
                    "expected": exp["location_code"],
                    "predicted": pred["location_code"],
                    "reason": "Wrong location code"
                })
            else:
                error_categories["semantic_miss"].append({
                    "text": text,
                    "field": "location",
                    "expected": exp["location_code"],
                    "predicted": pred["location_code"],
                    "reason": "Location not detected"
                })
        
        # Price errors
        if not matches["price"] and exp["price_op"]:
            has_price_pattern = any(re.search(p, text_lower, re.IGNORECASE) for p in PRICE_PATTERNS)
            if has_price_pattern:
                if pred["price_op"] is None:
                    error_categories["price_parser"].append({
                        "text": text,
                        "expected": f"{exp['price_op']}:{exp['price_amount']}",
                        "predicted": "None",
                        "reason": "Price not parsed"
                    })
                elif pred["price_op"] != exp["price_op"]:
                    error_categories["price_parser"].append({
                        "text": text,
                        "expected": f"{exp['price_op']}:{exp['price_amount']}",
                        "predicted": f"{pred['price_op']}:{pred['price_amount']}",
                        "reason": "Wrong operator"
                    })
                else:
                    error_categories["price_parser"].append({
                        "text": text,
                        "expected": exp['price_amount'],
                        "predicted": pred['price_amount'],
                        "reason": "Wrong amount"
                    })
            else:
                error_categories["semantic_miss"].append({
                    "text": text,
                    "field": "price",
                    "expected": f"{exp['price_op']}:{exp['price_amount']}",
                    "predicted": f"{pred['price_op']}:{pred['price_amount']}",
                    "reason": "Price semantic miss"
                })
        
        # Business type errors → semantic miss
        if not matches["business_type"] and exp["business_type"]:
            error_categories["semantic_miss"].append({
                "text": text,
                "field": "business_type",
                "expected": exp["business_type"],
                "predicted": pred["business_type"],
                "reason": "Business type miss"
            })
        
        # Distance errors → semantic miss
        if not matches["distance"] and exp["distance_meters"]:
            error_categories["semantic_miss"].append({
                "text": text,
                "field": "distance",
                "expected": exp["distance_meters"],
                "predicted": pred["distance_meters"],
                "reason": "Distance miss"
            })
    
    # Print category summary
    total_errors = sum(len(v) for v in error_categories.values())
    
    for cat, errors in error_categories.items():
        if not errors:
            continue
        
        pct = len(errors) / total_errors * 100 if total_errors > 0 else 0
        action = {
            "location_alias": "Fix location cache/dict",
            "price_parser": "Fix price regex/prompt",
            "semantic_miss": "Need more training data",
        }.get(cat, "Investigate")
        
        print(f"\n  {cat}: {len(errors)} errors ({pct:.1f}%) -> {action}")
        
        # Show first 5 examples
        for err in errors[:5]:
            print(f"    - \"{err['text'][:45]}...\"")
            print(f"      exp: {err.get('expected')} | pred: {err.get('predicted')}")
        
        if len(errors) > 5:
            print(f"    ... and {len(errors) - 5} more")
    
    # Summary table
    print("\n" + "-" * 40)
    print("  SUMMARY: What to fix?")
    print("-" * 40)
    print(f"  | {'Category':<20} | {'Count':>6} | {'Action':<25} |")
    print(f"  |{'-'*22}|{'-'*8}|{'-'*27}|")
    print(f"  | {'location_alias':<20} | {len(error_categories['location_alias']):>6} | {'Add to cache dict':<25} |")
    print(f"  | {'price_parser':<20} | {len(error_categories['price_parser']):>6} | {'Fix regex/prompt':<25} |")
    print(f"  | {'semantic_miss':<20} | {len(error_categories['semantic_miss']):>6} | {'Improve model/data':<25} |")
    print(f"  |{'-'*22}|{'-'*8}|{'-'*27}|")
    print(f"  | {'TOTAL':<20} | {total_errors:>6} | {'':<25} |")
    
    print("\n" + "=" * 60)
    
    return error_categories


def export_errors(results: dict, output_file: Path = None):
    """Export detailed errors to CSV file for analysis."""
    if output_file is None:
        output_file = Path(__file__).parent / "error_report.csv"
    
    tested = results["tested"]
    
    rows = []
    for text, data in tested.items():
        matches = data["matches"]
        exp = data["expected"]
        pred = data["predicted"]
        
        # Skip if all correct
        if all(matches.values()):
            continue
        
        # Determine error category
        text_lower = text.lower()
        
        for field in ["business_type", "location_code", "price", "distance"]:
            if field == "price":
                if matches["price"]:
                    continue
                exp_val = f"{exp['price_op']}:{exp['price_amount']}" if exp['price_op'] else ""
                pred_val = f"{pred['price_op']}:{pred['price_amount']}" if pred['price_op'] else ""
            elif field == "distance":
                if matches["distance"]:
                    continue
                exp_val = f"{exp['distance_meters']}m" if exp['distance_meters'] else ""
                pred_val = f"{pred['distance_meters']}m" if pred['distance_meters'] else ""
            else:
                if matches[field]:
                    continue
                exp_val = exp[field] or ""
                pred_val = pred[field] or ""
            
            # Categorize
            if field == "location_code":
                has_alias = any(re.search(p, text_lower, re.IGNORECASE) for p in LOCATION_ALIAS_PATTERNS)
                if has_alias and not pred_val:
                    category = "location_alias"
                else:
                    category = "semantic_miss"
            elif field == "price":
                has_price = any(re.search(p, text_lower, re.IGNORECASE) for p in PRICE_PATTERNS)
                category = "price_parser" if has_price else "semantic_miss"
            else:
                category = "semantic_miss"
            
            rows.append({
                "text": text,
                "field": field,
                "expected": exp_val,
                "predicted": pred_val,
                "category": category,
                "latency_ms": data["latency_ms"],
            })
    
    # Write CSV
    with open(output_file, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=["category", "field", "text", "expected", "predicted", "latency_ms"])
        writer.writeheader()
        # Sort by category then field
        rows.sort(key=lambda x: (x["category"], x["field"]))
        writer.writerows(rows)
    
    print(f"\n[*] Error report exported to: {output_file}")
    print(f"    Total errors: {len(rows)}")
    
    # Also export full details to JSON
    json_file = output_file.with_suffix(".json")
    with open(json_file, "w", encoding="utf-8") as f:
        json.dump(rows, f, ensure_ascii=False, indent=2)
    print(f"[*] JSON details exported to: {json_file}")


def calculate_prf_metrics(results: dict):
    """Calculate Precision/Recall/F1 per entity type + micro/macro averages."""
    tested = results["tested"]
    
    if not tested:
        print("\n[X] No results for P/R/F1 calculation.")
        return
    
    # Entity-level metrics: TP, FP, FN per type
    metrics = {
        "BUSINESS_TYPE": {"tp": 0, "fp": 0, "fn": 0},
        "LOCATION": {"tp": 0, "fp": 0, "fn": 0},
        "PRICE": {"tp": 0, "fp": 0, "fn": 0},
        "DISTANCE": {"tp": 0, "fp": 0, "fn": 0},
    }
    
    for text, info in tested.items():
        exp = info["expected"]
        pred = info["predicted"]
        matches = info["matches"]
        
        # BUSINESS_TYPE
        exp_bt = exp["business_type"]
        pred_bt = pred["business_type"]
        if exp_bt and pred_bt:
            if matches["business_type"]:
                metrics["BUSINESS_TYPE"]["tp"] += 1
            else:
                metrics["BUSINESS_TYPE"]["fp"] += 1
                metrics["BUSINESS_TYPE"]["fn"] += 1
        elif exp_bt and not pred_bt:
            metrics["BUSINESS_TYPE"]["fn"] += 1
        elif not exp_bt and pred_bt:
            metrics["BUSINESS_TYPE"]["fp"] += 1
        
        # LOCATION
        exp_loc = exp["location_code"]
        pred_loc = pred["location_code"]
        if exp_loc and pred_loc:
            if matches["location_code"]:
                metrics["LOCATION"]["tp"] += 1
            else:
                metrics["LOCATION"]["fp"] += 1
                metrics["LOCATION"]["fn"] += 1
        elif exp_loc and not pred_loc:
            metrics["LOCATION"]["fn"] += 1
        elif not exp_loc and pred_loc:
            metrics["LOCATION"]["fp"] += 1
        
        # PRICE
        exp_price = exp["price_op"]
        pred_price = pred["price_op"]
        if exp_price and pred_price:
            if matches["price"]:
                metrics["PRICE"]["tp"] += 1
            else:
                metrics["PRICE"]["fp"] += 1
                metrics["PRICE"]["fn"] += 1
        elif exp_price and not pred_price:
            metrics["PRICE"]["fn"] += 1
        elif not exp_price and pred_price:
            metrics["PRICE"]["fp"] += 1
        
        # DISTANCE
        exp_dist = exp["distance_meters"]
        pred_dist = pred["distance_meters"]
        if exp_dist and pred_dist:
            if matches["distance"]:
                metrics["DISTANCE"]["tp"] += 1
            else:
                metrics["DISTANCE"]["fp"] += 1
                metrics["DISTANCE"]["fn"] += 1
        elif exp_dist and not pred_dist:
            metrics["DISTANCE"]["fn"] += 1
        elif not exp_dist and pred_dist:
            metrics["DISTANCE"]["fp"] += 1
    
    # Calculate P/R/F1
    def calc_prf(tp, fp, fn):
        p = tp / (tp + fp) if (tp + fp) > 0 else 0
        r = tp / (tp + fn) if (tp + fn) > 0 else 0
        f1 = 2 * p * r / (p + r) if (p + r) > 0 else 0
        return p, r, f1
    
    print("\n" + "=" * 75)
    print("PRECISION / RECALL / F1 (Entity-Level)")
    print("=" * 75)
    print(f"\n{'Entity Type':<20} {'TP':>6} {'FP':>6} {'FN':>6} {'Prec':>8} {'Recall':>8} {'F1':>8}")
    print("-" * 75)
    
    micro_tp, micro_fp, micro_fn = 0, 0, 0
    macro_p, macro_r, macro_f1 = [], [], []
    
    for etype in ["BUSINESS_TYPE", "LOCATION", "PRICE", "DISTANCE"]:
        m = metrics[etype]
        tp, fp, fn = m["tp"], m["fp"], m["fn"]
        p, r, f1 = calc_prf(tp, fp, fn)
        
        print(f"{etype:<20} {tp:>6} {fp:>6} {fn:>6} {p:>7.1%} {r:>7.1%} {f1:>7.1%}")
        
        micro_tp += tp
        micro_fp += fp
        micro_fn += fn
        macro_p.append(p)
        macro_r.append(r)
        macro_f1.append(f1)
    
    print("-" * 75)
    
    # Micro average
    p_micro, r_micro, f1_micro = calc_prf(micro_tp, micro_fp, micro_fn)
    print(f"{'Micro Average':<20} {micro_tp:>6} {micro_fp:>6} {micro_fn:>6} {p_micro:>7.1%} {r_micro:>7.1%} {f1_micro:>7.1%}")
    
    # Macro average
    p_macro = sum(macro_p) / len(macro_p)
    r_macro = sum(macro_r) / len(macro_r)
    f1_macro = sum(macro_f1) / len(macro_f1)
    print(f"{'Macro Average':<20} {'-':>6} {'-':>6} {'-':>6} {p_macro:>7.1%} {r_macro:>7.1%} {f1_macro:>7.1%}")
    
    print("\n" + "=" * 75)
    
    return metrics


def analyze_errors(results: dict):
    """Detailed error analysis grouped by pattern."""
    tested = results["tested"]
    
    if not tested:
        return
    
    errors = {
        "business_type": defaultdict(list),
        "location": defaultdict(list),
        "distance": defaultdict(list),
    }
    
    for text, info in tested.items():
        matches = info["matches"]
        exp = info["expected"]
        pred = info["predicted"]
        
        if not matches["business_type"] and exp["business_type"]:
            pattern = f"{exp['business_type']} -> {pred['business_type'] or 'None'}"
            errors["business_type"][pattern].append(text)
        
        if not matches["location_code"] and exp["location_code"]:
            pattern = f"{exp['location_code']} -> {pred['location_code'] or 'None'}"
            errors["location"][pattern].append(text)
        
        if not matches["distance"] and exp["distance_meters"]:
            pattern = f"{exp['distance_meters']}m -> {pred['distance_meters'] or 'None'}m"
            errors["distance"][pattern].append(text)
    
    print("\n" + "=" * 75)
    print("ERROR PATTERN ANALYSIS")
    print("=" * 75)
    
    for category, patterns in errors.items():
        if not patterns:
            continue
        
        total = sum(len(v) for v in patterns.values())
        print(f"\n### {category.upper()} ERRORS ({total} total)")
        print("-" * 50)
        
        for pattern, examples in sorted(patterns.items(), key=lambda x: -len(x[1])):
            print(f"\n  {pattern} ({len(examples)}x)")
            for ex in examples[:3]:
                print(f"    - \"{ex[:55]}...\"" if len(ex) > 55 else f"    - \"{ex}\"")
            if len(examples) > 3:
                print(f"    ... +{len(examples) - 3} more")
    
    # Save to file
    report_file = Path(__file__).parent / "error_analysis.json"
    with open(report_file, "w", encoding="utf-8") as f:
        # Convert defaultdict to regular dict for JSON
        json.dump({k: dict(v) for k, v in errors.items()}, f, ensure_ascii=False, indent=2)
    print(f"\n[*] Error analysis saved to: {report_file}")


def main():
    parser = argparse.ArgumentParser(description="Simple NER Evaluation")
    parser.add_argument("--limit", type=int, help="Limit number of queries to test")
    parser.add_argument("--resume", action="store_true", help="Resume from checkpoint")
    parser.add_argument("--report-only", action="store_true", help="Show report without running")
    parser.add_argument("--reset", action="store_true", help="Clear previous results")
    parser.add_argument("--export", action="store_true", help="Export errors to CSV/JSON files")
    parser.add_argument("--metrics", action="store_true", help="Show P/R/F1 metrics")
    parser.add_argument("--analyze", action="store_true", help="Show detailed error analysis")
    args = parser.parse_args()
    
    # Load data
    queries = load_gold()
    print(f"[i] Loaded {len(queries)} gold queries")
    
    # Load or reset results
    if args.reset and RESULTS_FILE.exists():
        RESULTS_FILE.unlink()
        print("[*] Previous results cleared")
    
    results = load_results() if args.resume or not args.reset else {"tested": {}, "errors": []}
    
    # Run or report
    if args.report_only:
        generate_report(results)
        if args.metrics:
            calculate_prf_metrics(results)
        if args.analyze:
            analyze_errors(results)
        if args.export:
            export_errors(results)
    else:
        results = run_evaluation(queries, results, limit=args.limit)
        generate_report(results)
        # Always show metrics after running
        calculate_prf_metrics(results)
        if args.analyze:
            analyze_errors(results)
        if args.export:
            export_errors(results)


if __name__ == "__main__":
    main()
