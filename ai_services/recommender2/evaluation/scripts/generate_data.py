"""LLM-driven synthetic dataset generation for evaluation.

This script generates natural-language evaluation datasets for:
- chatbot retrieval (`chatbot_eval.json`)
- home profile retrieval (`home_eval.json`)

Unlike rule-based template filling, this generator uses an LLM to produce
realistic Vietnamese phrasing and user intent variation.

Usage examples (from recommender2/ root):
    python -m evaluation.scripts.generate_data --provider openai --type both
    python -m evaluation.scripts.generate_data --provider gemini --type chatbot
    python -m evaluation.scripts.generate_data --provider openai --chatbot-per-service 5

Environment variables:
    OPENAI_API_KEY   (for --provider openai)
    GEMINI_API_KEY   (for --provider gemini)
"""

import argparse
import json
import os
import random
import re
import sys
import time
import hashlib
from typing import Any, Dict, List
from concurrent.futures import ThreadPoolExecutor, as_completed
from tenacity import retry, stop_after_attempt, wait_exponential

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.insert(0, ROOT_DIR)

from config import settings


# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
EVAL_DIR = os.path.join(ROOT_DIR, "evaluation")
DATASETS_DIR = os.path.join(EVAL_DIR, "datasets")
SERVICES_PATH = settings.SERVICE_JSON_PATH


def load_services() -> List[Dict[str, Any]]:
    """Load the services catalog."""
    with open(SERVICES_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def _extract_json_payload(text: str) -> Dict[str, Any]:
    """Extract and parse JSON object from a model response string."""
    text = text.strip()
    if text.startswith("```"):
        text = re.sub(r"^```(?:json)?", "", text).strip()
        text = re.sub(r"```$", "", text).strip()

    # Try direct parse first.
    try:
        obj = json.loads(text)
        if isinstance(obj, dict):
            return obj
    except Exception:
        pass

    # Fallback: extract first {...} block.
    start = text.find("{")
    end = text.rfind("}")
    if start >= 0 and end > start:
        try:
            obj = json.loads(text[start:end + 1])
            if isinstance(obj, dict):
                return obj
        except Exception:
            pass

    raise ValueError("Model response does not contain a valid JSON object")


def _call_openai_json(
    model: str,
    api_key: str,
    prompt: str,
    temperature: float,
) -> Dict[str, Any]:
    """Call OpenAI Chat Completions API and return parsed JSON."""
    try:
        from openai import OpenAI
    except ImportError as e:
        raise RuntimeError(
            "Missing dependency 'openai'. Install it with: pip install openai"
        ) from e

    client = OpenAI(api_key=api_key)
    response = client.chat.completions.create(
        model=model,
        temperature=temperature,
        messages=[
            {
                "role": "system",
                "content": (
                    "You generate high-quality Vietnamese synthetic data for "
                    "healthcare search evaluation. Always return strict JSON only."
                ),
            },
            {"role": "user", "content": prompt},
        ],
        response_format={"type": "json_object"},
    )
    content = response.choices[0].message.content or "{}"
    return _extract_json_payload(content)


def _call_gemini_json(
    model: str,
    api_key: str,
    prompt: str,
    temperature: float,
) -> Dict[str, Any]:
    """Call Gemini API and return parsed JSON."""
    try:
        import google.generativeai as genai
    except ImportError as e:
        raise RuntimeError(
            "Missing dependency 'google-generativeai'. Install: pip install google-generativeai"
        ) from e

    genai.configure(api_key=api_key)
    gen_model = genai.GenerativeModel(model)
    response = gen_model.generate_content(
        prompt,
        generation_config={
            "temperature": temperature,
            "response_mime_type": "application/json",
        },
    )

    text = getattr(response, "text", "") or ""
    return _extract_json_payload(text)


@retry(stop=stop_after_attempt(5), wait=wait_exponential(multiplier=1, min=2, max=10))
def call_llm_json(
    provider: str,
    model: str,
    api_key: str,
    prompt: str,
    temperature: float,
) -> Dict[str, Any]:
    """Dispatch to the selected provider and return parsed JSON."""
    if provider == "openai":
        return _call_openai_json(model, api_key, prompt, temperature)
    if provider == "gemini":
        return _call_gemini_json(model, api_key, prompt, temperature)
    raise ValueError(f"Unsupported provider: {provider}")


def _build_category_index(services: List[Dict[str, Any]]) -> Dict[str, List[str]]:
    """Map category to service IDs."""
    cat_to_ids: Dict[str, List[str]] = {}
    for sv in services:
        cat = str(sv.get("category", "unknown"))
        sid = str(sv["id"])
        cat_to_ids.setdefault(cat, []).append(sid)
    return cat_to_ids


def _sample_hard_negatives(
    service_id: str,
    category: str,
    cat_to_ids: Dict[str, List[str]],
    excluded: List[str] = None,
    n_min: int = 2,
    n_max: int = 4,
    rng: random.Random = None,
) -> List[str]:
    """Sample hard negatives from the SAME category."""
    excluded = excluded or []
    pool: List[str] = [
        sid
        for item_cat, ids in cat_to_ids.items()
        if item_cat == category
        for sid in ids
        if sid != service_id and sid not in excluded
    ]

    if not pool:
        return []
    rng = rng or random
    n = min(rng.randint(n_min, n_max), len(pool))
    return rng.sample(pool, n)


def _sample_grade1_relevant(
    service_id: str,
    category: str,
    cat_to_ids: Dict[str, List[str]],
    excluded: List[str],
    max_items: int = 2,
    rng: random.Random = None,
) -> List[str]:
    """Sample secondary relevant IDs (grade=1) from same category."""
    pool = [
        sid
        for sid in cat_to_ids.get(category, [])
        if sid != service_id and sid not in excluded
    ]
    if not pool:
        return []
    rng = rng or random
    n = min(rng.randint(1, max_items), len(pool))
    return rng.sample(pool, n)


def _chatbot_prompt_for_service(service: Dict[str, Any], per_service: int) -> str:
    """Prompt LLM to generate natural chatbot queries for one service."""
    tags = ", ".join(service.get("tags", []))
    return f"""Bạn là một chuyên gia đánh giá hệ thống tìm kiếm (Search Evaluator).
Nhiệm vụ của bạn là đóng vai các nhóm người dùng khác nhau để đặt câu hỏi tìm kiếm trên một chatbot chăm sóc sức khỏe.

Thông tin dịch vụ đích:
- Tên dịch vụ: {service.get('name', '')}
- Danh mục: {service.get('category', ' ')}
- Tags: {tags}
- Mô tả: {service.get('description', '')}

Yêu cầu:
1. Tạo ra ĐÚNG {per_service} câu truy vấn (queries) hoàn toàn khác nhau.
2. Ngôn ngữ phải tự nhiên, đời thường.
3. KHÔNG BÊ NGUYÊN tên dịch vụ vào câu hỏi.

Trả về JSON:
{{
  "queries": ["câu hỏi 1", "câu hỏi 2", "..."]
}}
"""


def _home_prompt_for_service(service: Dict[str, Any], per_service: int) -> str:
    """Prompt LLM to generate realistic home profile descriptions."""
    tags = ", ".join(service.get("tags", []))
    return f"""Bạn là chuyên gia tạo hồ sơ người dùng cho hệ thống gợi ý.

Dịch vụ đích:
- Tên: {service.get('name', '')}
- Danh mục: {service.get('category', ' ')}
- Tags: {tags}
- Mô tả: {service.get('description', '')}

Tạo {per_service} hồ sơ khách hàng (description, health_conditions, interests, goals).
Các từ khóa PHẢI liên quan trực tiếp đến dịch vụ này.

Trả về JSON:
{{
    "profiles": [
        {{
            "description": "...",
            "health_conditions": ["..."],
            "interests": ["..."],
            "goals": ["..."]
        }}
    ]
}}
"""


def generate_chatbot_queries(
    services: List[Dict[str, Any]],
    provider: str,
    model: str,
    api_key: str,
    per_service: int,
    temperature: float,
    delay_sec: float,
    seed: int = 42,
) -> List[Dict[str, Any]]:
    """Generate chatbot evaluation items with LLM prompts per service."""
    cat_to_ids = _build_category_index(services)
    
    def process_service(sv: Dict[str, Any], idx: int) -> tuple[int, List[Dict[str, Any]]]:
        sid = str(sv["id"])
        category = str(sv.get("category", "unknown"))
        rng = random.Random(int(hashlib.md5(sid.encode()).hexdigest(), 16))
        
        grade1 = _sample_grade1_relevant(sid, category, cat_to_ids, excluded=[], rng=rng)
        hard_neg = _sample_hard_negatives(sid, category, cat_to_ids, excluded=grade1, rng=rng)
        
        prompt = _chatbot_prompt_for_service(sv, per_service)
        payload = call_llm_json(provider, model, api_key, prompt, temperature)
        queries = payload.get("queries", [])[:per_service]

        local_rows = []
        for q in queries:
            relevant_ids = [sid] + grade1
            relevance_grades = {sid: 2}
            for rid in grade1:
                relevance_grades[rid] = 1

            local_rows.append({
                "query": str(q).strip(),
                "relevant_ids": relevant_ids,
                "hard_negative_ids": hard_neg,
                "relevance_grades": relevance_grades,
                "category": category,
            })

        if delay_sec > 0:
            time.sleep(delay_sec)
        print(f"  [chatbot] service {idx}/{len(services)} done")
        return idx, local_rows

    results_unordered = []
    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = {executor.submit(process_service, sv, i): i for i, sv in enumerate(services, 1)}
        for future in as_completed(futures):
            try:
                results_unordered.append(future.result())
            except Exception as e:
                print(f"  ❌ Chatbot service failed: {e}")

    results_unordered.sort(key=lambda x: x[0])
    rows = []
    q_idx = 1
    for _, local_rows in results_unordered:
        for r in local_rows:
            r["id"] = f"CB_{q_idx:04d}"
            rows.append(r)
            q_idx += 1

    random.Random(seed).shuffle(rows)
    return rows


def generate_home_profiles(
    services: List[Dict[str, Any]],
    provider: str,
    model: str,
    api_key: str,
    per_service: int,
    temperature: float,
    delay_sec: float,
    seed: int = 42,
) -> List[Dict[str, Any]]:
    """Generate home evaluation profiles with LLM prompts per service."""
    cat_to_ids = _build_category_index(services)
    
    def process_service(sv: Dict[str, Any], idx: int) -> tuple[int, List[Dict[str, Any]]]:
        sid = str(sv["id"])
        category = str(sv.get("category", "unknown"))
        rng = random.Random(int(hashlib.md5(sid.encode()).hexdigest(), 16))

        grade1 = _sample_grade1_relevant(sid, category, cat_to_ids, excluded=[], rng=rng)
        hard_neg = _sample_hard_negatives(sid, category, cat_to_ids, excluded=grade1, rng=rng)

        prompt = _home_prompt_for_service(sv, per_service)
        payload = call_llm_json(provider, model, api_key, prompt, temperature)
        profiles = payload.get("profiles", [])[:per_service]

        local_rows = []
        for prof in profiles:
            desc = str(prof.get("description", "")).strip() or f"Cần dịch vụ {sv.get('name', '')}"
            
            h_cond = [str(x).strip() for x in prof.get("health_conditions", []) if str(x).strip()]
            intrs = [str(x).strip() for x in prof.get("interests", []) if str(x).strip()]
            gls = [str(x).strip() for x in prof.get("goals", []) if str(x).strip()]

            if not h_cond: h_cond = [str(t) for t in sv.get("tags", [])[:1]] or ["suc khoe"]
            
            same_cat_pool = [x for x in cat_to_ids.get(category, []) if x != sid and x not in grade1]
            hist_ids = rng.sample(same_cat_pool, min(2, len(same_cat_pool))) if same_cat_pool else []

            local_rows.append({
                "description": desc,
                "health_conditions": h_cond,
                "interests": intrs,
                "goals": gls,
                "service_history_ids": hist_ids,
                "relevant_ids": [sid] + grade1,
                "hard_negative_ids": hard_neg,
                "relevance_grades": {sid: 2, **{rid: 1 for rid in grade1}},
                "category": category,
            })

        if delay_sec > 0:
            time.sleep(delay_sec)
        print(f"  [home] service {idx}/{len(services)} done")
        return idx, local_rows

    results_unordered = []
    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = {executor.submit(process_service, sv, i): i for i, sv in enumerate(services, 1)}
        for future in as_completed(futures):
            try:
                results_unordered.append(future.result())
            except Exception as e:
                print(f"  ❌ Home service failed: {e}")

    results_unordered.sort(key=lambda x: x[0])
    rows = []
    p_idx = 1
    for _, local_rows in results_unordered:
        for r in local_rows:
            r["id"] = f"HM_{p_idx:04d}"
            rows.append(r)
            p_idx += 1

    random.Random(seed).shuffle(rows)
    return rows


def _resolve_api_key(provider: str, api_key: str | None) -> str:
    if api_key: return api_key
    env_map = {"openai": "OPENAI_API_KEY", "gemini": "GEMINI_API_KEY"}
    key = os.environ.get(env_map.get(provider, ""), "").strip()
    if not key: raise ValueError(f"{env_map.get(provider)} is required")
    return key


def _save_json(path: str, data: List[Dict[str, Any]]) -> None:
    if dir_name := os.path.dirname(path):
        os.makedirs(dir_name, exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--provider", choices=["openai", "gemini"], default="openai")
    parser.add_argument("--model", type=str, default=None)
    parser.add_argument("--api-key", type=str, default=None)
    parser.add_argument("--type", choices=["chatbot", "home", "both"], default="both")
    parser.add_argument("--chatbot-per-service", type=int, default=3)
    parser.add_argument("--home-per-service", type=int, default=1)
    parser.add_argument("--temperature", type=float, default=0.8)
    parser.add_argument("--delay-sec", type=float, default=0.0)
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--chatbot-output", type=str, default=os.path.join(DATASETS_DIR, "chatbot_eval.json"))
    parser.add_argument("--home-output", type=str, default=os.path.join(DATASETS_DIR, "home_eval.json"))
    args = parser.parse_args()

    api_key = _resolve_api_key(args.provider, args.api_key)
    model = args.model or ("gpt-4o-mini" if args.provider == "openai" else "gemini-1.5-flash")

    services = load_services()
    print(f"Loaded {len(services)} services. Provider={args.provider}, Model={model}")

    if args.type in ("chatbot", "both"):
        rows = generate_chatbot_queries(services, args.provider, model, api_key, args.chatbot_per_service, args.temperature, args.delay_sec, args.seed)
        _save_json(args.chatbot_output, rows)
        print(f"Saved {len(rows)} chatbot rows -> {args.chatbot_output}")

    if args.type in ("home", "both"):
        rows = generate_home_profiles(services, args.provider, model, api_key, args.home_per_service, args.temperature, args.delay_sec, args.seed)
        _save_json(args.home_output, rows)
        print(f"Saved {len(rows)} home rows -> {args.home_output}")


if __name__ == "__main__":
    main()
