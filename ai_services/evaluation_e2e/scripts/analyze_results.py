"""
Phân tích bổ sung từ e2e_results.jsonl để in ra các bảng chi tiết
phục vụ báo cáo (phân bố điểm, throughput, tỉ lệ mẫu đạt ≥4, ...).
"""
import json
import statistics
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
RESULTS = ROOT / "results" / "e2e_results.jsonl"

rows = []
with RESULTS.open("r", encoding="utf-8") as f:
    for line in f:
        line = line.strip()
        if not line:
            continue
        rows.append(json.loads(line))

ok = [r for r in rows if r.get("stream", {}).get("ok")]
jr = [r for r in ok if r.get("judge", {}).get("ok")]

print(f"Total rows: {len(rows)} | ok: {len(ok)} | judged: {len(jr)}")


def _p(data, q):
    if not data:
        return 0.0
    s = sorted(data)
    k = (len(s) - 1) * q
    f = int(k)
    c = min(f + 1, len(s) - 1)
    return s[f] if f == c else s[f] + (s[c] - s[f]) * (k - f)


def describe(name, vals):
    if not vals:
        return
    print(f"\n== {name} (n={len(vals)}) ==")
    print(f"  mean   = {statistics.mean(vals):.4f}")
    print(f"  median = {statistics.median(vals):.4f}")
    print(f"  stdev  = {statistics.pstdev(vals):.4f}")
    print(f"  min    = {min(vals):.4f}")
    print(f"  p50    = {_p(vals, 0.50):.4f}")
    print(f"  p90    = {_p(vals, 0.90):.4f}")
    print(f"  p95    = {_p(vals, 0.95):.4f}")
    print(f"  p99    = {_p(vals, 0.99):.4f}")
    print(f"  max    = {max(vals):.4f}")


# 1. Overall throughput (tokens/s during streaming, ~= word-count / streaming_s)
throughputs = []
for r in ok:
    st = r["stream"]
    if st.get("streaming_s") and r.get("answer_word_count"):
        throughputs.append(r["answer_word_count"] / st["streaming_s"])
describe("throughput_words_per_sec", throughputs)

# 2. Distribution of judge scores (1..5) per metric
print("\n== Judge score distribution (N=496) ==")
for metric in ["correctness", "helpfulness", "relevance"]:
    cnt = Counter(r["judge"][metric] for r in jr if r["judge"].get(metric))
    total = sum(cnt.values())
    line = f"  {metric:12s}"
    for s in [1, 2, 3, 4, 5]:
        pct = 100.0 * cnt.get(s, 0) / total if total else 0
        line += f"  {s}:{cnt.get(s, 0):3d}({pct:5.1f}%)"
    print(line)

# 3. Pass rate (score >= 4) per metric
print("\n== Pass rate (score >= 4) ==")
for metric in ["correctness", "helpfulness", "relevance"]:
    vals = [r["judge"][metric] for r in jr if r["judge"].get(metric)]
    pr = 100.0 * sum(1 for v in vals if v >= 4) / len(vals)
    print(f"  {metric:12s}: {pr:.2f}%  (n={len(vals)})")

# 4. Cost summary
costs = [r["cost_usd_gpu_a5000"] for r in ok if r.get("cost_usd_gpu_a5000") is not None]
describe("cost_usd_per_request_A5000", costs)
print(f"\nTotal cost for running full 500: ${sum(costs):.4f}")

# 5. By category cost + throughput
print("\n== Per-category cost + throughput (mean) ==")
by_cat = defaultdict(list)
by_cat_tp = defaultdict(list)
for r in ok:
    by_cat[r["category"]].append(r["cost_usd_gpu_a5000"])
    st = r["stream"]
    if st.get("streaming_s") and r.get("answer_word_count"):
        by_cat_tp[r["category"]].append(r["answer_word_count"] / st["streaming_s"])
for cat, arr in by_cat.items():
    tp = by_cat_tp[cat]
    print(f"  {cat:35s} n={len(arr):3d}  mean_cost=${statistics.mean(arr):.5f}  mean_tp={statistics.mean(tp) if tp else 0:.2f} w/s")

# 6. Sample-to-sample wall-time (including judge)
wall = [r["wall_time_s"] for r in rows if r.get("wall_time_s")]
describe("wall_time_incl_judge_s", wall)
