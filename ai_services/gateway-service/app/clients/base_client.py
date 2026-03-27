# app/clients/base_client.py

import httpx # thư viện để gọi API async
from app.core.config import settings


class BaseClient:
    """
    Base HTTP client cho tất cả microservices.

    Chịu trách nhiệm:
    - tạo AsyncClient
    - timeout config
    - connection reuse
    """

    def __init__(self, base_url: str):
        self.base_url = base_url

    # Tạo HTTP client async 
    def _client(self) -> httpx.AsyncClient:
        # Tạo object để gọi HTTP.
        return httpx.AsyncClient(
            base_url=self.base_url,
            timeout=httpx.Timeout(
                connect=settings.HTTP_CONNECT_TIMEOUT,
                read=settings.HTTP_READ_TIMEOUT,
                write=settings.HTTP_WRITE_TIMEOUT,
                pool=settings.HTTP_POOL_TIMEOUT,
            ),
        )