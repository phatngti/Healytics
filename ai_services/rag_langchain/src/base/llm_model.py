
# llm_model.py
import torch
from transformers import BitsAndBytesConfig
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
from langchain_huggingface import HuggingFacePipeline

device = "cuda" if torch.cuda.is_available() else "cpu"

n4f_config = BitsAndBytesConfig(
    load_in_4bit=True, # Bật chế độ 4bit
    bnb_4bit_quant_type="nf4", # Loại lượng tử hóa (nf4 = NormalFloat4)
    bnb_4bit_use_double_quant=True, # Double Quantization (Giảm lỗi lượng tử hóa)
    bnb_4bit_compute_dtype=torch.float16, # Kiểu dữ liệu tính toán
)

# 24GB --> 8GB
# def get_hf_llm(model_name = "microsoft/Phi-3-mini-4k-instruct", max_new_token = 300, **kwargs):

def get_hf_llm(model_name = "meta-llama/Llama-3.1-8B-Instruct", max_new_token = 512, **kwargs):
     
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

