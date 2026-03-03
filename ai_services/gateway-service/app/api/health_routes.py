# ai_services/gateway-service/app/api/health_routes.py

from fastapi import APIRouter

router = APIRouter()

@router.get("/health")
async def health():
    return {"status": "ok"}
