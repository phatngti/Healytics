
from src.recommender.chatbot_recommender import Chatbot_Recommender
if __name__ == "__main__":
    chatbot = Chatbot_Recommender("healytics_collection")
    results = chatbot.recommend(
        "Bạn có thể gợi ý cho tôi các dịch vụ liên quan đến yoga không ?"
    )
    print(results)