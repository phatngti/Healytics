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