#offline_rag.py
# XÂY DỰNG PIPELINE RAG "OFFLINE"
import re #Bộ dò mẫu kí tự
from langchain import hub # Tải template prompt
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate

my_prompt = PromptTemplate(
    input_variables=["context", "question"],
    template="""
    You are a super smart assistant.
    Use the following context to answer the question, if there aren't information in context, you can answer by your self or say you don't know
    Do not make up information. Keep your answer as long as you can.

    Context: {context}
    Question: {question}
    Answer:
    """
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
        self.prompt = my_prompt
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