# Use a pipeline as a high-level helper
from transformers import pipeline

pipe = pipeline("text-generation", model="RedHatAI/Mistral-7B-Instruct-v0.3-GPTQ-4bit")
messages = [
    {"role": "user", "content": "Who are you?"},
]
pipe(messages)