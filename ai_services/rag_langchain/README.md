find . -name "__pycache__" -type d -exec rm -rf {} +
find . -name "*.pyc" -delete
rm -rf ai_services/recommender/data/processed/vectordb/ 

# Run code
uvicorn src.app:app --host "0.0.0.0" --port 5000 --reload
uvicorn src.app:app --host 0.0.0.0 --port 5000 --timeout-keep-alive 300

curl http://localhost:5000/check

curl -N -X POST http://localhost:5000/generative_ai/stream \
-H "Content-Type: application/json" \
-d '{"question":"Explain RAG in simple terms"}'