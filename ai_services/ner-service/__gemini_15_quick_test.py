from app.ner.gemini_ner import extract_entities_with_gemini

queries = [
    "massage gần tôi ở quận 3 hcm",
    "mình stress mất ngủ, tìm tư vấn tâm lý online dưới 400k, rating từ 4.5 sao",
    "đau lưng lâu năm, cần vật lý trị liệu gần Bình Thạnh tầm 300-500k",
    "nhổ răng khôn ở q1, tối nay còn slot không, giá khoảng 1tr2",
    "tui muốn tri lieu tam ly, budget 350k, gan toi o q3"
]

for i, q in enumerate(queries, 1):
    print(f"\n=== 1.5 CASE {i} ===")
    print("QUERY:", q)
    ents = extract_entities_with_gemini(q)
    print("ENTITIES:", ents)
