"""
Evaluation End-to-End cho luồng AI của Healytics.

Nhiệm vụ:
    - Gọi Gateway (POST /generative_ai/stream, SSE) cho từng câu hỏi.
    - Đo chi tiết latency: total, TTFT (time-to-first-token),
      token streaming time, thời gian phát sinh tokens sau first token.
    - Đếm token của câu trả lời để ước lượng chi phí GPU.
    - Ghi nhận sự kiện SSE: token / recommendation / done / error.
    - Gọi Mistral làm judge LLM, chấm điểm 1-5 cho
      Correctness, Helpfulness, Relevance + giải thích.
    - Ghi kết quả từng mẫu ra JSONL (resume được).
    - Tổng hợp kết quả tổng thể (mean, median, p90, p95, p99).

Cách chạy:
    export MISTRAL_API_KEY=...
    python scripts/eval_e2e.py --n 500
    python scripts/eval_e2e.py --n 20 --user-id <uuid>
    python scripts/eval_e2e.py --resume

Có hai chế độ kết nối:
    - gateway   : gọi Gateway (E2E thật sự)  -> DEFAULT
    - chatbot   : gọi trực tiếp chatbot-service (/chat/stream), bỏ qua recommender/ner
                  -> fallback khi Gateway không chạy được.

Đầu ra:
    - results/e2e_results.jsonl     : từng mẫu (append-only)
    - results/e2e_summary.json      : tổng hợp metrics
"""

from __future__ import annotations

import argparse
import asyncio
import json
import os
import re
import statistics
import sys
import time
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple
from uuid import uuid4

import httpx

ROOT = Path(__file__).resolve().parent.parent
DATA_PATH = ROOT / "data" / "eval_e2e_dataset.json"
RESULTS_JSONL = ROOT / "results" / "e2e_results.jsonl"
SUMMARY_JSON  = ROOT / "results" / "e2e_summary.json"
LOG_PATH      = ROOT / "logs" / "eval_e2e.log"

GATEWAY_URL = os.getenv("GATEWAY_URL", "http://localhost:9000")
CHATBOT_URL = os.getenv("CHATBOT_URL", "http://localhost:5000")
MISTRAL_URL = "https://api.mistral.ai/v1/chat/completions"
MISTRAL_MODEL = os.getenv("MISTRAL_MODEL", "mistral-small-latest")
MISTRAL_API_KEY = os.getenv("MISTRAL_API_KEY", "").strip()

# -----------------------------------------------------------
# Cost model (GPU A5000 @ $0.27/hour, theo yêu cầu người dùng)
# -----------------------------------------------------------
GPU_USD_PER_HOUR = 0.27

# -----------------------------------------------------------
# Judge prompt (theo format người dùng yêu cầu)
# -----------------------------------------------------------
JUDGE_PROMPT = """You are an evaluator for a healthcare chatbot.

Given:
- User query
- Ground truth answer
- Model answer

Evaluate the model answer based on:

1. Correctness (Is the answer factually correct?)
2. Helpfulness (Is the answer useful to the user?)
3. Relevance (Does the answer address the query?)

Score each from 1 to 5.

Also provide a brief explanation.

Return JSON only, exactly in this schema:
{{
  "correctness": <int 1-5>,
  "helpfulness": <int 1-5>,
  "relevance":   <int 1-5>,
  "explanation": "<short explanation in Vietnamese>"
}}

User query:
{query}

Ground truth:
{ground_truth}

Model answer:
{answer}
"""

# -----------------------------------------------------------
# LOGGING
# -----------------------------------------------------------
def log(msg: str) -> None:
    LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    ts = time.strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line, flush=True)
    with LOG_PATH.open("a", encoding="utf-8") as f:
        f.write(line + "\n")

# -----------------------------------------------------------
# SSE PARSER (đọc stream từ Gateway)
# -----------------------------------------------------------
async def stream_gateway(
    client: httpx.AsyncClient,
    user_id: str,
    message: str,
    conversation_id: Optional[str],
    top_k: int = 3,
) -> Dict[str, Any]:
    """
    Gọi Gateway POST /generative_ai/stream, đọc SSE từng sự kiện,
    đo chi tiết các mốc thời gian.
    """
    payload = {
        "user_id": user_id,
        "message": message,
        "top_k": top_k,
    }
    if conversation_id:
        payload["conversation_id"] = conversation_id

    t0 = time.perf_counter()
    first_token_at: Optional[float] = None
    last_token_at: Optional[float] = None
    t_done: Optional[float] = None

    tokens: List[str] = []
    recommendations: List[Dict[str, Any]] = []
    error_msg: Optional[str] = None
    got_done = False

    try:
        async with client.stream(
            "POST",
            f"{GATEWAY_URL}/generative_ai/stream",
            json=payload,
            timeout=httpx.Timeout(connect=10.0, read=300.0, write=10.0, pool=10.0),
            headers={"Accept": "text/event-stream"},
        ) as resp:
            if resp.status_code != 200:
                txt = (await resp.aread()).decode(errors="replace")
                return {
                    "ok": False,
                    "http_status": resp.status_code,
                    "error": f"HTTP {resp.status_code}: {txt[:300]}",
                    "total_latency_s": time.perf_counter() - t0,
                }

            current_event = None
            async for raw_line in resp.aiter_lines():
                if raw_line is None:
                    continue
                line = raw_line.strip("\r")
                if line.startswith("event:"):
                    current_event = line[6:].strip()
                    continue
                if line.startswith("data:"):
                    data_str = line[5:].strip()
                    if not data_str:
                        continue
                    try:
                        payload_obj = json.loads(data_str)
                    except Exception:
                        continue
                    if current_event == "token":
                        if first_token_at is None:
                            first_token_at = time.perf_counter()
                        last_token_at = time.perf_counter()
                        tokens.append(payload_obj.get("text", ""))
                    elif current_event == "recommendation":
                        recommendations = payload_obj.get("recommendations", []) or []
                    elif current_event == "done":
                        t_done = time.perf_counter()
                        got_done = True
                    elif current_event == "error":
                        error_msg = payload_obj.get("message", "unknown")

    except httpx.TimeoutException as e:
        return {
            "ok": False,
            "error": f"Timeout: {e}",
            "total_latency_s": time.perf_counter() - t0,
        }
    except Exception as e:
        return {
            "ok": False,
            "error": f"Exception: {type(e).__name__}: {e}",
            "total_latency_s": time.perf_counter() - t0,
        }

    t_end = time.perf_counter()
    answer = "".join(tokens).strip()

    return {
        "ok": error_msg is None and got_done and len(answer) > 0,
        "answer": answer,
        "recommendations_count": len(recommendations),
        "recommendations": recommendations,
        "total_latency_s": t_end - t0,
        "ttft_s": (first_token_at - t0) if first_token_at else None,
        "streaming_s": (last_token_at - first_token_at) if first_token_at and last_token_at else None,
        "done_overhead_s": (t_done - last_token_at) if t_done and last_token_at else None,
        "num_tokens_raw": len(tokens),
        "error": error_msg,
    }


async def stream_chatbot_only(
    client: httpx.AsyncClient,
    message: str,
) -> Dict[str, Any]:
    """
    Fallback: gọi trực tiếp chatbot-service /chat/stream (text/plain stream).
    Chỉ dùng khi Gateway không sẵn sàng.
    """
    payload = {"history": "", "services": "", "question": message}
    t0 = time.perf_counter()
    first_token_at: Optional[float] = None
    last_token_at: Optional[float] = None
    chunks: List[str] = []
    try:
        async with client.stream(
            "POST",
            f"{CHATBOT_URL}/chat/stream",
            json=payload,
            timeout=httpx.Timeout(connect=10.0, read=300.0, write=10.0, pool=10.0),
        ) as resp:
            if resp.status_code != 200:
                txt = (await resp.aread()).decode(errors="replace")
                return {
                    "ok": False,
                    "error": f"HTTP {resp.status_code}: {txt[:300]}",
                    "total_latency_s": time.perf_counter() - t0,
                }
            async for chunk in resp.aiter_text():
                if not chunk:
                    continue
                if first_token_at is None:
                    first_token_at = time.perf_counter()
                last_token_at = time.perf_counter()
                chunks.append(chunk)
    except Exception as e:
        return {
            "ok": False,
            "error": f"Exception: {type(e).__name__}: {e}",
            "total_latency_s": time.perf_counter() - t0,
        }
    t_end = time.perf_counter()
    answer = "".join(chunks).strip()
    return {
        "ok": len(answer) > 0,
        "answer": answer,
        "recommendations_count": 0,
        "recommendations": [],
        "total_latency_s": t_end - t0,
        "ttft_s": (first_token_at - t0) if first_token_at else None,
        "streaming_s": (last_token_at - first_token_at) if first_token_at and last_token_at else None,
        "done_overhead_s": None,
        "num_tokens_raw": len(chunks),
        "error": None,
    }

# -----------------------------------------------------------
# Token counter (word-based tiếng Việt, ổn định cho cost mục đích báo cáo)
# -----------------------------------------------------------
def count_words(text: str) -> int:
    if not text:
        return 0
    return len(re.findall(r"\S+", text))

# -----------------------------------------------------------
# Mistral Judge
# -----------------------------------------------------------
async def judge_with_mistral(
    client: httpx.AsyncClient,
    query: str,
    ground_truth: str,
    answer: str,
) -> Dict[str, Any]:
    if not MISTRAL_API_KEY:
        return {"ok": False, "error": "MISTRAL_API_KEY missing"}

    prompt = JUDGE_PROMPT.format(query=query, ground_truth=ground_truth, answer=answer)

    body = {
        "model": MISTRAL_MODEL,
        "messages": [{"role": "user", "content": prompt}],
        "temperature": 0.0,
        "max_tokens": 400,
    }
    headers = {
        "Authorization": f"Bearer {MISTRAL_API_KEY}",
        "Content-Type": "application/json",
    }
    t0 = time.perf_counter()
    try:
        resp = await client.post(MISTRAL_URL, json=body, headers=headers, timeout=60.0)
    except Exception as e:
        return {"ok": False, "error": f"Mistral exception: {type(e).__name__}: {e}",
                "judge_latency_s": time.perf_counter() - t0}
    judge_latency = time.perf_counter() - t0
    if resp.status_code != 200:
        return {"ok": False, "error": f"Mistral HTTP {resp.status_code}: {resp.text[:300]}",
                "judge_latency_s": judge_latency}
    try:
        content = resp.json()["choices"][0]["message"]["content"]
    except Exception as e:
        return {"ok": False, "error": f"Bad Mistral response: {e}",
                "judge_latency_s": judge_latency}

    # Extract JSON object
    def _extract_json(text: str) -> Optional[Dict[str, Any]]:
        if not text:
            return None
        text = text.strip()
        try:
            return json.loads(text)
        except Exception:
            pass
        m = re.search(r"\{[\s\S]*\}", text)
        if not m:
            return None
        try:
            return json.loads(m.group(0))
        except Exception:
            return None

    parsed = _extract_json(content) or {}

    def _clip15(x: Any) -> Optional[int]:
        try:
            v = int(round(float(x)))
            return max(1, min(5, v))
        except Exception:
            return None

    return {
        "ok": True,
        "correctness": _clip15(parsed.get("correctness")),
        "helpfulness": _clip15(parsed.get("helpfulness")),
        "relevance":   _clip15(parsed.get("relevance")),
        "explanation": (parsed.get("explanation") or "")[:500],
        "raw": content[:800],
        "judge_latency_s": judge_latency,
    }

# -----------------------------------------------------------
# MAIN EVAL LOOP
# -----------------------------------------------------------
async def evaluate(
    samples: List[Dict[str, Any]],
    user_id: str,
    mode: str,
    judge_every: bool,
    resume: bool,
    limit: Optional[int],
) -> None:
    done_ids = set()
    if resume and RESULTS_JSONL.exists():
        with RESULTS_JSONL.open("r", encoding="utf-8") as f:
            for line in f:
                try:
                    d = json.loads(line)
                    done_ids.add(d.get("id"))
                except Exception:
                    continue
        log(f"Resume: already completed {len(done_ids)} samples, will skip them.")

    to_run = [s for s in samples if s["id"] not in done_ids]
    if limit:
        to_run = to_run[:limit]

    RESULTS_JSONL.parent.mkdir(parents=True, exist_ok=True)

    # Warm up (không tính vào số liệu) - gửi 1 câu đơn giản
    log(f"Starting evaluation: mode={mode}, samples={len(to_run)}, judge={judge_every}, gateway={GATEWAY_URL}")

    async with httpx.AsyncClient() as client:
        for idx, s in enumerate(to_run, 1):
            t_start = time.perf_counter()
            if mode == "gateway":
                res = await stream_gateway(client, user_id, s["user_query"], conversation_id=None, top_k=3)
            else:
                res = await stream_chatbot_only(client, s["user_query"])

            answer = (res.get("answer") or "")
            out_tokens = count_words(answer)
            in_tokens = count_words(s["user_query"])
            cost_usd = (res.get("total_latency_s") or 0.0) / 3600.0 * GPU_USD_PER_HOUR

            judge_info: Dict[str, Any] = {"ok": False, "skipped": True}
            if judge_every and res.get("ok") and answer:
                judge_info = await judge_with_mistral(client, s["user_query"], s["ground_truth"], answer)

            record = {
                "id": s["id"],
                "category": s["category"],
                "needs_recommendation": s["needs_recommendation"],
                "has_location": s["has_location"],
                "user_query": s["user_query"],
                "ground_truth": s["ground_truth"],
                "mode": mode,
                "answer": answer,
                "answer_word_count": out_tokens,
                "query_word_count": in_tokens,
                "stream": {
                    "ok": res.get("ok"),
                    "error": res.get("error"),
                    "total_latency_s": res.get("total_latency_s"),
                    "ttft_s": res.get("ttft_s"),
                    "streaming_s": res.get("streaming_s"),
                    "done_overhead_s": res.get("done_overhead_s"),
                    "num_stream_chunks": res.get("num_tokens_raw"),
                    "recommendations_count": res.get("recommendations_count"),
                },
                "cost_usd_gpu_a5000": cost_usd,
                "judge": judge_info,
                "wall_time_s": time.perf_counter() - t_start,
            }

            with RESULTS_JSONL.open("a", encoding="utf-8") as f:
                f.write(json.dumps(record, ensure_ascii=False) + "\n")

            ok_str = "OK " if res.get("ok") else "ERR"
            ttft_str = f"{res.get('ttft_s'):.2f}s" if res.get("ttft_s") else "  -  "
            tot_str  = f"{res.get('total_latency_s'):.2f}s" if res.get("total_latency_s") else "  -  "
            j_c = judge_info.get("correctness") if judge_info.get("ok") else "-"
            j_h = judge_info.get("helpfulness") if judge_info.get("ok") else "-"
            j_r = judge_info.get("relevance")   if judge_info.get("ok") else "-"
            log(f"[{idx:>3}/{len(to_run)}] {ok_str} {s['id']:<14s} cat={s['category'][:22]:<22s} "
                f"TTFT={ttft_str} TOT={tot_str} tok={out_tokens:>3d} C/H/R={j_c}/{j_h}/{j_r}")

    log("Evaluation finished.")

# -----------------------------------------------------------
# SUMMARY
# -----------------------------------------------------------
def percentile(data: List[float], q: float) -> float:
    if not data:
        return 0.0
    s = sorted(data)
    k = (len(s) - 1) * q
    f = int(k)
    c = min(f + 1, len(s) - 1)
    if f == c:
        return s[f]
    return s[f] + (s[c] - s[f]) * (k - f)


def summarize(jsonl_path: Path) -> Dict[str, Any]:
    rows: List[Dict[str, Any]] = []
    with jsonl_path.open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            try:
                rows.append(json.loads(line))
            except Exception:
                continue
    if not rows:
        return {"n": 0}

    ok_rows = [r for r in rows if r.get("stream", {}).get("ok")]
    judge_rows = [r for r in ok_rows if r.get("judge", {}).get("ok")]

    def _col(rows_, path: str) -> List[float]:
        vals = []
        for r in rows_:
            cur = r
            for p in path.split("."):
                cur = (cur or {}).get(p) if isinstance(cur, dict) else None
            if isinstance(cur, (int, float)):
                vals.append(float(cur))
        return vals

    def _stat(vals: List[float]) -> Dict[str, float]:
        if not vals:
            return {"n": 0}
        return {
            "n": len(vals),
            "mean":   statistics.mean(vals),
            "median": statistics.median(vals),
            "stdev":  statistics.pstdev(vals),
            "min":    min(vals),
            "max":    max(vals),
            "p50":    percentile(vals, 0.5),
            "p90":    percentile(vals, 0.9),
            "p95":    percentile(vals, 0.95),
            "p99":    percentile(vals, 0.99),
        }

    summary = {
        "n_total": len(rows),
        "n_ok": len(ok_rows),
        "n_err": len(rows) - len(ok_rows),
        "n_judged": len(judge_rows),
        "latency": {
            "total":     _stat(_col(ok_rows, "stream.total_latency_s")),
            "ttft":      _stat(_col(ok_rows, "stream.ttft_s")),
            "streaming": _stat(_col(ok_rows, "stream.streaming_s")),
        },
        "cost": _stat(_col(ok_rows, "cost_usd_gpu_a5000")),
        "answer_word_count": _stat(_col(ok_rows, "answer_word_count")),
        "judge": {
            "correctness": _stat(_col(judge_rows, "judge.correctness")),
            "helpfulness": _stat(_col(judge_rows, "judge.helpfulness")),
            "relevance":   _stat(_col(judge_rows, "judge.relevance")),
        },
        "by_category": {},
    }

    # Per-category stats
    cats = sorted(set(r["category"] for r in rows))
    for c in cats:
        sub_all = [r for r in rows if r["category"] == c]
        sub_ok = [r for r in sub_all if r.get("stream", {}).get("ok")]
        sub_j  = [r for r in sub_ok if r.get("judge", {}).get("ok")]
        summary["by_category"][c] = {
            "n_total": len(sub_all),
            "n_ok": len(sub_ok),
            "n_judged": len(sub_j),
            "latency_total": _stat(_col(sub_ok, "stream.total_latency_s")),
            "ttft":          _stat(_col(sub_ok, "stream.ttft_s")),
            "answer_words":  _stat(_col(sub_ok, "answer_word_count")),
            "correctness":   _stat(_col(sub_j, "judge.correctness")),
            "helpfulness":   _stat(_col(sub_j, "judge.helpfulness")),
            "relevance":     _stat(_col(sub_j, "judge.relevance")),
        }

    return summary


# -----------------------------------------------------------
# CLI
# -----------------------------------------------------------
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--n", type=int, default=500, help="Max samples to run")
    parser.add_argument("--mode", choices=["gateway", "chatbot"], default="gateway")
    parser.add_argument("--user-id", default=None, help="UUID user_id (required if mode=gateway)")
    parser.add_argument("--no-judge", action="store_true", help="Skip Mistral judge")
    parser.add_argument("--resume", action="store_true", help="Resume from existing results")
    parser.add_argument("--summary-only", action="store_true", help="Don't run, just summarize jsonl")
    args = parser.parse_args()

    if args.summary_only:
        summary = summarize(RESULTS_JSONL)
        SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
        print(json.dumps(summary, ensure_ascii=False, indent=2))
        return

    with DATA_PATH.open("r", encoding="utf-8") as f:
        samples = json.load(f)

    samples = sorted(samples, key=lambda s: s.get("order", 0))

    user_id = args.user_id or str(uuid4())

    asyncio.run(evaluate(
        samples=samples,
        user_id=user_id,
        mode=args.mode,
        judge_every=not args.no_judge,
        resume=args.resume,
        limit=args.n,
    ))

    summary = summarize(RESULTS_JSONL)
    SUMMARY_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    log(f"Summary written to {SUMMARY_JSON}")


if __name__ == "__main__":
    main()
