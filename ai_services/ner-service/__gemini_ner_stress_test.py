from app.ner.gemini_ner import extract_entities_with_gemini

queries = [
    "đau lưng lâu năm, cần vật lý trị liệu gần Bình Thạnh tầm 300-500k",
    "mình stress mất ngủ, tìm tư vấn tâm lý online dưới 400k, rating từ 4.5 sao",
    "nhổ răng khôn ở q1, tối nay còn slot không, giá khoảng 1tr2",
    "spa trị mụn + nám cho da nhạy cảm, gần tôi trong bán kính 3km",
    "đông y châm cứu bấm huyệt cho thoát vị đĩa đệm ở hà nội",
    "tìm chỗ mát xa thư giãn cho cặp đôi, tầm 700k đổ lại, ở quận 7",
    "cần nhà thuốc mở cửa khuya gần phường 25 bình thạnh",
    "pilates cho người sau sinh ở tp thủ đức, giá <= 500k",
    "khám da liễu dị ứng nổi mề đay, ưu tiên bác sĩ nữ, quận 3 hcm",
    "tui muốn tri lieu tam ly, budget 350k, gan toi o q3",
    "massage g?n tôi ? qu?n 3 hcm",
    "có chỗ phục hồi chức năng sau đột quỵ ở đn không"
]

for i, q in enumerate(queries, 1):
    print(f"\n=== CASE {i} ===")
    print("QUERY:", q)
    ents = extract_entities_with_gemini(q)
    if ents is None:
        print("GEMINI: None (API fail/timeout/config)")
    else:
        print("ENTITIES:", ents)
