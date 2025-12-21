from sentence_transformers import SentenceTransformer
from config.settings import EMBEDDING_MODEL_NAME, DEVICE

class EmbeddingModel:
    
    def __init__(self, model_name: str = EMBEDDING_MODEL_NAME):
        self.model_name = model_name
        self.model = self._load_model()
    
    def _load_model(self):
        """Load embedding model"""
        print(f"Đang load embedding model: {self.model_name}")
        print(f"Device: {DEVICE}")
        
        model = SentenceTransformer(self.model_name, device=DEVICE)
        
        print("Đã load embedding model thành công")
        return model
    
    def embed_query(self, text: str):
        """Embed một query text"""
        return self.model.encode(text, convert_to_numpy=True)
    
    def embed_documents(self, texts: list):
        """Embed danh sách documents"""
        return self.model.encode(texts, convert_to_numpy=True, show_progress_bar=True)