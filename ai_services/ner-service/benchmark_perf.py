"""
Performance benchmark for NER service pipeline.
Measures: latency per request, cold vs warm cache, throughput.

Run with: python benchmark_perf.py
Server must be running on http://127.0.0.1:8002
"""

import json
import time
import statistics
import urllib.request
import urllib.error

BASE = "http://127.0.0.1:8002"

BENCH_QUERIES = [
    "Tìm spa gần đây giá dưới 500k",
    "Mình cần tìm phòng khám nha sĩ ở HCM, chi phí khoảng 400k",
    "Tìm gym trong vòng 3km ở Quận 3",
    "Massage trị liệu ở Hà Nội trên 4 sao",
    "Hiệu thuốc gần đây bán thuốc cảm",
    "Tìm tiệm làm đẹp ở Đà Nẵng giá 300k",
    "Phòng khám da liễu gần Quận 7",
    "Yoga xung quanh đây giá từ 100k đến 300k",
    "Nha khoa khoảng 1.5 triệu ở TPHCM",
    "Tìm spa trên 4 sao cách 2 cây số",
]

REPEAT = 10  # requests per query for warm cache measurement


def post(path, body, timeout=15):
    data = json.dumps(body).encode()
    req = urllib.request.Request(
        f"{BASE}{path}",
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        t0 = time.perf_counter()
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            result = json.loads(resp.read())
        elapsed = (time.perf_counter() - t0) * 1000  # ms
        return result, elapsed
    except Exception as e:
        return {"error": str(e)}, -1


def clear_cache():
    post("/internal/clear-cache", {})


SEP = "=" * 65


def run_cold_benchmark():
    """One request per query with cache cleared each time — worst case latency."""
    print("\n--- Cold Cache Latency (cache cleared before each request) ---")
    latencies = []
    for q in BENCH_QUERIES:
        clear_cache()
        _, ms = post("/ner/extract", {"text": q})
        if ms > 0:
            latencies.append(ms)
            print(f"  {ms:7.1f}ms  \"{q[:50]}\"")
    if latencies:
        print(f"\n  min={min(latencies):.1f}ms  max={max(latencies):.1f}ms  "
              f"mean={statistics.mean(latencies):.1f}ms  p95={sorted(latencies)[int(len(latencies)*0.95)]:.1f}ms")
    return latencies


def run_warm_benchmark():
    """Repeated requests for same query — warm LRU cache latency."""
    print(f"\n--- Warm Cache Latency ({REPEAT} repeats per query, cache pre-warmed) ---")
    all_latencies = []

    # Pre-warm: run each query once
    for q in BENCH_QUERIES:
        post("/ner/extract", {"text": q})

    for q in BENCH_QUERIES:
        latencies = []
        for _ in range(REPEAT):
            _, ms = post("/ner/extract", {"text": q})
            if ms > 0:
                latencies.append(ms)
        if latencies:
            all_latencies.extend(latencies)
            print(f"  mean={statistics.mean(latencies):6.1f}ms  "
                  f"min={min(latencies):6.1f}ms  "
                  f"\"{q[:45]}\"")

    if all_latencies:
        print(f"\n  Overall warm: mean={statistics.mean(all_latencies):.1f}ms  "
              f"p50={sorted(all_latencies)[len(all_latencies)//2]:.1f}ms  "
              f"p95={sorted(all_latencies)[int(len(all_latencies)*0.95)]:.1f}ms")
    return all_latencies


def run_throughput_benchmark(duration_s=5):
    """How many requests/sec can the server handle sequentially?"""
    print(f"\n--- Sequential Throughput ({duration_s}s window, warm cache) ---")
    # Pre-warm
    for q in BENCH_QUERIES:
        post("/ner/extract", {"text": q})

    count = 0
    t_start = time.perf_counter()
    i = 0
    while time.perf_counter() - t_start < duration_s:
        q = BENCH_QUERIES[i % len(BENCH_QUERIES)]
        _, ms = post("/ner/extract", {"text": q})
        if ms > 0:
            count += 1
        i += 1

    elapsed = time.perf_counter() - t_start
    rps = count / elapsed
    print(f"  {count} requests in {elapsed:.1f}s → {rps:.1f} req/s")
    return rps


def run_entity_coverage():
    """Check which entity types are extracted across all queries."""
    print("\n--- Entity Coverage ---")
    clear_cache()
    type_counts: dict[str, int] = {}
    for q in BENCH_QUERIES:
        r, _ = post("/ner/extract", {"text": q})
        for e in r.get("entities", []):
            t = e["type"]
            type_counts[t] = type_counts.get(t, 0) + 1

    for t, n in sorted(type_counts.items(), key=lambda x: -x[1]):
        bar = "█" * n
        print(f"  {t:<20} {bar} ({n})")


print(SEP)
print("NER SERVICE v2 — PERFORMANCE BENCHMARK")
print(SEP)

cold = run_cold_benchmark()
warm = run_warm_benchmark()
rps  = run_throughput_benchmark(duration_s=5)
run_entity_coverage()

print(f"\n{SEP}")
if cold and warm:
    speedup = statistics.mean(cold) / statistics.mean(warm)
    print(f"Cache speedup: {speedup:.1f}x  "
          f"(cold={statistics.mean(cold):.0f}ms → warm={statistics.mean(warm):.0f}ms)")
print(f"Throughput: {rps:.1f} req/s (sequential)")
print(SEP)
