from src.recommender.vector_store import Vector_Database

async def handle_sync_event(channel: str, data: dict):
    service_id = data.get("service_id")
    
    if channel == "service:updated":
        # Cần query PostgreSQL lấy data
        # TODO: cần DB session ở đây 
        pass
        
    elif channel == "service:deleted":
        vector_db = Vector_Database("healytics_collection")
        vector_db.delete_service(service_id)