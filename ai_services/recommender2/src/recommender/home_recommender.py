import os
import sys
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.append(ROOT_DIR)
from config import settings
from .embedding_model import Embedding_Model
from .vector_store import Vector_Database

class Home_Recommender:
    def __init__(self, database_name):
        self.vector_database = Vector_Database(db_name = database_name)
        self.embedding_model = Embedding_Model()
    
    def build_service_history_texts(self, service_history_ids):
        service_history_texts = []
        for service_history_id in service_history_ids:
            service = self.vector_database.get_service_information(service_history_id)
            service_history_texts += service["documents"]
        return service_history_texts

    # Recommender base on health conditions, interests, service_history
    def recommend(self, health_conditions, interests, goals, service_history_ids, top_k_home_results = settings.TOP_K_HOME_RESULTS):
        service_history_texts = self.build_service_history_texts(service_history_ids)
        # Nối thành 1 string
        user_profile_query = " ".join(
            (health_conditions or []) +
            (interests or []) +
            (goals or []) +
            (service_history_texts or [])
        )
        user_profile_embedding = self.embedding_model.encode(user_profile_query)
        results = self.vector_database.search_similarity_services(user_profile_embedding, n_results = top_k_home_results)
        return results

if __name__ == "__main__":
    health_conditions = ["tim mạch", "huyết áp cao"]
    interests = ["yoga", "thiền", "chạy bộ"]
    goals = ["giảm cân", "khỏe mạnh hơn"]
    services_history = ["SV001", "SV002"]

    # Khởi tạo trang home
    home = Home_Recommender("healytics_collection")
    print(home.build_service_history_texts(services_history))
    
    results = home.recommend(health_conditions, interests, services_history)
    print(results)