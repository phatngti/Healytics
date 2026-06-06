"""
pdf_extractor.py — Trích xuất text thuần từ file PDF WHO.

Dùng PyPDFLoader (cùng stack với rag_langchain/file_loader.py).
Không extract ảnh — đủ cho guideline WHO dạng văn bản.
"""

from __future__ import annotations

from pathlib import Path

from langchain_community.document_loaders import PyPDFLoader


def extract_pdf_text(pdf_path: Path) -> str:
    """
    Đọc toàn bộ trang PDF, nối thành một chuỗi.

    Returns:
        Text đã strip; chuỗi rỗng nếu PDF scan ảnh không có layer text.
    """
    docs = PyPDFLoader(str(pdf_path), extract_images=False).load()
    parts = []
    for doc in docs:
        text = (doc.page_content or "").strip()
        if text:
            parts.append(text)
    return "\n\n".join(parts)
