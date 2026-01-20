from sentence_transformers import SentenceTransformer
import os
import sys
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.append(ROOT_DIR)
from config.settings import EMBEDDING_MODEL_NAME

class Embedding_Model:
    def __init__(self):
        self.embedding_model = SentenceTransformer(EMBEDDING_MODEL_NAME)

    def encode(self, sentences):
        embeddings = self.embedding_model.encode(sentences)
        print("Encoding embeddings successfully")
        return embeddings

    
    

