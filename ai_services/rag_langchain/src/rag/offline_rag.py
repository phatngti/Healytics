#offline_rag.py
# XÂY DỰNG PIPELINE RAG "OFFLINE"
import re #Bộ dò mẫu kí tự
# from langchain_hub import hub # Tải template prompt
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate

phi3_prompt = PromptTemplate(
    template="""
        <|system|>
        You are a helpful assistant. Use the context to answer the user.
        <|end|>

        <|user|>
        Context:
        {context}

        Question:
        {question}
        <|end|>

        <|assistant|>
    """,
    input_variables=["context", "question"]
)

class Str_OutputParser(StrOutputParser):
    def __init__(self) -> None:
        super().__init__()

    def parse(self, text: str) -> str:
        return self.extract_answer(text)
    
    # Tìm phần nội dung sau "Answer:"
    def extract_answer(self, text_response: str, pattern: str = r"Answer:\s*(.*)") -> str:
        match = re.search(pattern, text_response, re.DOTALL)
        if match:
            answer_text = match.group(1).strip()
            return answer_text
        else:
            return text_response
        
class Offline_RAG:
    def __init__(self, llm) -> None:
        self.llm = llm
        # self.prompt = hub.pull("rlm/rag-prompt") # Template Prompt có sẵn
        self.prompt = phi3_prompt
        self.str_parser = Str_OutputParser()

    def get_chain(self, retriever):
        input_data = {
            "context": retriever | self.format_docs,
            "question": RunnablePassthrough() # Question không cần xử lý trước khi đưa vào chuỗi
        }
        rag_chain = (
            input_data
            | self.prompt
            | self.llm
            | self.str_parser
        )
        return rag_chain
    
    def format_docs(self, docs):
        return "\n\n".join(doc.page_content for doc in docs)