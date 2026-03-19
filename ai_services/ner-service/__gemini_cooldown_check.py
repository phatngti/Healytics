from app.ner.gemini_ner import extract_entities_with_gemini

q = "massage gần tôi ở quận 3 hcm"
print("CALL 1:", extract_entities_with_gemini(q))
print("CALL 2:", extract_entities_with_gemini(q))
