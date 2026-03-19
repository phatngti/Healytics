from app.ner.extractor import extract_entities

queries = [
    "đau lưng lâu năm, cần vật lý trị liệu gần Bình Thạnh tầm 300-500k",
    "mình stress mất ngủ, tìm tư vấn tâm lý online dưới 400k, rating từ 4.5 sao",
    "tui muốn tri lieu tam ly, budget 350k, gan toi o q3",
    "massage g?n tôi ? qu?n 3 hcm"
]

for i, q in enumerate(queries, 1):
    print(f"\n=== EXTRACTOR CASE {i} ===")
    print("QUERY:", q)
    print("ENTITIES:", extract_entities(q))
