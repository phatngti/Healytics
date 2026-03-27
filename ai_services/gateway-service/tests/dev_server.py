from fastapi import FastAPI
from tests.test_sse import sse_router

app = FastAPI()
app.include_router(sse_router)