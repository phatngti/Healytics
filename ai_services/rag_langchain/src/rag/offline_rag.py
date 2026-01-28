#offline_rag.py
# XÂY DỰNG PIPELINE RAG "OFFLINE"
import re #Bộ dò mẫu kí tự
import os
import sys
# from langchain_hub import hub # Tải template prompt
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser
from langchain_core.prompts import PromptTemplate
# CURRENT_DIR = os.path.dirname(__file__)
# PROJECT_ROOT = os.path.abspath(os.path.join(CURRENT_DIR, "../../../"))
# RECOMMENDER_SRC = os.path.join(PROJECT_ROOT, "recommender2", "src")
# sys.path.append(RECOMMENDER_SRC)
# from recommender.chatbot_recommender import Chatbot_Recommender
from langchain_core.runnables import RunnableLambda


rag_prompt = PromptTemplate(
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

recommend_prompt = PromptTemplate(
    template="""
        <|system|>
        You are a service consultation assistant.

        Your role is to:
        - Explain and interpret the given services
        - Match user needs with the provided services based ONLY on their names and descriptions

        STRICT RULES:
        - Do NOT invent new services
        - Do NOT recommend services outside the given list
        - Do NOT make final decisions for the user
        - Do NOT add medical diagnoses

        You must:
        - Explain why each service may or may not be suitable
        - Base all explanations strictly on the provided service descriptions
        - Keep explanations clear, neutral, and informative

        <|end|>

        <|user|>
        User request:
        {question}

        Services:
        {context}

        Task:
        Based on the user's request, explain how each listed service could help or might not be suitable.
        IMPORTANT:
        - Each service must be described ONLY ONCE
        - Do not rephrase or repeat the same service under different wording
        Let the user decide.
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
        self.str_parser = Str_OutputParser()
        # self.recommender = Chatbot_Recommender("healytics_collection")
    
    # def recommend_services(self, question: str):
    #     return self.recommender.recommend(question)

    def get_chain(self, retriever):
        # Tạo biến need_recommender để xác định có cần recommender hay không dựa vào mô hình intent classification !
        need_recommender = False
        if (need_recommender):
            input_data = {
                "context": (
                    RunnablePassthrough()
                    | RunnableLambda(self.recommend_services)
                    | RunnableLambda(self.format_services)
                ),
                "question": RunnablePassthrough()
            }
        else:
            input_data = {
                "context": retriever | self.format_docs,
                "question": RunnablePassthrough() # Question không cần xử lý trước khi đưa vào chuỗi
            }
        prompt = recommend_prompt if need_recommender else rag_prompt

        rag_chain = (
            input_data
            | prompt
            | self.llm
            | self.str_parser
        ).with_types(input_type=str)
        return rag_chain
    
    def format_docs(self, docs):
        return "\n\n".join(doc.page_content for doc in docs)
    
    def format_services(self, services: dict) -> str:
        docs = services.get("documents", [[]])[0]
        metadatas = services.get("metadatas", [[]])[0]
        ids = services.get("ids", [[]])[0]
        distances = services.get("distances", [[]])[0]

        formatted = []

        for i in range(len(docs)):
            service_text = docs[i]
            metadata = metadatas[i] if i < len(metadatas) else {}
            service_id = ids[i] if i < len(ids) else "N/A"
            distance = distances[i] if i < len(distances) else None

            formatted.append(
            f"""Service ID: {service_id}
            Description:
            {service_text}

            Category: {metadata.get("category", "unknown")}
            Type: {metadata.get("type", "unknown")}
            Similarity score: {distance}
            """
            )

        return "\n---\n".join(formatted)
