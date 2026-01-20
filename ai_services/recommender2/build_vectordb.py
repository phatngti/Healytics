from src.recommender.vector_store import Vector_Database
from src.recommender.service_loader import Service_Loader
from src.recommender.embedding_model import Embedding_Model

def build_vector_database(vector_database_name = "healytics_collection"):
    vector_database = Vector_Database(db_name = vector_database_name)
    service_loader = Service_Loader()
    services_data = service_loader.load_services()
    embedding_model = Embedding_Model()

    for service in services_data:
        service_document = service["name"] + service["description"]
        service_embedding = embedding_model.encode(service_document)
        vector_database.add_service(service, service_embedding)
    print("Vector Database has been built successfully")
    
if __name__ == "__main__":
    build_vector_database()