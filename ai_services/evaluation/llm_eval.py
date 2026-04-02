import json
import os
import sys
from dataclasses import dataclass
from typing import Any, Dict, Tuple


# Ensure `import src.*` resolves to rag_langchain/src
EVAL_DIR = os.path.dirname(os.path.abspath(__file__))
RAG_LANGCHAIN_DIR = os.path.abspath(os.path.join(EVAL_DIR, "..", "rag_langchain"))
if RAG_LANGCHAIN_DIR not in sys.path:
    sys.path.insert(0, RAG_LANGCHAIN_DIR)


@dataclass
class OpenAICompatClient:
    base_url: str
    api_key: str
    model: str
    temperature: float = 0.2
    max_tokens: int = 512
    timeout_s: int = 120

    def invoke(self, prompt: str) -> str:
        import requests

        url = self.base_url.rstrip("/") + "/chat/completions"
        headers = {"Content-Type": "application/json", "Authorization": f"Bearer {self.api_key}"}
        payload: Dict[str, Any] = {
            "model": self.model,
            "temperature": self.temperature,
            "max_tokens": self.max_tokens,
            "messages": [{"role": "user", "content": prompt}],
        }
        resp = requests.post(url, headers=headers, data=json.dumps(payload), timeout=self.timeout_s)
        resp.raise_for_status()
        data = resp.json()
        return (data.get("choices", [{}])[0].get("message", {}) or {}).get("content", "") or ""


def get_llm(mode: str, model_name: str, base_url: str, api_key: str, temperature: float, max_new_tokens: int):
    if mode == "runpod":
        return OpenAICompatClient(
            base_url=base_url,
            api_key=api_key,
            model=model_name,
            temperature=temperature,
            max_tokens=max_new_tokens,
        )

    # local: import lazily to avoid hard dependency (torch) at import-time
    from src.base.llm_model import get_hf_llm  # type: ignore

    return get_hf_llm(model_name=model_name, max_new_token=max_new_tokens, temperature=temperature)


def build_rag_chain(mode: str, llm, retriever):
    if mode == "runpod":
        # Keep prompt from src, call OpenAI-compatible endpoint directly.
        return ("runpod", llm, retriever)

    from src.rag.offline_rag import Offline_RAG  # type: ignore

    return Offline_RAG(llm).get_chain(retriever)


def generate_answer(rag_chain, query: str, history: str = "", services: str = "") -> str:
    # runpod path: rag_chain is ("runpod", llm, retriever)
    if isinstance(rag_chain, tuple) and len(rag_chain) == 3 and rag_chain[0] == "runpod":
        _, llm, retriever = rag_chain
        from src.rag.offline_rag import rag_prompt  # type: ignore

        from retriever_eval import get_retrieved_documents

        docs = get_retrieved_documents(retriever, str(query))
        context = "\n\n".join(getattr(d, "page_content", str(d)) for d in docs)
        prompt_str = rag_prompt.format(context=context, history=history, services=services, question=query)
        out = llm.invoke(prompt_str) if hasattr(llm, "invoke") else str(llm(prompt_str))
        return str(out).strip()

    # local path: rag_chain is LangChain runnable
    payload = {"question": query, "history": history, "services": services}
    result = rag_chain.invoke(payload)
    if isinstance(result, str):
        return result.strip()
    if isinstance(result, dict):
        return str(result.get("answer", "")).strip()
    return str(result).strip()

