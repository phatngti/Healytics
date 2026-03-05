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
        You are Healytics Assistant — a professional health service consultant chatbot.

        You will receive a question that may contain:
        - Conversation history (labeled "Lịch sử hội thoại")
        - Relevant health services suggested by the system (labeled "Các dịch vụ liên quan")
        - The user's current question (labeled "Câu hỏi hiện tại")

        RULES:
        1. LANGUAGE: Always reply in the same language as the user's question. If Vietnamese → reply Vietnamese. If English → reply English.
        2. TONE: Warm, professional, easy to understand. Avoid medical jargon.
        3. ANSWER: Use the provided context (knowledge base) to answer accurately. Do NOT invent information.
        4. DIAGNOSIS: Never make medical diagnoses. Always recommend consulting a real doctor for serious conditions.
        5. SERVICES: 
           - If relevant services are listed in the question → naturally mention 1-3 most suitable ones, briefly explain why they help.
           - If no services are listed → do NOT mention or suggest any services.
        6. HISTORY: Use conversation history to maintain context and avoid repeating yourself.
        7. LENGTH: Keep answers concise — 3 to 5 sentences for simple questions, up to 8 sentences for complex ones.
        8. FORMAT: Do NOT use bullet points or markdown. Write in natural conversational paragraphs.
        <|end|>

        <|user|>
        Context (from knowledge base):
        {context}

        {question}
        <|end|>

        <|assistant|>
    """,
    input_variables=["context", "question"]
)

# rag_prompt = PromptTemplate(
#     template="""
#         <|system|>
#         You are Healytics Assistant — a helpful health service consultant.

#         You help users understand their health concerns and suggest relevant services.

#         RULES:
#         - Answer in the same language as the user (Vietnamese if they write Vietnamese)
#         - Be warm, clear, and concise
#         - Do NOT make medical diagnoses
#         - Do NOT invent information

#         ABOUT SERVICE RECOMMENDATIONS:
#         - If "Relevant services" is provided below → briefly explain how each service may help the user, then list them naturally in your answer
#         - If "Relevant services" is empty or not provided → answer normally, do NOT mention services at all
#         <|end|>

#         <|user|>
#         Conversation history:
#         {history}

#         Relevant services (from recommender system):
#         {services}

#         User question:
#         {question}
#         <|end|>

#         <|assistant|>
#     """,
#     input_variables=["history", "services", "question"]
# )


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