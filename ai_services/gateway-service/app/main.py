app = FastAPI()

include_router(...)
add middleware
startup config
main.py sẽ tạo session, rồi inject session xuống route, route truyền session xuống orchestrator, rồi orchestrator sẽ truyền session xuống repository


from fastapi import FastAPI
from tests.test_sse import sse_router

app = FastAPI()
app.include_router(sse_router)