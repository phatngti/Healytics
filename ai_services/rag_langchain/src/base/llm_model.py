
# llm_model.py
import os
import torch
import httpx
from pathlib import Path
from dotenv import load_dotenv
from transformers import BitsAndBytesConfig
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
from langchain_huggingface import HuggingFacePipeline
from langchain_core.runnables import Runnable

device = "cuda" if torch.cuda.is_available() else "cpu"

ENV_PATH = Path(__file__).resolve().parents[2] / ".env"
load_dotenv(ENV_PATH)

n4f_config = BitsAndBytesConfig(
    load_in_4bit=True, # Bật chế độ 4bit
    bnb_4bit_quant_type="nf4", # Loại lượng tử hóa (nf4 = NormalFloat4)
    bnb_4bit_use_double_quant=True, # Double Quantization (Giảm lỗi lượng tử hóa)
    bnb_4bit_compute_dtype=torch.float16, # Kiểu dữ liệu tính toán
)

class MistralChatLLM(Runnable):
    """LangChain Runnable wrapper for Mistral Chat Completions API."""

    def __init__(
        self,
        model_name: str = "mistral-large-latest",
        api_key: str | None = None,
        temperature: float = 0.2,
        max_tokens: int = 512,
        timeout: float = 120.0,
    ) -> None:
        self.model_name = model_name
        self.api_key = api_key or os.getenv("MISTRAL_API_KEY")
        self.temperature = temperature
        self.max_tokens = max_tokens
        self.timeout = timeout
        self.api_url = os.getenv("MISTRAL_API_URL", "https://api.mistral.ai/v1/chat/completions")

        if not self.api_key:
            raise ValueError(
                "Missing MISTRAL_API_KEY. Add it to rag_langchain/.env or export it before starting the service."
            )

    def invoke(self, input, config=None, **kwargs) -> str:
        prompt = input.to_string() if hasattr(input, "to_string") else str(input)
        response = httpx.post(
            self.api_url,
            headers={
                "Authorization": f"Bearer {self.api_key}",
                "Content-Type": "application/json",
            },
            json={
                "model": self.model_name,
                "messages": [{"role": "user", "content": prompt}],
                "temperature": self.temperature,
                "max_tokens": self.max_tokens,
            },
            timeout=self.timeout,
        )
        response.raise_for_status()
        return response.json()["choices"][0]["message"]["content"].strip()


def get_mistral_llm(
    model_name: str = "mistral-large-latest",
    max_new_token: int = 512,
    **kwargs,
):
    temperature = float(kwargs.get("temperature", os.getenv("MISTRAL_TEMPERATURE", "0.2")))
    timeout = float(os.getenv("MISTRAL_TIMEOUT", "120"))
    llm = MistralChatLLM(
        model_name=os.getenv("MISTRAL_MODEL", model_name),
        temperature=temperature,
        max_tokens=int(os.getenv("MISTRAL_MAX_TOKENS", str(max_new_token))),
        timeout=timeout,
    )
    print("🚀 Loading model:", llm.model_name)
    print("LLM backend: mistral")
    return llm


# 24GB --> 8GB
# def get_hf_llm(model_name = "microsoft/Phi-3-mini-4k-instruct", max_new_token = 300, **kwargs):

def get_hf_llm(model_name = "meta-llama/Llama-3.1-8B-Instruct", max_new_token = 256, **kwargs):
    llm_backend = os.getenv("LLM_BACKEND", "llama").strip().lower()
    if llm_backend == "mistral":
        return get_mistral_llm(max_new_token=max_new_token, **kwargs)
    if llm_backend not in {"llama", "hf", "huggingface"}:
        raise ValueError("LLM_BACKEND must be one of: llama, hf, huggingface, mistral")

     
    hf_token = "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" # Model Llama_8B
    # hf_token = "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" # Model Llama_3B

    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        quantization_config = n4f_config,
        # torch_dtype=torch.float16,  # FP16 thay vì 4-bit
        low_cpu_mem_usage = True,
        token=hf_token,
    )

    tokenizer = AutoTokenizer.from_pretrained(model_name, token=hf_token)

    model_pipeline = pipeline(
        "text-generation",
        model=model, 
        tokenizer=tokenizer,
        max_new_tokens=max_new_token,
        do_sample=False,
	    num_return_sequences=1,
        pad_token_id=tokenizer.eos_token_id, # Tránh lỗi khi model không có token [PAD]
    )

    # Tích hợp model vào hệ thống LangChain
    llm = HuggingFacePipeline(
        pipeline=model_pipeline,
        model_kwargs=kwargs
    )
    print("CUDA available:", torch.cuda.is_available())
    
    if torch.cuda.is_available():
        print("GPU name:", torch.cuda.get_device_name(0))
    else:
        print("GPU name: None")

    print("Model is on device:", model.device)
    print("🚀 Loading model:", model_name)

    return llm

