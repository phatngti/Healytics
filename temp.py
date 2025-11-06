# temp.py
import torch
from transformers import BitsAndBytesConfig
from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline
# Use HuggingFacePipeline in LangChain
from langchain_huggingface import HuggingFacePipeline

# Model name
model_name: str = "microsoft/Phi-3-mini-4k-instruct"
# microsoft/phi-2
# microsoft/Phi-3-mini-4k-instruct
# mistralai/Mistral-7B-Instruct-v0.2

# 4-bit quantization config
n4f_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_use_double_quant=True,
    bnb_4bit_compute_dtype=torch.bfloat16
)

# Load model with quantization
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    quantization_config=n4f_config,
    low_cpu_mem_usage=True
)

# Load tokenizer
tokenizer = AutoTokenizer.from_pretrained(model_name)

# Max tokens
max_new_token = 200

# Create pipeline
model_pipeline = pipeline(
    "text-generation",
    model=model,
    tokenizer=tokenizer,
    max_new_tokens=max_new_token,
	do_sample=False,
	num_return_sequences=1,
    pad_token_id=tokenizer.eos_token_id
)

gen_kwargs = {
    "temperature": 0.0
}

llm = HuggingFacePipeline(
    pipeline=model_pipeline,
    model_kwargs=gen_kwargs
)

prompt = "<|system|>You are a helpful assistant.<|end|> \
		  <|user|>Do you know some tips to practice gym?<|end|> \
		  <|assistant|>"

# Test output
output = llm.invoke(prompt)
answer = output.split("<|assistant|>")[-1].strip()
print(answer)
