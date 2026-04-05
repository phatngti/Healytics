# Evaluation Guide

This folder contains the offline evaluation pipeline for the recommender in two scenarios:
- Chatbot query retrieval (`eval_chatbot.py`)
- Home profile retrieval (`eval_home.py`)

It computes ranking quality metrics, latency stats, and generates analysis plots from saved runs.

## Folder Layout

```text
evaluation/
  analysis/
    analyze_results.py          # Plotting and CSV reporting
  datasets/
    chatbot_eval.json           # Chatbot ground-truth dataset
    home_eval.json              # Home ground-truth dataset
    generate_baseline.py        # Regenerate baseline datasets
    prompt_templates.txt        # Templates for synthetic generation
  metrics/
    ir_metrics.py               # Metric implementations (Hit, Recall, MRR, NDCG, etc.)
  results/
    runs/                       # Saved run JSON files
    plots/                      # Generated PNG plots
    metrics_report.csv          # Appended metric summary table
  scripts/
    eval_chatbot.py             # Chatbot evaluator
    eval_home.py                # Home evaluator
    generate_data.py            # LLM generation template (not implemented)
    run.ps1                     # Convenience runner for Windows
```

## What Gets Measured

Per run, the evaluators compute:
- `Hit@K`
- `Precision@K` (`Prec@K` in output)
- `Recall@K`
- `MRR@K`
- `NDCG@K` (binary relevance)
- `NDCG_G@K` (graded relevance, if `relevance_grades` exists)
- `HNR@K` (Hard Negative Rate, lower is better, if `hard_negative_ids` exists)
- `Diversity@K` (if embeddings can be fetched)
- Latency statistics: average, p50, p95, p99, max (ms)

## Prerequisites

Run from the `ai_services/recommender2` root so module imports resolve correctly.

1. Create/activate a Python environment.
2. Install project dependencies (for example from the service root):

```powershell
cd ai_services
pip install -r requirements.txt
```

3. Ensure recommender config/env is available (same setup used for running `app.py`).

## Quick Start

From `ai_services/recommender2`:

```powershell
# 1) Run chatbot evaluation
python -m evaluation.scripts.eval_chatbot --top-k 10 --run-name chatbot_baseline_v1

# 2) Run home evaluation
python -m evaluation.scripts.eval_home --top-k 10 --run-name home_baseline_v1

# 3) Analyze latest run and generate plots
python -m evaluation.analysis.analyze_results
```

### Windows Convenience Runner

```powershell
# default: chatbot eval + analysis
powershell -ExecutionPolicy Bypass -File evaluation/scripts/run.ps1

# specific tasks
powershell -ExecutionPolicy Bypass -File evaluation/scripts/run.ps1 -Chatbot
powershell -ExecutionPolicy Bypass -File evaluation/scripts/run.ps1 -EvalHome
powershell -ExecutionPolicy Bypass -File evaluation/scripts/run.ps1 -Analyze
powershell -ExecutionPolicy Bypass -File evaluation/scripts/run.ps1 -All
```

## Script Usage

### Chatbot Evaluation

```powershell
python -m evaluation.scripts.eval_chatbot \
  --top-k 10 \
  --k-values 1 3 5 10 \
  --run-name chatbot_baseline_v1 \
  --dataset evaluation/datasets/chatbot_eval.json \
  --collection healytics_eval_collection
```

Arguments:
- `--top-k`: number of results retrieved per query
- `--k-values`: metric cutoffs
- `--run-name`: output file label under `results/runs/`
- `--dataset`: dataset path
- `--collection`: Chroma collection name
- `--no-save`: run without writing JSON output

### Home Evaluation

```powershell
python -m evaluation.scripts.eval_home \
  --top-k 10 \
  --k-values 1 3 5 10 \
  --run-name home_baseline_v1 \
  --dataset evaluation/datasets/home_eval.json \
  --collection healytics_eval_collection
```

Arguments are the same as chatbot mode.

### Analysis and Plotting

```powershell
# analyze latest run in results/runs/
python -m evaluation.analysis.analyze_results

# analyze a specific run
python -m evaluation.analysis.analyze_results --run evaluation/results/runs/chatbot_baseline_v1.json

# compare multiple runs
python -m evaluation.analysis.analyze_results \
  --compare \
  evaluation/results/runs/chatbot_baseline_v1.json \
  evaluation/results/runs/home_baseline_v1.json
```

Optional flags:
- `--output-dir`: custom plot output directory
- `--no-csv`: skip appending to `results/metrics_report.csv`

## Output Files

After evaluation:
- `evaluation/results/runs/<run_name>.json`

After analysis:
- `evaluation/results/plots/cosine_dist_*.png`
- `evaluation/results/plots/category_breakdown_*.png` (if categories are available)
- `evaluation/results/plots/latency_dist_*.png`
- `evaluation/results/plots/hnr_breakdown_*.png` (if hard negatives are available)
- `evaluation/results/plots/run_comparison.png` (compare mode)
- `evaluation/results/metrics_report.csv` (append-only summary table)

## Dataset Notes

Each dataset item needs these core fields:
- `id`
- `relevant_ids`

Chatbot items typically include:
- `query`
- `category` (needed for category breakdown plot)

Home items typically include:
- `description`
- `health_conditions`
- `interests`
- `goals`
- `service_history_ids`

Optional fields for richer metrics:
- `hard_negative_ids` for `HNR@K`
- `relevance_grades` for graded `NDCG_G@K`

## Regenerating Baseline Datasets

To regenerate baseline evaluation data from `data/raw/services.json`:

```powershell
python evaluation/datasets/generate_baseline.py
```

This recreates:
- `evaluation/datasets/chatbot_eval.json`
- `evaluation/datasets/home_eval.json`

## Important Behavior: Auto-Build Eval Collection

Both evaluators check whether the selected Chroma collection overlaps with dataset `relevant_ids`.
If IDs are missing/incompatible, they automatically build and use:
- `healytics_eval_collection`

Source used for auto-build:
- `data/raw/services.json`

This prevents false 0.0 metrics caused by ID mismatch between dataset and vector DB.

## Troubleshooting

- Metrics are all near zero:
  - Confirm dataset IDs match the collection IDs.
  - Let evaluator auto-build `healytics_eval_collection`, or point `--collection` to a compatible one.

- Category breakdown plot is empty:
  - The run has no `category` in predictions (plot only works with category labels).

- HNR plot is empty:
  - Dataset/run lacks `hard_negative_ids` so `HNR@K` is unavailable.

- No run found during analysis:
  - Run an evaluator first, or pass `--run <path-to-run.json>`.

- LLM synthetic generation script fails intentionally:
  - `evaluation/scripts/generate_data.py` is a template and raises `NotImplementedError` until implemented.

## Typical Workflow

```text
1) (Optional) regenerate datasets
2) run chatbot/home evaluation
3) analyze latest run or compare multiple runs
4) inspect plots + metrics_report.csv
5) iterate model/retrieval settings and repeat
```
