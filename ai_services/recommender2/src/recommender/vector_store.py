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
    def __init__(self):
        # Create chroma client
        self.chroma_client = chromadb.PersistentClient(path=vectordb_path)

    def build_db(self, db_name = "healytics_collection"):
        # Create collection for storing embeddings, documents,...
        collection = self.chroma_client.get_or_create_collection(
            name = db_name,
        )
        print("The Vector Database has been successfully built")
        return collection
    
    def add_service(self, service, embedding, collection):
        collection.add(
            ids=[service["id"]],
            embeddings=[embedding],
            documents=[service["name"] + service["description"]],
            metadatas=[{"category": service["category"], "type": service["type"]}],
        )
    
    def search_similarity_services(self, embedding_query, collection, n_results = settings.TOP_K_RESULTS):
        similarity_services = collection.query(
            query_embeddings=[embedding_query],
            n_results = n_results,
        )

        return similarity_services


vector_database = Vector_Database()
service_loader = Service_Loader()
services_data = service_loader.load_services()
embedding_model = Embedding_Model()

collection = vector_database.build_db("healytics_collection")
for service in services_data:
    service_document = service["name"] + service["description"]
    service_embedding = embedding_model.encode(service_document)
    vector_database.add_service(service, service_embedding, collection)

query = "Có dịch vụ nào giúp tôi giảm cân không?"
query_embedding = embedding_model.encode(query)
results = vector_database.search_similarity_services(query_embedding, collection)

print(results)


    
    

