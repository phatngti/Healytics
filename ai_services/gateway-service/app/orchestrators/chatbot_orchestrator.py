1. get_or_create_conversation()
2. create user message
3. gọi chatbot_client.stream_chat()
4. stream token → SSE
5. gọi ner_client (optional)
6. gọi recommender_client (optional)
7. collect full response
8. save assistant message
9. emit DONE