# file_loader.py
from typing import Union, List, Literal
import glob
from tqdm import tqdm
import multiprocessing

# Các module trong LangChain dùng để đọc và xử lý tài liệu
from langchain_community.document_loaders import PyPDFLoader
from langchain_text_splitters import RecursiveCharacterTextSplitter

def remove_non_utf8_characters(text: str) -> str:
    """Xóa các ký tự không nằm trong bảng mã UTF-8 (thường là lỗi khi đọc PDF)."""
    return ''.join(char for char in text if ord(char) < 128)

def load_pdf(pdf_file: str):
    """Đọc một file PDF và trả về nội dung đã được làm sạch."""
    docs = PyPDFLoader(pdf_file, extract_images=False).load()
    for doc in docs:
        doc.page_content = remove_non_utf8_characters(doc.page_content)
    return docs

def get_num_cpu():
    """Lấy số lượng CPU của máy tính để chia process khi đọc nhiều file."""
    return multiprocessing.cpu_count()

class BaseLoader:
    def __init__(self) -> None:
        self.num_processes = get_num_cpu()

    def __call__(self, files: List[str], **kwargs):
        """Hàm được override ở các lớp con."""
        pass


class PDFLoader(BaseLoader):
    def __init__(self) -> None:
        super().__init__()

    def __call__(self, pdf_files: List[str], **kwargs):
        """Đọc nhiều file PDF song song bằng multiprocessing."""
        num_processes = min(self.num_processes, kwargs.get("workers", 4))

        doc_loaded = []
        total_files = len(pdf_files)

        with multiprocessing.Pool(processes=num_processes) as pool:
            with tqdm(total=total_files, desc="Loading PDFs", unit="file") as pbar:
                for result in pool.imap_unordered(load_pdf, pdf_files):
                    doc_loaded.extend(result)
                    pbar.update(1)

        return doc_loaded

class Loader:
    def __init__(
        self,
        file_type: str = Literal["pdf"],
        split_kwargs: dict = {
            "chunk_size": 300,
            "chunk_overlap": 0
        }
    ) -> None:

        assert file_type in ["pdf"], "file_type must be pdf"
        self.file_type = file_type

        # Gán loader cụ thể tùy theo loại file
        if file_type == "pdf":
            self.doc_loader = PDFLoader()
        else:
            raise ValueError("file_type must be pdf")

        # Bộ chia nhỏ text
        self.doc_splitter = RecursiveCharacterTextSplitter(**split_kwargs)

    def load(self, pdf_files: Union[str, List[str]], workers: int = 1):
        """Tải nội dung từ 1 hoặc nhiều file PDF."""
        if isinstance(pdf_files, str):
            pdf_files = [pdf_files]

        doc_loaded = self.doc_loader(pdf_files, workers=workers)
        doc_split = self.doc_splitter.split_documents(doc_loaded)

        return doc_split

    def load_dir(self, dir_path: str, workers: int = 1):
        """Tải tất cả file PDF trong một thư mục."""
        if self.file_type == "pdf":
            pdf_files = glob.glob(f"{dir_path}/*.pdf")

            assert len(pdf_files) > 0, f"No {self.file_type} files found in {dir_path}"

            return self.load(pdf_files, workers=workers)
        else:
            raise ValueError(f"file_type {self.file_type} not supported")

class TextSplitter:
    def __init__(
        self,
        separators: List[str] = ['\n\n', '\n', '.', ' '],
        chunk_size: int = 300,
        chunk_overlap: int = 0
    ) -> None:
        # RecursiveCharacterTextSplitter là bộ chia văn bản có khả năng
        # cắt text thành các đoạn mà vẫn giữ được cấu trúc logic.
        self.splitter = RecursiveCharacterTextSplitter(
            separators=separators,
            chunk_size=chunk_size,
            chunk_overlap=chunk_overlap,
        )

    def __call__(self, documents):
        """Gọi trực tiếp class như một hàm để chia nhỏ văn bản."""
        return self.splitter.split_documents(documents)
