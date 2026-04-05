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

from __future__ import annotations

import argparse
import json
import os
import random
import re
import sys
import time
from typing import Any, Dict, List

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
        obj = json.loads(text[start:end + 1])
        if isinstance(obj, dict):
            return obj

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
    n_min: int = 2,
    n_max: int = 4,
) -> List[str]:
    """Sample hard negatives from different categories.

    This avoids penalizing semantically-close services within the same category
    as false positives during baseline evaluation.
    """
    pool: List[str] = []
    for cat, ids in cat_to_ids.items():
        if cat != category:
            pool.extend([sid for sid in ids if sid != service_id])

    if not pool:
        return []
    n = min(random.randint(n_min, n_max), len(pool))
    return random.sample(pool, n)


def _sample_grade1_relevant(
    service_id: str,
    category: str,
    cat_to_ids: Dict[str, List[str]],
    excluded: List[str],
    max_items: int = 2,
) -> List[str]:
    """Sample secondary relevant IDs (grade=1) from same category."""
    pool = [
        sid
        for sid in cat_to_ids.get(category, [])
        if sid != service_id and sid not in excluded
    ]
    if not pool:
        return []
    n = min(random.randint(0, max_items), len(pool))
    if n == 0:
        return []
    return random.sample(pool, n)


def _chatbot_prompt_for_service(service: Dict[str, Any], per_service: int) -> str:
    """Prompt LLM to generate natural chatbot queries for one service."""
    tags = ", ".join(service.get("tags", []))
    return f"""Bạn là một chuyên gia đánh giá hệ thống tìm kiếm (Search Evaluator).
Nhiệm vụ của bạn là đóng vai các nhóm người dùng khác nhau (ví dụ: mẹ bỉm sữa, nhân viên văn phòng, sinh viên, người lớn tuổi, vận động viên) để đặt câu hỏi tìm kiếm trên một chatbot chăm sóc sức khỏe.

Thông tin dịch vụ đích (Kết quả mong muốn chatbot trả về):
- Tên dịch vụ: {service.get('name', '')}
- Danh mục: {service.get('category', '')}
- Tags: {tags}
- Mô tả: {service.get('description', '')}

Yêu cầu bắt buộc:
1. Tạo ra ĐÚNG {per_service} câu truy vấn (queries) hoàn toàn khác nhau về văn phong và bối cảnh.
2. Ngôn ngữ phải tự nhiên, đời thường, có thể dùng tiếng lóng hoặc từ đồng nghĩa của người Việt (vd: "ad ơi", "cho hỏi", "dạo này hay bị...").
3. KHÔNG BÊ NGUYÊN tên dịch vụ vào câu hỏi. Hãy hỏi về "vấn đề", "triệu chứng" (pain points) hoặc "mục tiêu" (goals) mà dịch vụ này có thể giải quyết.

Trả về JSON đúng schema sau (không có thêm text nào khác):
{{
  "queries": ["câu hỏi 1", "câu hỏi 2", "..."]
}}
"""


def _home_prompt_for_service(service: Dict[str, Any], per_service: int) -> str:
    """Prompt LLM to generate realistic home profile descriptions."""
    tags = ", ".join(service.get("tags", []))
    return f"""Bạn là hệ thống phân tích hành vi người dùng (User Profiler).
Hãy tạo ra {per_service} hồ sơ khách hàng (user profile) ĐA DẠNG và CHÂN THỰC, sao cho dịch vụ dưới đây là GỢI Ý PHÙ HỢP NHẤT dành cho họ.

Thông tin dịch vụ đích:
- Tên dịch vụ: {service.get('name', '')}
- Danh mục: {service.get('category', '')}
- Tags: {tags}
- Mô tả: {service.get('description', '')}

Yêu cầu cho mỗi Profile:
1. "description": 2-3 câu mô tả hoàn cảnh sống, độ tuổi, nghề nghiệp và khó khăn họ đang gặp phải. Viết mượt mà, hợp logic.
2. "health_conditions": Mảng chứa 1-3 từ khóa NGẮN GỌN về bệnh lý/tình trạng sức khỏe thực tế (vd: "đau vai gáy", "thừa cân", "mất ngủ").
3. "interests": Mảng chứa 1-3 từ khóa về sở thích (vd: "tập tại nhà", "ăn chay", "yoga").
4. "goals": Mảng chứa 1-2 mục tiêu ngắn gọn (vd: "giảm mỡ bụng", "giảm stress").

Trả về JSON schema:
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
) -> List[Dict[str, Any]]:
    """Generate chatbot evaluation items with LLM prompts per service."""
    cat_to_ids = _build_category_index(services)
    rows: List[Dict[str, Any]] = []
    q_idx = 181

    for i, service in enumerate(services, start=1):
        sid = str(service["id"])
        category = str(service.get("category", "unknown"))
        prompt = _chatbot_prompt_for_service(service, per_service)
        payload = call_llm_json(provider, model, api_key, prompt, temperature)

        queries = payload.get("queries", [])
        if not isinstance(queries, list):
            raise ValueError(f"Invalid 'queries' from model for service {sid}")

        # Keep exactly per_service items to control output size.
        queries = [str(q).strip() for q in queries if str(q).strip()][:per_service]
        if len(queries) < per_service:
            raise ValueError(
                f"Model returned {len(queries)} queries for service {sid}; expected {per_service}"
            )

        for q in queries:
            hard_neg = _sample_hard_negatives(sid, category, cat_to_ids)
            grade1 = _sample_grade1_relevant(sid, category, cat_to_ids, excluded=hard_neg)

            relevant_ids = [sid] + grade1
            relevance_grades = {sid: 2}
            for rid in grade1:
                relevance_grades[rid] = 1

            rows.append(
                {
                    "id": f"CB_{q_idx:04d}",
                    "query": q,
                    "relevant_ids": relevant_ids,
                    "hard_negative_ids": hard_neg,
                    "relevance_grades": relevance_grades,
                    "category": category,
                }
            )
            q_idx += 1

        if delay_sec > 0:
            time.sleep(delay_sec)

        print(f"  [chatbot] service {i}/{len(services)} done")

    random.shuffle(rows)
    return rows


def generate_home_profiles(
    services: List[Dict[str, Any]],
    provider: str,
    model: str,
    api_key: str,
    per_service: int,
    temperature: float,
    delay_sec: float,
) -> List[Dict[str, Any]]:
    """Generate home evaluation profiles with LLM prompts per service."""
    cat_to_ids = _build_category_index(services)
    service_ids = [str(s["id"]) for s in services]
    rows: List[Dict[str, Any]] = []
    p_idx = 61

    for i, service in enumerate(services, start=1):
        sid = str(service["id"])
        category = str(service.get("category", "unknown"))
        prompt = _home_prompt_for_service(service, per_service)
        payload = call_llm_json(provider, model, api_key, prompt, temperature)

        profiles = payload.get("profiles", [])
        if not isinstance(profiles, list):
            raise ValueError(f"Invalid 'profiles' from model for service {sid}")

        profiles = profiles[:per_service]
        if len(profiles) < per_service:
            raise ValueError(
                f"Model returned {len(profiles)} profiles for service {sid}; expected {per_service}"
            )

        for prof in profiles:
            desc = str(prof.get("description", "")).strip()
            if not desc:
                desc = f"Nguoi dung dang can dich vu phu hop voi van de {service.get('name', '')}."

            health_conditions = [
                str(x).strip() for x in prof.get("health_conditions", []) if str(x).strip()
            ]
            interests = [
                str(x).strip() for x in prof.get("interests", []) if str(x).strip()
            ]
            goals = [str(x).strip() for x in prof.get("goals", []) if str(x).strip()]

            # Keep schema non-empty and realistic.
            if not health_conditions:
                health_conditions = [str(t) for t in service.get("tags", [])[:1]] or ["cham soc tong quat"]
            if not interests:
                interests = [str(t) for t in service.get("tags", [])[:1]] or ["suc khoe"]
            if not goals:
                goals = ["cai thien suc khoe", "phong ngua bien chung"]

            hard_neg = _sample_hard_negatives(sid, category, cat_to_ids)
            grade1 = _sample_grade1_relevant(sid, category, cat_to_ids, excluded=hard_neg)

            relevant_ids = [sid] + grade1
            relevance_grades = {sid: 2}
            for rid in grade1:
                relevance_grades[rid] = 1

            history_pool = [x for x in service_ids if x != sid]
            history_n = min(2, len(history_pool))
            service_history_ids = random.sample(history_pool, history_n) if history_n > 0 else []

            rows.append(
                {
                    "id": f"HOME_{p_idx:04d}",
                    "description": desc,
                    "health_conditions": health_conditions,
                    "interests": interests,
                    "goals": goals,
                    "service_history_ids": service_history_ids,
                    "relevant_ids": relevant_ids,
                    "hard_negative_ids": hard_neg,
                    "relevance_grades": relevance_grades,
                }
            )
            p_idx += 1

        if delay_sec > 0:
            time.sleep(delay_sec)

        print(f"  [home] service {i}/{len(services)} done")

    random.shuffle(rows)
    return rows


def _resolve_api_key(provider: str, api_key: str | None) -> str:
    """Resolve API key from argument or environment variables."""
    if api_key:
        return api_key
    if provider == "openai":
        val = os.environ.get("OPENAI_API_KEY", "").strip()
        if val:
            return val
        raise ValueError("OPENAI_API_KEY is required for provider=openai")
    if provider == "gemini":
        val = os.environ.get("GEMINI_API_KEY", "").strip()
        if val:
            return val
        raise ValueError("GEMINI_API_KEY is required for provider=gemini")
    raise ValueError(f"Unsupported provider: {provider}")


def _default_model(provider: str) -> str:
    """Return a sensible default model for each provider."""
    if provider == "openai":
        return "gpt-4o-mini"
    if provider == "gemini":
        return "gemini-1.5-flash"
    raise ValueError(f"Unsupported provider: {provider}")


def _save_json(path: str, data: List[Dict[str, Any]]) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def main():
    parser = argparse.ArgumentParser(
        description="Generate synthetic evaluation data with LLMs (OpenAI/Gemini)"
    )
    parser.add_argument(
        "--provider", choices=["openai", "gemini"], default="openai",
        help="LLM provider"
    )
    parser.add_argument(
        "--model", type=str, default=None,
        help="Model name (defaults by provider)"
    )
    parser.add_argument(
        "--api-key", type=str, default=None,
        help="API key (optional; if absent, read from env var)"
    )
    parser.add_argument(
        "--type", choices=["chatbot", "home", "both"], default="both",
        help="Dataset type to generate"
    )
    parser.add_argument(
        "--chatbot-per-service", type=int, default=3,
        help="Number of chatbot queries to generate per service"
    )
    parser.add_argument(
        "--home-per-service", type=int, default=1,
        help="Number of home profiles to generate per service"
    )
    parser.add_argument(
        "--temperature", type=float, default=0.8,
        help="Sampling temperature"
    )
    parser.add_argument(
        "--delay-sec", type=float, default=0.0,
        help="Delay between service calls to avoid rate limiting"
    )
    parser.add_argument(
        "--seed", type=int, default=42,
        help="Random seed for deterministic ID/hard-negative sampling"
    )
    parser.add_argument(
        "--chatbot-output", type=str,
        default=os.path.join(DATASETS_DIR, "chatbot_eval.json"),
        help="Output path for chatbot dataset"
    )
    parser.add_argument(
        "--home-output", type=str,
        default=os.path.join(DATASETS_DIR, "home_eval.json"),
        help="Output path for home dataset"
    )
    args = parser.parse_args()

    random.seed(args.seed)
    provider = args.provider
    model = args.model or _default_model(provider)
    api_key = _resolve_api_key(provider, args.api_key)

    services = load_services()
    print(f"Loaded {len(services)} services from {SERVICES_PATH}")
    print(f"Using provider={provider}, model={model}")

    if args.type in ("chatbot", "both"):
        print("Generating chatbot evaluation dataset with LLM...")
        chatbot_rows = generate_chatbot_queries(
            services=services,
            provider=provider,
            model=model,
            api_key=api_key,
            per_service=args.chatbot_per_service,
            temperature=args.temperature,
            delay_sec=args.delay_sec,
        )
        _save_json(args.chatbot_output, chatbot_rows)
        print(f"Saved {len(chatbot_rows)} chatbot rows -> {args.chatbot_output}")

    if args.type in ("home", "both"):
        print("Generating home evaluation dataset with LLM...")
        home_rows = generate_home_profiles(
            services=services,
            provider=provider,
            model=model,
            api_key=api_key,
            per_service=args.home_per_service,
            temperature=args.temperature,
            delay_sec=args.delay_sec,
        )
        _save_json(args.home_output, home_rows)
        print(f"Saved {len(home_rows)} home rows -> {args.home_output}")

    print("Done.")


if __name__ == "__main__":
    main()
