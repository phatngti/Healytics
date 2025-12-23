find . -name "__pycache__" -type d -exec rm -rf {} +
find . -name "*.pyc" -delete
rm -rf ai_services/recommender/data/processed/vectordb/ 