"""
Unit tests cho Recommender System
"""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from src.recommender.service_loader import ServiceLoader
from src.recommender.embedding_model import EmbeddingModel
from src.recommender.vectorstore import VectorDB
from src.recommender.chatbot_recommender import ChatbotRecommender
from src.recommender.home_recommender import HomeRecommender
from config.settings import SERVICES_JSON_PATH

def test_service_loader():
    """Test ServiceLoader"""
    print("\n=== TEST SERVICE LOADER ===")
    
    loader = ServiceLoader(SERVICES_JSON_PATH)
    services = loader.load_services()
    
    assert len(services) > 0, "Services should not be empty"
    assert "id" in services[0], "Service should have 'id' field"
    assert "name" in services[0], "Service should have 'name' field"
    
    print(f"✓ Loaded {len(services)} services")
    
    # Test services_to_texts_and_metadata
    texts, metadatas, ids = loader.services_to_texts_and_metadata()
    assert len(texts) == len(services), "Number of texts should match services"
    assert metadatas[0]["service_id"] == services[0]["id"]
    
    print(f"✓ Converted to {len(texts)} texts")
    
    # Test get_service_by_id
    service = loader.get_service_by_id(services[0]["id"])
    assert service is not None, "Should find service by ID"
    assert service["id"] == services[0]["id"]
    
    print("✓ Get service by ID works")

def test_embedding_model():
    """Test EmbeddingModel"""
    print("\n=== TEST EMBEDDING MODEL ===")
    
    embedding_model = EmbeddingModel()
    
    # Test embed_query
    query = "tư vấn tim mạch"
    query_embedding = embedding_model.embed_query(query)
    
    assert len(query_embedding) > 0, "Embedding should not be empty"
    print(f"Query embedding dimension: {len(query_embedding)}")
    
    # Test embed_documents
    texts = ["Dịch vụ 1", "Dịch vụ 2"]
    doc_embeddings = embedding_model.embed_documents(texts)
    
    assert len(doc_embeddings) == 2, "Should have 2 embeddings"
    print("Document embeddings work")

def test_vector_database():
    """Test VectorDB"""
    print("\n=== TEST VECTOR DATABASE ===")
    
    loader = ServiceLoader(SERVICES_JSON_PATH)
    texts, metadatas, ids = loader.services_to_texts_and_metadata()
    
    embedding_model = EmbeddingModel()
    vectordb = VectorDB(embedding_model=embedding_model)
    vectordb.build_db(texts=texts, metadatas=metadatas, ids=ids)
    
    # Test similarity search
    results = vectordb.similarity_search("tim mạch", k=3)
    assert len(results) > 0, "Should find similar services"
    print(f"Found {len(results)} similar services")
    
    # Test similarity_search_with_score
    scored_results = vectordb.similarity_search_with_score("tim mạch", k=3)
    assert len(scored_results) > 0, "Should have scored results"
    print("Similarity search with score works")

def test_chatbot_recommender():
    """Test ChatbotRecommender"""
    print("\n=== TEST CHATBOT RECOMMENDER ===")
    
    loader = ServiceLoader(SERVICES_JSON_PATH)
    texts, metadatas, ids = loader.services_to_texts_and_metadata()
    
    embedding_model = EmbeddingModel()
    vectordb = VectorDB(embedding_model=embedding_model)
    vectordb.build_db(texts=texts, metadatas=metadatas, ids=ids)
    
    recommender = ChatbotRecommender(vectordb, loader)
    
    # Test recommend
    query = "Tôi muốn tìm dịch vụ về tim mạch"
    recommendations = recommender.recommend(query, top_k=3)
    
    assert len(recommendations) > 0, "Should get recommendations"
    assert "service_id" in recommendations[0]
    assert "name" in recommendations[0]
    assert "similarity_score" in recommendations[0]
    assert "reason" in recommendations[0]
    
    print(f"Got {len(recommendations)} recommendations for query: '{query}'")
    for rec in recommendations:
        print(f"  - {rec['name']} (score: {rec['similarity_score']:.2f})")

def test_home_recommender():
    """Test HomeRecommender"""
    print("\n=== TEST HOME RECOMMENDER ===")
    
    loader = ServiceLoader(SERVICES_JSON_PATH)
    texts, metadatas, ids = loader.services_to_texts_and_metadata()
    
    embedding_model = EmbeddingModel()
    vectordb = VectorDB(embedding_model=embedding_model)
    vectordb.build_db(texts=texts, metadatas=metadatas, ids=ids)
    
    recommender = HomeRecommender(vectordb, loader)
    
    # Test với user profile
    user_profile = {
        "health_conditions": ["tim mạch"],
        "interests": ["yoga"]
    }
    
    recommendations = recommender.recommend(
        user_profile=user_profile,
        top_k=3
    )
    
    assert len(recommendations) > 0, "Should get recommendations"
    print(f"Got {len(recommendations)} recommendations for home")
    
    # Test với user mới (no profile)
    recommendations_new = recommender.recommend(top_k=3)
    assert len(recommendations_new) > 0, "Should get trending services"
    print(f"Got {len(recommendations_new)} trending services")

def run_all_tests():
    """Run all tests"""
    print("\n" + "="*60)
    print("RUNNING ALL TESTS")
    print("="*60)
    
    try:
        test_service_loader()
        test_embedding_model()
        test_vector_database()
        test_chatbot_recommender()
        test_home_recommender()
        
        print("\n" + "="*60)
        print("ALL TESTS PASSED")
        print("="*60 + "\n")
        
    except AssertionError as e:
        print(f"\nTEST FAILED: {e}\n")
    except Exception as e:
        print(f"\nERROR: {e}\n")

if __name__ == "__main__":
    run_all_tests()