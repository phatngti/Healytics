from fastapi import APIRouter
from app.schemas.ner_schema import NerRequest, NerResponse
from app.clients.ner_client import NERClient

router = APIRouter()

@router.post("/ner/extract", response_model=NerResponse)
async def extract_entities(request: NerRequest):
    client = NERClient()
    payload = {"conversation_id": str(request.conversation_id), "text": request.text}
    return await client.extract_entities(payload)