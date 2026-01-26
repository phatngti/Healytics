find . -name "__pycache__" -type d -exec rm -rf {} +
find . -name "*.pyc" -delete
rm -rf ai_services/recommender/data/processed/vectordb/ 

# Run code
uvicorn src.app:app --host "0.0.0.0" --port 5000 --reload