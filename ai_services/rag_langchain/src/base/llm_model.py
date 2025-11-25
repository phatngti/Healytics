
# llm_model.py
import torch
from transformers import BitsAndBytesConfig
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
from langchain_community.llms import HuggingFacePipeline

device = "cuda" if torch.cuda.is_available() else "cpu"

n4f_config = BitsAndBytesConfig(
    load_in_4bit=True, # Bật chế độ 4bit
    bnb_4bit_quant_type="nf4", # Loại lượng tử hóa (nf4 = NormalFloat4)
    bnb_4bit_use_double_quant=True, # Double Quantization (Giảm lỗi lượng tử hóa)
    bnb_4bit_compute_dtype=torch.bfloat16 # Kiểu dữ liệu tính toán
)

def get_hf_llm(model_name = "HuggingFaceTB/SmolLM-1.7B", max_new_token = 2000, **kwargs):

    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        # quantization_config = n4f_config,
        torch_dtype=torch.float16,  # FP16 thay vì 4-bit
        device_map="auto",
        low_cpu_mem_usage = True
    )
    tokenizer = AutoTokenizer.from_pretrained(model_name)

    model_pipeline = pipeline(
        "text-generation",
        model=model, 
        tokenizer=tokenizer,
        max_new_tokens=max_new_token,
        pad_token_id=tokenizer.eos_token_id, # Tránh lỗi khi model không có token [PAD]
    )

    # Tích hợp model vào hệ thống LangChain
    llm = HuggingFacePipeline(
        pipeline=model_pipeline,
        model_kwargs=kwargs
    )

    return llm


