"""
evaluation/analysis/analyze_results.py

Analyse evaluation run results and generate visualisations.

Usage (from recommender2/ root):
    python -m evaluation.analysis.analyze_results
    python -m evaluation.analysis.analyze_results --run results/runs/chatbot_baseline.json
    python -m evaluation.analysis.analyze_results --run results/runs/home_baseline.json

Outputs:
    - Cosine similarity score distribution (histogram)
    - Category-wise metric breakdown (grouped bar chart)
    - Latency distribution (histogram with p50/p95/p99 markers)
    - Hard Negative Rate per category (bar chart)
    - Metrics summary as CSV
    - Plots saved to evaluation/results/plots/
"""

from __future__ import annotations

import argparse
import csv
import json
import os
import re
import sys
from glob import glob
from typing import Dict, List

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.insert(0, ROOT_DIR)

EVAL_DIR = os.path.join(ROOT_DIR, "evaluation")
RESULTS_DIR = os.path.join(EVAL_DIR, "results")
RUNS_DIR = os.path.join(RESULTS_DIR, "runs")
PLOTS_DIR = os.path.join(RESULTS_DIR, "plots")


def _resolve_path(path: str) -> str:
    """Resolve a path relative to ROOT_DIR if not absolute."""
    if os.path.isabs(path):
        return path
    return os.path.join(ROOT_DIR, path)


def load_run(path: str) -> Dict:
    """Load a run result JSON file."""
    resolved = _resolve_path(path)
    with open(resolved, "r", encoding="utf-8") as f:
        return json.load(f)


def _available_k_values(per_query: List[Dict], metric_prefix: str) -> List[int]:
    """Return sorted K values found for a metric prefix in per-query keys."""
    ks = set()
    pattern = re.compile(rf"^{re.escape(metric_prefix)}@(\d+)$")
    for row in per_query:
        for key in row.keys():
            m = pattern.match(key)
            if m:
                ks.add(int(m.group(1)))
    return sorted(ks)


def _choose_k(per_query: List[Dict], metric_prefix: str, preferred_k: int = 3) -> int | None:
    """Choose preferred K if available, otherwise the nearest available K."""
    ks = _available_k_values(per_query, metric_prefix)
    if not ks:
        return None
    if preferred_k in ks:
        return preferred_k
    return min(ks, key=lambda k: abs(k - preferred_k))


def _inject_categories_from_dataset(run_data: Dict) -> None:
    """Backfill prediction categories from dataset when missing in run JSON."""
    preds = run_data.get("predictions", [])
    if not preds:
        return
    if any(p.get("category") for p in preds):
        return

    dataset_name = run_data.get("config", {}).get("dataset", "")
    dataset_path = os.path.join(EVAL_DIR, "datasets", dataset_name)
    if not dataset_name or not os.path.exists(dataset_path):
        return

    try:
        with open(dataset_path, "r", encoding="utf-8") as f:
            dataset = json.load(f)
    except Exception:
        return

    id_to_cat = {
        str(item.get("id")): item.get("category", "")
        for item in dataset
        if isinstance(item, dict) and item.get("id")
    }

    for p in preds:
        pid = str(p.get("id", ""))
        if pid and not p.get("category"):
            p["category"] = id_to_cat.get(pid, "")


def find_latest_run() -> str | None:
    """Find the most recently modified run file."""
    runs = glob(os.path.join(RUNS_DIR, "*.json"))
    if not runs:
        return None
    return max(runs, key=os.path.getmtime)


# ---------------------------------------------------------------------------
# 1. Search Score Distribution
# ---------------------------------------------------------------------------

def plot_cosine_distribution(run_data: Dict, output_dir: str = PLOTS_DIR) -> str:
    """
    Plot histogram of retrieval scores, split into
    'relevant' (TP) and 'irrelevant' (FP) retrieved items.

    Higher score is interpreted as better match in saved run output.
    """
    import matplotlib
    matplotlib.use("Agg")  # Non-interactive backend
    import matplotlib.pyplot as plt

    relevant_scores = []
    irrelevant_scores = []

    for pred in run_data.get("predictions", []):
        relevant_set = set(pred["relevant_ids"])
        retrieved_ids = pred.get("retrieved_ids", [])
        scores = pred.get("scores", [])

        for doc_id, score in zip(retrieved_ids, scores):
            if doc_id in relevant_set:
                relevant_scores.append(score)
            else:
                irrelevant_scores.append(score)

    if not relevant_scores and not irrelevant_scores:
        print("⚠️  No score data to plot")
        return ""

    fig, ax = plt.subplots(figsize=(10, 6))

    bins = 30
    if irrelevant_scores:
        ax.hist(
            irrelevant_scores, bins=bins, alpha=0.6,
            label=f"Irrelevant (n={len(irrelevant_scores)})",
            color="#ef4444", edgecolor="white"
        )
    if relevant_scores:
        ax.hist(
            relevant_scores, bins=bins, alpha=0.7,
            label=f"Relevant (n={len(relevant_scores)})",
            color="#22c55e", edgecolor="white"
        )

    ax.set_xlabel("Search Score (aligned)", fontsize=12)
    ax.set_ylabel("Count", fontsize=12)
    ax.set_title(
        f"Score Distribution — {run_data['run_name']}\n"
        f"(Higher = Better)",
        fontsize=14
    )
    ax.legend(fontsize=11)
    ax.grid(axis="y", alpha=0.3)

    # Add vertical line for mean scores
    if relevant_scores:
        mean_rel = sum(relevant_scores) / len(relevant_scores)
        ax.axvline(mean_rel, color="#16a34a", linestyle="--", linewidth=1.5,
                   label=f"Mean relevant: {mean_rel:.3f}")
    if irrelevant_scores:
        mean_irr = sum(irrelevant_scores) / len(irrelevant_scores)
        ax.axvline(mean_irr, color="#dc2626", linestyle="--", linewidth=1.5,
                   label=f"Mean irrelevant: {mean_irr:.3f}")
    ax.legend(fontsize=10)

    plt.tight_layout()
    os.makedirs(output_dir, exist_ok=True)

    run_type = "chatbot" if "chatbot" in run_data["run_name"].lower() else "home"
    filename = f"cosine_dist_{run_type}_{run_data['run_name']}.png"
    out_path = os.path.join(output_dir, filename)
    fig.savefig(out_path, dpi=150)
    plt.close(fig)

    print(f"📊 Score distribution saved to: {out_path}")
    return out_path


# ---------------------------------------------------------------------------
# 2. Category-wise Metric Breakdown
# ---------------------------------------------------------------------------

def plot_category_breakdown(run_data: Dict, output_dir: str = PLOTS_DIR) -> str:
    """
    Plot grouped bar chart showing metrics per category.
    Only works for chatbot runs that have category labels.
    """
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    predictions = run_data.get("predictions", [])
    per_query = run_data.get("per_query", [])

    # Older runs may not include category in predictions; recover from dataset.
    _inject_categories_from_dataset(run_data)

    # Check if we have category info
    categories = sorted(set(p.get("category", "") for p in predictions if p.get("category")))
    if not categories:
        print("⚠️  No category data — skipping category breakdown")
        return ""

    k = _choose_k(per_query, "Hit", preferred_k=3)
    if k is None:
        print("⚠️  No per-query Hit@K metrics found — skipping category breakdown")
        return ""

    pq_by_id = {pq["id"]: pq for pq in per_query}

    # Metrics to plot
    metrics_to_show = [f"Hit@{k}", f"Recall@{k}", f"MRR@{k}", f"NDCG@{k}"]

    # Compute per-category averages
    cat_data: Dict[str, Dict[str, float]] = {}
    for cat in categories:
        cat_preds = [p for p in predictions if p.get("category") == cat]
        n = len(cat_preds)
        if n == 0:
            continue
        cat_data[cat] = {}
        for metric in metrics_to_show:
            total = sum(pq_by_id.get(p["id"], {}).get(metric, 0) for p in cat_preds)
            cat_data[cat][metric] = total / n

    if not cat_data:
        return ""

    # Plot
    fig, ax = plt.subplots(figsize=(12, 6))

    x_labels = list(cat_data.keys())
    x = range(len(x_labels))
    bar_width = 0.18
    colors = ["#3b82f6", "#22c55e", "#f59e0b", "#8b5cf6"]

    for i, metric in enumerate(metrics_to_show):
        values = [cat_data[cat].get(metric, 0) for cat in x_labels]
        offsets = [xi + i * bar_width - bar_width * 1.5 for xi in x]
        ax.bar(offsets, values, bar_width, label=metric, color=colors[i],
               edgecolor="white", linewidth=0.8)

    ax.set_xlabel("Category", fontsize=12)
    ax.set_ylabel("Score", fontsize=12)
    ax.set_title(f"Category Breakdown — {run_data['run_name']}", fontsize=14)
    ax.set_xticks(list(x))
    ax.set_xticklabels(x_labels, fontsize=11)
    ax.set_ylim(0, 1.05)
    ax.legend(fontsize=10, loc="upper right")
    ax.grid(axis="y", alpha=0.3)

    plt.tight_layout()
    os.makedirs(output_dir, exist_ok=True)

    filename = f"category_breakdown_{run_data['run_name']}.png"
    out_path = os.path.join(output_dir, filename)
    fig.savefig(out_path, dpi=150)
    plt.close(fig)

    print(f"📊 Category breakdown saved to: {out_path}")
    return out_path


# ---------------------------------------------------------------------------
# 3. Latency Distribution
# ---------------------------------------------------------------------------

def plot_latency_distribution(run_data: Dict, output_dir: str = PLOTS_DIR) -> str:
    """Plot histogram of per-query latency with p50/p95/p99 markers."""
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    predictions = run_data.get("predictions", [])
    latencies = [p["latency_ms"] for p in predictions if "latency_ms" in p]

    if not latencies:
        print("⚠️  No latency data — skipping latency plot")
        return ""

    latencies_sorted = sorted(latencies)
    n = len(latencies_sorted)
    avg_lat = sum(latencies) / n
    p50 = latencies_sorted[n // 2]
    p95 = latencies_sorted[min(int(n * 0.95), n - 1)]
    p99 = latencies_sorted[min(int(n * 0.99), n - 1)]

    fig, ax = plt.subplots(figsize=(10, 6))

    ax.hist(latencies, bins=30, alpha=0.7, color="#3b82f6", edgecolor="white")

    # Percentile markers
    ax.axvline(avg_lat, color="#22c55e", linestyle="-", linewidth=2,
               label=f"Avg: {avg_lat:.1f}ms")
    ax.axvline(p50, color="#f59e0b", linestyle="--", linewidth=1.5,
               label=f"P50: {p50:.1f}ms")
    ax.axvline(p95, color="#ef4444", linestyle="--", linewidth=1.5,
               label=f"P95: {p95:.1f}ms")
    ax.axvline(p99, color="#dc2626", linestyle="-.", linewidth=1.5,
               label=f"P99: {p99:.1f}ms")

    ax.set_xlabel("Latency (ms)", fontsize=12)
    ax.set_ylabel("Count", fontsize=12)
    ax.set_title(
        f"Retrieval Latency — {run_data['run_name']}\n"
        f"({n} queries)",
        fontsize=14
    )
    ax.legend(fontsize=10)
    ax.grid(axis="y", alpha=0.3)

    plt.tight_layout()
    os.makedirs(output_dir, exist_ok=True)

    filename = f"latency_dist_{run_data['run_name']}.png"
    out_path = os.path.join(output_dir, filename)
    fig.savefig(out_path, dpi=150)
    plt.close(fig)

    print(f"📊 Latency distribution saved to: {out_path}")
    return out_path


# ---------------------------------------------------------------------------
# 4. Hard Negative Rate per Category
# ---------------------------------------------------------------------------

def plot_hard_negative_breakdown(run_data: Dict, output_dir: str = PLOTS_DIR) -> str:
    """Plot hard negative rate per category (bar chart)."""
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    predictions = run_data.get("predictions", [])
    per_query = run_data.get("per_query", [])

    # Older runs may not include category in predictions; recover from dataset.
    _inject_categories_from_dataset(run_data)

    # Check if HNR data exists
    available_hnr_ks = _available_k_values(per_query, "HNR")
    if not available_hnr_ks:
        print("⚠️  No hard negative data — skipping HNR breakdown")
        return ""

    categories = sorted(set(
        p.get("category", "") for p in predictions if p.get("category")
    ))
    pq_by_id = {pq["id"]: pq for pq in per_query}

    # Fall back to "all" if no categories
    if not categories:
        categories = ["all"]
        for p in predictions:
            p.setdefault("category", "all")

    preferred_ks = [1, 3, 5]
    selected_ks = [k for k in preferred_ks if k in available_hnr_ks]
    if not selected_ks:
        selected_ks = available_hnr_ks[:3]
    hnr_metrics = [f"HNR@{k}" for k in selected_ks]
    cat_data: Dict[str, Dict[str, float]] = {}

    for cat in categories:
        cat_preds = [p for p in predictions if p.get("category", "all") == cat]
        n = len(cat_preds)
        if n == 0:
            continue
        cat_data[cat] = {}
        for metric in hnr_metrics:
            total = sum(pq_by_id.get(p["id"], {}).get(metric, 0) for p in cat_preds)
            cat_data[cat][metric] = total / n

    if not cat_data:
        return ""

    fig, ax = plt.subplots(figsize=(10, 6))

    x_labels = list(cat_data.keys())
    x = range(len(x_labels))
    bar_width = 0.25
    colors = ["#ef4444", "#f97316", "#eab308"]

    for i, metric in enumerate(hnr_metrics):
        values = [cat_data[cat].get(metric, 0) for cat in x_labels]
        offsets = [xi + i * bar_width - bar_width for xi in x]
        ax.bar(offsets, values, bar_width, label=metric, color=colors[i],
               edgecolor="white", linewidth=0.8)

    ax.set_xlabel("Category", fontsize=12)
    ax.set_ylabel("Hard Negative Rate (↓ lower is better)", fontsize=12)
    ax.set_title(
        f"Hard Negative Rate — {run_data['run_name']}\n"
        f"(Lower = model avoids confusing services better)",
        fontsize=14
    )
    ax.set_xticks(list(x))
    ax.set_xticklabels(x_labels, fontsize=11)
    ax.set_ylim(0, max(0.5, max(
        max(cat_data[cat].get(m, 0) for m in hnr_metrics)
        for cat in x_labels
    ) * 1.2))
    ax.legend(fontsize=10)
    ax.grid(axis="y", alpha=0.3)

    plt.tight_layout()
    os.makedirs(output_dir, exist_ok=True)

    filename = f"hnr_breakdown_{run_data['run_name']}.png"
    out_path = os.path.join(output_dir, filename)
    fig.savefig(out_path, dpi=150)
    plt.close(fig)

    print(f"📊 Hard Negative Rate breakdown saved to: {out_path}")
    return out_path


# ---------------------------------------------------------------------------
# 5. Metrics Summary CSV
# ---------------------------------------------------------------------------

def save_metrics_csv(run_data: Dict, output_dir: str = RESULTS_DIR) -> str:
    """Save aggregate metrics as a CSV file for easy comparison."""
    agg = run_data.get("aggregate", {})
    config = run_data.get("config", {})

    os.makedirs(output_dir, exist_ok=True)
    out_path = os.path.join(output_dir, "metrics_report.csv")

    # Use a stable schema to avoid column misalignment across runs.
    file_exists = os.path.exists(out_path)
    existing_fieldnames: List[str] | None = None
    if file_exists:
        with open(out_path, "r", newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            existing_fieldnames = reader.fieldnames

    row = {
        "run_name": run_data["run_name"],
        "timestamp": run_data.get("timestamp", ""),
        "embedding_model": config.get("embedding_model", ""),
        "top_k": config.get("top_k", ""),
        "num_queries": agg.get("num_queries", 0),
    }
    # Add all metric values
    for key, val in sorted(agg.items()):
        if key != "num_queries":
            row[key] = val

    fieldnames = existing_fieldnames or list(row.keys())
    if existing_fieldnames:
        for key in row.keys():
            if key not in fieldnames:
                fieldnames.append(key)

    normalized_row = {k: row.get(k, "") for k in fieldnames}

    with open(out_path, "a", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        if not file_exists:
            writer.writeheader()
        writer.writerow(normalized_row)

    print(f"📄 Metrics appended to: {out_path}")
    return out_path


# ---------------------------------------------------------------------------
# 6. Run comparison (if multiple runs exist)
# ---------------------------------------------------------------------------

def compare_runs(run_paths: List[str], output_dir: str = PLOTS_DIR) -> str:
    """Plot metrics comparison across multiple runs."""
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    if len(run_paths) < 2:
        print("⚠️  Need ≥2 runs to compare")
        return ""

    # Validate all files exist before loading
    for p in run_paths:
        resolved = _resolve_path(p)
        if not os.path.exists(resolved):
            print(f"❌ Run file not found: {p}")
            print(f"   Resolved path: {resolved}")
            print(f"   Available runs:")
            available = glob(os.path.join(RUNS_DIR, "*.json"))
            if available:
                for r in available:
                    print(f"     - {os.path.basename(r)}")
            else:
                print("     (none — run evaluation first)")
            return ""

    runs = [load_run(p) for p in run_paths]
    metrics_to_compare = ["Hit@3", "Recall@3", "MRR@3", "NDCG@3"]

    fig, ax = plt.subplots(figsize=(12, 6))

    x = range(len(metrics_to_compare))
    bar_width = 0.8 / len(runs)
    colors = ["#3b82f6", "#22c55e", "#f59e0b", "#8b5cf6", "#ef4444", "#06b6d4"]

    for i, run in enumerate(runs):
        agg = run.get("aggregate", {})
        values = [agg.get(m, 0) for m in metrics_to_compare]
        offsets = [xi + i * bar_width - bar_width * (len(runs) - 1) / 2 for xi in x]
        color = colors[i % len(colors)]
        ax.bar(offsets, values, bar_width, label=run["run_name"],
               color=color, edgecolor="white")

    ax.set_xlabel("Metric", fontsize=12)
    ax.set_ylabel("Score", fontsize=12)
    ax.set_title("Run Comparison", fontsize=14)
    ax.set_xticks(list(x))
    ax.set_xticklabels(metrics_to_compare, fontsize=11)
    ax.set_ylim(0, 1.05)
    ax.legend(fontsize=10)
    ax.grid(axis="y", alpha=0.3)

    plt.tight_layout()
    os.makedirs(output_dir, exist_ok=True)
    out_path = os.path.join(output_dir, "run_comparison.png")
    fig.savefig(out_path, dpi=150)
    plt.close(fig)

    print(f"📊 Run comparison saved to: {out_path}")
    return out_path


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="Analyze evaluation results and generate visualizations"
    )
    parser.add_argument(
        "--run", type=str, default=None,
        help="Path to a specific run JSON file (default: latest run)"
    )
    parser.add_argument(
        "--compare", type=str, nargs="+",
        help="Compare multiple run files"
    )
    parser.add_argument(
        "--output-dir", type=str, default=PLOTS_DIR,
        help="Directory to save plots"
    )
    parser.add_argument(
        "--no-csv", action="store_true",
        help="Skip CSV report generation"
    )
    args = parser.parse_args()

    # Compare mode
    if args.compare:
        compare_runs(args.compare, output_dir=args.output_dir)
        return

    # Single run analysis
    run_path = args.run
    if not run_path:
        run_path = find_latest_run()
        if not run_path:
            print("❌ No run files found in results/runs/")
            print("   Run evaluation first:")
            print("     python -m evaluation.scripts.eval_chatbot")
            print("     python -m evaluation.scripts.eval_home")
            return
    else:
        resolved = _resolve_path(run_path)
        if not os.path.exists(resolved):
            print(f"❌ Run file not found: {run_path}")
            print(f"   Resolved path: {resolved}")
            return

    print(f"📂 Loading run: {run_path}")
    run_data = load_run(run_path)

    # Generate all visualizations
    plot_cosine_distribution(run_data, output_dir=args.output_dir)
    plot_category_breakdown(run_data, output_dir=args.output_dir)
    plot_latency_distribution(run_data, output_dir=args.output_dir)
    plot_hard_negative_breakdown(run_data, output_dir=args.output_dir)

    if not args.no_csv:
        save_metrics_csv(run_data)

    print("\n✨ Analysis complete!")


if __name__ == "__main__":
    main()
