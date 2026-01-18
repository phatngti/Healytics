import chromadb
import os
import sys
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.append(ROOT_DIR)
from config import settings
import json
from service_loader import Service_Loader
from embedding_model import Embedding_Model

vectordb_path = os.path.join(settings.PROCESSED_DATA_DIR, "vectordb")

class Vector_Database:
    def __init__(self, db_name):
        # Create chroma client
        self.chroma_client = chromadb.PersistentClient(path=vectordb_path)
        self.collection = self.chroma_client.get_or_create_collection(
            name = db_name,
        )
    
    def add_service(self, service, embedding):
        self.collection.add(
            ids=[service["id"]],
            embeddings=[embedding],
            documents=[service["name"] + service["description"]],
            metadatas=[{"category": service["category"], "type": service["type"]}],
        )
    
    def search_similarity_services(self, embedding_query, n_results):
        similarity_services = self.collection.query(
            query_embeddings=[embedding_query],
            n_results = n_results,
        )

        return similarity_services

    def get_service_information(self, search_ids):
        service = self.collection.get(ids=[search_ids])
        return service

if __name__ == "__main__":
    vector_database = Vector_Database(db_name = "healytics_collection")
    service_loader = Service_Loader()
    services_data = service_loader.load_services()
    embedding_model = Embedding_Model()

    for service in services_data:
        service_document = service["name"] + service["description"]
        service_embedding = embedding_model.encode(service_document)
        vector_database.add_service(service, service_embedding)

    query = "Có dịch vụ nào giúp tôi giảm cân không?"
    query_embedding = embedding_model.encode(query)
    results = vector_database.search_similarity_services(query_embedding)

    print(results)


    
    

