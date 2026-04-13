import json
import re
from typing import Any, Dict, Optional


JUDGE_PROMPT = """You are a fair, lenient evaluator. Prefer partial credit: nếu câu trả lời nhìn chung đúng hoặc hợp lý so với ground truth thì cho điểm cao; khác từ ngữ nhỏ, thiếu chi tiết phụ, hoặc diễn đạt khác nhưng không sai nghĩa thì không trừ mạnh.

Given:
- Question
- Context
- Answer
- Ground truth

Score each metric in [0, 1]:
- Faithfulness: answer được context hỗ trợ; nếu có thêm suy luận nhẹ nhưng không mâu thuẫn context thì vẫn có thể cao.
- Correctness: answer phù hợp nghĩa với ground truth (không cần khớp từng chữ).
- Context Relevance: context có giúp trả lời câu hỏi (dù không hoàn hảo vẫn có thể điểm khá).

Return JSON only with keys: faithfulness, correctness, context_relevance.

Question:
{question}

Context:
{context}

Answer:
{answer}

Ground truth:
{ground_truth}
"""


def _extract_json_object(text: str) -> Optional[Dict[str, Any]]:
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


def judge_sample(llm, question: str, context: str, answer: str, ground_truth: str) -> Dict[str, float]:
    prompt = JUDGE_PROMPT.format(
        question=question,
        context=context,
        answer=answer,
        ground_truth=ground_truth,
    )

    raw = llm.invoke(prompt) if hasattr(llm, "invoke") else llm(prompt)
    if not isinstance(raw, str):
        raw = str(raw)

    data = _extract_json_object(raw) or {}

    def _to_float(x: Any) -> float:
        try:
            v = float(x)
        except Exception:
            v = 0.0
        if v < 0.0:
            return 0.0
        if v > 1.0:
            return 1.0
        return v

    return {
        "faithfulness": _to_float(data.get("faithfulness", 0.0)),
        "correctness": _to_float(data.get("correctness", 0.0)),
        "context_relevance": _to_float(data.get("context_relevance", 0.0)),
    }

