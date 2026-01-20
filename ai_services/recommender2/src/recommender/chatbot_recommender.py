import os
import sys
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.append(ROOT_DIR)
from config import settings
from .embedding_model import Embedding_Model
from .vector_store import Vector_Database

class Chatbot_Recommender:
    def __init__(self, database_name):
        self.vector_database = Vector_Database(db_name = database_name)
        self.embedding_model = Embedding_Model()

    def recommend(self, query):
        query_embedding = self.embedding_model.encode(query)
        results = self.vector_database.search_similarity_services(query_embedding, n_results = settings.TOP_K_CHATBOT_RESULTS)
        return results

if __name__ == "__main__":
    chatbot = Chatbot_Recommender("healytics_collection")
    chatbot.recommend("Bạn có thể gợi ý cho tôi các dịch vụ liên quan đến yoga không ?")
