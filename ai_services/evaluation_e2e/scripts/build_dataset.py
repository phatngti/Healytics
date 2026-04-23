"""
Sinh bộ dữ liệu đánh giá End-to-End gồm 500 mẫu tiếng Việt
cho chatbot y tế Healytics.

Các trường của 1 mẫu:
    - id:                   mã định danh
    - category:             nhóm câu hỏi (6 nhóm)
    - needs_recommendation: có kỳ vọng gọi Recommender hay không
    - has_location:         câu hỏi có chứa vị trí địa lý
    - user_query:           câu hỏi của người dùng
    - ground_truth:         câu trả lời mong đợi (ngắn gọn, đúng trọng tâm)

Phân bố:
    - service_seeking_with_location : 120
    - service_seeking_general       : 120
    - general_medical_qa            : 130
    - symptom_advice                :  80
    - greeting_smalltalk            :  30
    - follow_up_questions           :  20
    - TOTAL                          : 500
"""

import json
import random
import itertools
from pathlib import Path

random.seed(42)

OUT_PATH = Path(__file__).resolve().parent.parent / "data" / "eval_e2e_dataset.json"

# -----------------------------------------------------------
# 1. DANH MỤC Y TẾ + THÀNH PHỐ
# -----------------------------------------------------------

SPECIALTIES = [
    ("tim mạch",          "Chuyên khoa tim mạch chẩn đoán và điều trị các bệnh về tim, huyết áp, mạch máu."),
    ("da liễu",           "Chuyên khoa da liễu xử lý các bệnh về da, tóc, móng như mụn, nấm, viêm da."),
    ("nhi khoa",          "Chuyên khoa nhi khám và điều trị bệnh ở trẻ em dưới 16 tuổi."),
    ("sản phụ khoa",      "Chuyên khoa sản phụ khoa chăm sóc sức khỏe phụ nữ, thai kỳ và các bệnh phụ khoa."),
    ("tai mũi họng",      "Chuyên khoa tai mũi họng chẩn đoán các bệnh về tai, mũi, xoang, họng, thanh quản."),
    ("mắt",               "Chuyên khoa mắt khám, đo thị lực và điều trị các bệnh về mắt như cận thị, đục thủy tinh thể."),
    ("nội tiết",          "Chuyên khoa nội tiết điều trị bệnh tiểu đường, tuyến giáp, rối loạn hormone."),
    ("tiêu hóa",          "Chuyên khoa tiêu hóa chẩn đoán bệnh dạ dày, đại tràng, gan, mật, tụy."),
    ("thần kinh",         "Chuyên khoa thần kinh điều trị đau đầu, động kinh, đột quỵ, rối loạn vận động."),
    ("cơ xương khớp",     "Chuyên khoa cơ xương khớp xử lý thoái hóa khớp, thoát vị đĩa đệm, loãng xương."),
    ("răng hàm mặt",      "Chuyên khoa răng hàm mặt khám nha khoa, chỉnh nha, phẫu thuật hàm mặt."),
    ("tâm thần",          "Chuyên khoa tâm thần điều trị rối loạn lo âu, trầm cảm, mất ngủ, stress."),
    ("hô hấp",            "Chuyên khoa hô hấp điều trị hen, viêm phổi, COPD và các bệnh phổi khác."),
    ("tiết niệu",         "Chuyên khoa tiết niệu chẩn đoán các bệnh thận, bàng quang, tuyến tiền liệt."),
    ("ung bướu",          "Chuyên khoa ung bướu tầm soát, chẩn đoán và điều trị các loại ung thư."),
    ("nội tổng quát",     "Khám nội tổng quát giúp đánh giá tổng thể sức khỏe và phát hiện bệnh lý sớm."),
    ("ngoại tổng quát",   "Khám ngoại tổng quát xử lý các vấn đề cần can thiệp phẫu thuật thông thường."),
    ("huyết học",         "Chuyên khoa huyết học điều trị thiếu máu, rối loạn đông máu, các bệnh máu ác tính."),
    ("dị ứng miễn dịch",  "Chuyên khoa dị ứng miễn dịch điều trị viêm mũi dị ứng, mày đay, hen dị ứng."),
    ("phục hồi chức năng","Phục hồi chức năng giúp bệnh nhân sau chấn thương, đột quỵ lấy lại khả năng vận động."),
]

LOCATIONS = [
    "Hà Nội", "Hồ Chí Minh", "Đà Nẵng", "Hải Phòng", "Cần Thơ",
    "Biên Hòa", "Nha Trang", "Huế", "Vũng Tàu", "Quy Nhơn",
    "Thủ Đức", "Bình Thạnh", "Cầu Giấy", "Đống Đa", "Thanh Xuân",
    "quận 1", "quận 3", "quận 7", "quận 10", "quận Tân Bình",
]

# -----------------------------------------------------------
# 2. SINH NHÓM 1: service_seeking_with_location (120)
# -----------------------------------------------------------

LOC_TEMPLATES = [
    "Tôi muốn khám {spec} ở {loc}, có phòng khám nào uy tín không?",
    "Mình bị vấn đề về {spec}, ở {loc} nên đến đâu khám?",
    "Gợi ý giúp mình phòng khám {spec} gần {loc} với.",
    "Ở {loc} có bệnh viện nào khám {spec} tốt không?",
    "Cho hỏi địa chỉ khám {spec} tại {loc}?",
    "Tôi đang ở {loc}, cần tư vấn khám {spec}.",
    "Bạn tôi ở {loc} muốn khám {spec}, nên chọn đâu?",
    "Gần {loc} có chuyên khoa {spec} không?",
    "Hãy giới thiệu vài dịch vụ {spec} khu vực {loc}.",
    "Tôi cần đặt lịch khám {spec} tại {loc} càng sớm càng tốt.",
]

GT_LOC = (
    "Dựa trên thông tin bạn cung cấp, hệ thống gợi ý một số cơ sở khám {spec} "
    "ở khu vực {loc}. Bạn nên xem chi tiết các dịch vụ được hiển thị và liên hệ đặt lịch."
)

def gen_loc_sample(i):
    spec, desc = random.choice(SPECIALTIES)
    loc = random.choice(LOCATIONS)
    tmpl = random.choice(LOC_TEMPLATES)
    return {
        "id": f"e2e_loc_{i:04d}",
        "category": "service_seeking_with_location",
        "needs_recommendation": True,
        "has_location": True,
        "user_query": tmpl.format(spec=spec, loc=loc),
        "ground_truth": GT_LOC.format(spec=spec, loc=loc),
    }

# -----------------------------------------------------------
# 3. SINH NHÓM 2: service_seeking_general (120)
# -----------------------------------------------------------

GEN_TEMPLATES = [
    "Tôi muốn đi khám {spec}, bạn gợi ý giúp.",
    "Cho mình xin một vài phòng khám {spec}.",
    "Tôi cần tư vấn chọn dịch vụ {spec}.",
    "Bạn biết phòng khám {spec} nào không?",
    "Nên khám {spec} ở đâu cho uy tín?",
    "Tôi đang tìm nơi khám {spec}, bạn hỗ trợ.",
    "Gợi ý cho tôi cơ sở {spec} chất lượng.",
    "Tôi muốn đặt lịch {spec}.",
    "Dịch vụ {spec} nào đang được đánh giá cao?",
    "Cần khám {spec}, tư vấn giúp.",
]

GT_GEN = (
    "Hệ thống đã tổng hợp vài dịch vụ {spec} phù hợp dựa trên nhu cầu của bạn. "
    "Vui lòng xem các gợi ý đi kèm để chọn nơi phù hợp; {desc}"
)

def gen_generic_sample(i):
    spec, desc = random.choice(SPECIALTIES)
    tmpl = random.choice(GEN_TEMPLATES)
    return {
        "id": f"e2e_gen_{i:04d}",
        "category": "service_seeking_general",
        "needs_recommendation": True,
        "has_location": False,
        "user_query": tmpl.format(spec=spec),
        "ground_truth": GT_GEN.format(spec=spec, desc=desc),
    }

# -----------------------------------------------------------
# 4. SINH NHÓM 3: general_medical_qa (130)
# -----------------------------------------------------------

MEDICAL_QA = [
    ("Triệu chứng thường gặp của cảm cúm là gì?",
     "Cảm cúm thường có các triệu chứng như sốt, đau đầu, đau cơ, ho, đau họng, nghẹt mũi, mệt mỏi. Triệu chứng thường kéo dài 5-7 ngày."),
    ("Huyết áp cao có nguy hiểm không?",
     "Huyết áp cao là yếu tố nguy cơ chính gây đột quỵ, nhồi máu cơ tim, suy thận. Cần theo dõi và điều trị kịp thời để tránh biến chứng."),
    ("Bệnh tiểu đường loại 2 là gì?",
     "Tiểu đường loại 2 là rối loạn chuyển hóa gây tăng đường huyết kéo dài do kháng insulin hoặc tiết insulin không đủ, thường gặp ở người trưởng thành."),
    ("Nguyên nhân gây đau dạ dày?",
     "Đau dạ dày thường do vi khuẩn H.pylori, stress, ăn uống không điều độ, lạm dụng thuốc giảm đau, rượu bia, hút thuốc."),
    ("Làm sao để phòng tránh đột quỵ?",
     "Phòng đột quỵ bằng cách kiểm soát huyết áp, đường huyết, mỡ máu; không hút thuốc, hạn chế rượu bia; tập thể dục, ăn uống lành mạnh; tầm soát định kỳ."),
    ("Bệnh viêm gan B lây qua đường nào?",
     "Viêm gan B lây qua đường máu, quan hệ tình dục không an toàn, từ mẹ sang con. Không lây qua ăn uống hay tiếp xúc thông thường."),
    ("Viêm xoang có chữa khỏi không?",
     "Viêm xoang có thể điều trị khỏi hoặc kiểm soát tốt bằng thuốc, rửa mũi, tránh dị nguyên; trường hợp mạn tính nặng có thể cần phẫu thuật nội soi."),
    ("Khi nào cần đi khám mắt?",
     "Nên khám mắt định kỳ 1 năm/lần; đi khám ngay khi thấy mờ, nhức, chảy nước mắt nhiều, nhìn đôi, đau mắt đỏ, chớp sáng hoặc ruồi bay bất thường."),
    ("Trẻ em bị sốt bao nhiêu là cao?",
     "Trẻ sốt trên 38.5°C là sốt cao, trên 39.5°C là sốt rất cao. Cần hạ sốt bằng paracetamol theo cân nặng và đưa đi khám nếu sốt kéo dài hoặc co giật."),
    ("Mất ngủ kéo dài ảnh hưởng thế nào?",
     "Mất ngủ kéo dài gây suy giảm trí nhớ, tăng huyết áp, rối loạn nội tiết, suy giảm miễn dịch, tăng nguy cơ trầm cảm và bệnh tim mạch."),
    ("Bệnh trĩ nên điều trị như nào?",
     "Trĩ nhẹ có thể điều chỉnh chế độ ăn nhiều chất xơ, uống đủ nước, dùng thuốc bôi/uống; trĩ nặng cần thủ thuật hoặc phẫu thuật theo chỉ định."),
    ("Ho kéo dài trên 3 tuần có sao không?",
     "Ho kéo dài trên 3 tuần được coi là ho mạn tính, có thể do viêm xoang sau, trào ngược, hen, COPD hoặc lao. Nên đi khám chuyên khoa hô hấp."),
    ("Đau lưng dưới thường do nguyên nhân gì?",
     "Đau lưng dưới phổ biến do căng cơ, thoái hóa cột sống, thoát vị đĩa đệm, tư thế sai, ít vận động. Một số trường hợp do bệnh thận hoặc viêm."),
    ("Phụ nữ mang thai cần khám những gì?",
     "Thai phụ cần khám thai định kỳ, siêu âm hình thái, sàng lọc dị tật, xét nghiệm máu, nước tiểu, tiểu đường thai kỳ, đo huyết áp."),
    ("Rối loạn tiền đình là gì?",
     "Rối loạn tiền đình là tình trạng mất thăng bằng, chóng mặt, buồn nôn do hệ thống tiền đình ở tai trong hoặc thần kinh bị ảnh hưởng."),
    ("Bệnh gout có điều trị được không?",
     "Gout không chữa khỏi hoàn toàn nhưng kiểm soát tốt bằng thuốc hạ acid uric, giảm đau đợt cấp, chế độ ăn ít purin và hạn chế rượu."),
    ("Ung thư cổ tử cung có phòng được không?",
     "Ung thư cổ tử cung có thể phòng ngừa hiệu quả bằng tiêm vaccine HPV, tầm soát PAP smear định kỳ và quan hệ tình dục an toàn."),
    ("Viêm phế quản khác viêm phổi ở điểm nào?",
     "Viêm phế quản là viêm ống dẫn khí lớn, chủ yếu ho đờm; viêm phổi là viêm nhu mô phổi, thường sốt cao, khó thở, nguy hiểm hơn."),
    ("Cholesterol cao nên ăn gì?",
     "Người cholesterol cao nên ăn nhiều rau, cá, yến mạch, hạt, hạn chế mỡ động vật, đồ chiên rán, nội tạng và tăng cường vận động."),
    ("Bệnh cận thị ở trẻ xử lý thế nào?",
     "Trẻ cận thị cần đo kính chính xác, cho học trong đủ sáng, hạn chế thiết bị điện tử, ra ngoài trời nhiều và khám mắt định kỳ 6 tháng."),
    ("Đau đầu migraine là gì?",
     "Migraine là đau đầu mạn tính theo cơn, thường đau nửa đầu, kèm buồn nôn, sợ ánh sáng/tiếng ồn, có thể có tiền triệu."),
    ("Viêm khớp dạng thấp nhận biết thế nào?",
     "Viêm khớp dạng thấp gây sưng đau đối xứng các khớp nhỏ bàn tay, cứng khớp buổi sáng trên 30 phút, kéo dài nhiều tuần."),
    ("Trẻ tiêm chủng đầy đủ gồm những mũi nào?",
     "Trẻ cần tiêm đủ các vaccine trong chương trình mở rộng: lao, bạch hầu, ho gà, uốn ván, bại liệt, viêm gan B, sởi, rubella, viêm não Nhật Bản."),
    ("Thế nào là tăng acid uric máu?",
     "Tăng acid uric máu là khi nồng độ acid uric vượt ngưỡng bình thường, có thể gây gout, sỏi thận nếu không kiểm soát."),
    ("Bệnh thận mạn tính có dấu hiệu gì?",
     "Bệnh thận mạn giai đoạn đầu thường không triệu chứng, giai đoạn sau có phù, tiểu ít, mệt mỏi, thiếu máu, tăng huyết áp."),
    ("Nấm candida âm đạo điều trị ra sao?",
     "Nấm candida âm đạo điều trị bằng thuốc kháng nấm đặt âm đạo hoặc uống theo chỉ định, vệ sinh đúng cách và hạn chế đồ ngọt."),
    ("Bệnh gan nhiễm mỡ có đáng lo không?",
     "Gan nhiễm mỡ nhẹ có thể hồi phục bằng giảm cân, ăn uống và vận động; gan nhiễm mỡ không cồn có thể tiến triển viêm gan, xơ gan."),
    ("Đi tiểu nhiều lần ban đêm là bệnh gì?",
     "Tiểu đêm nhiều lần có thể do phì đại tuyến tiền liệt, tiểu đường, suy tim, uống nhiều nước tối, nhiễm trùng đường tiểu."),
    ("Stress kéo dài gây ra hậu quả gì?",
     "Stress kéo dài làm suy giảm miễn dịch, rối loạn tiêu hóa, tăng huyết áp, mất ngủ, lo âu và tăng nguy cơ trầm cảm."),
    ("Bệnh zona thần kinh lây không?",
     "Zona có thể lây virus thủy đậu cho người chưa nhiễm qua tiếp xúc dịch mụn nước, nhưng không lây bệnh zona trực tiếp."),
    ("Khi nào cần mổ ruột thừa?",
     "Ruột thừa viêm cấp cần mổ sớm trong vòng 24-48 giờ từ khi có triệu chứng để tránh vỡ ruột thừa gây viêm phúc mạc."),
    ("Bệnh sốt xuất huyết có nguy hiểm không?",
     "Sốt xuất huyết có thể diễn tiến nặng gây sốc, chảy máu, suy đa tạng. Cần theo dõi sát và nhập viện khi có dấu hiệu cảnh báo."),
    ("Thiếu máu do thiếu sắt điều trị thế nào?",
     "Bổ sung sắt đường uống hoặc truyền theo chỉ định, kết hợp ăn thực phẩm giàu sắt như thịt đỏ, gan, rau xanh đậm, đậu."),
    ("Viêm đại tràng có triệu chứng gì?",
     "Viêm đại tràng gây đau bụng, rối loạn tiêu hóa, tiêu chảy hoặc táo bón xen kẽ, phân có thể nhầy hoặc máu, mệt mỏi."),
    ("Làm sao biết mình cận thị?",
     "Dấu hiệu cận thị gồm nhìn xa mờ, phải nheo mắt, mỏi mắt khi đọc, hay nhức đầu. Nên đo thị lực tại cơ sở chuyên khoa."),
    ("Bệnh Alzheimer là gì?",
     "Alzheimer là bệnh thoái hóa thần kinh gây sa sút trí nhớ, suy giảm nhận thức và rối loạn hành vi, chủ yếu ở người cao tuổi."),
    ("Dấu hiệu đột quỵ cần nhận biết?",
     "Dấu hiệu F.A.S.T: méo mặt, yếu tay, nói khó; kèm đau đầu dữ dội đột ngột, mất thị lực, mất thăng bằng. Cần đến cấp cứu ngay."),
    ("Bệnh Parkinson có chữa được không?",
     "Parkinson không chữa khỏi nhưng kiểm soát bằng thuốc (levodopa), vật lý trị liệu, phẫu thuật kích thích não sâu trong ca phù hợp."),
    ("Suy giáp có triệu chứng gì?",
     "Suy giáp gây mệt mỏi, tăng cân, sợ lạnh, da khô, tóc rụng, trầm cảm, chậm nhịp tim. Cần xét nghiệm TSH để chẩn đoán."),
    ("Cường giáp khác suy giáp thế nào?",
     "Cường giáp là tăng hormone tuyến giáp gây sụt cân, tim đập nhanh, run tay, sợ nóng, tiêu chảy; ngược với suy giáp."),
    ("Viêm loét dạ dày có cần nội soi?",
     "Nội soi dạ dày giúp chẩn đoán chính xác viêm loét, sinh thiết tìm H.pylori, loại trừ ung thư; được khuyến cáo cho triệu chứng dai dẳng."),
    ("Bệnh vảy nến là gì?",
     "Vảy nến là bệnh tự miễn mạn tính, gây mảng da đỏ có vảy trắng, ngứa; điều trị bằng thuốc bôi, uống, ánh sáng trị liệu."),
    ("Hội chứng ruột kích thích nhận biết?",
     "Hội chứng ruột kích thích có đau bụng tái diễn, thay đổi thói quen đi ngoài (tiêu chảy/táo bón), liên quan stress, thức ăn."),
    ("Bệnh động kinh có chữa được không?",
     "Động kinh kiểm soát tốt bằng thuốc chống động kinh; khoảng 70% bệnh nhân hết cơn. Một số ca cần phẫu thuật hoặc kích thích thần kinh phế vị."),
    ("Phình động mạch chủ là gì?",
     "Phình động mạch chủ là tình trạng giãn bất thường thành động mạch chủ, nguy cơ vỡ gây tử vong; cần theo dõi và can thiệp kịp thời."),
    ("Bệnh lao phổi điều trị bao lâu?",
     "Phác đồ lao phổi chuẩn kéo dài 6 tháng (2 tháng tấn công + 4 tháng duy trì), cần tuân thủ uống thuốc đầy đủ để tránh kháng thuốc."),
]

def gen_medical_qa_sample(i):
    q, a = random.choice(MEDICAL_QA)
    return {
        "id": f"e2e_med_{i:04d}",
        "category": "general_medical_qa",
        "needs_recommendation": False,
        "has_location": False,
        "user_query": q,
        "ground_truth": a,
    }

# -----------------------------------------------------------
# 5. SINH NHÓM 4: symptom_advice (80)
# -----------------------------------------------------------

SYMPTOM_ADVICE = [
    ("Dạo này tôi hay bị chóng mặt khi đứng dậy, nên làm gì?",
     "Chóng mặt khi đứng dậy có thể do hạ huyết áp tư thế, thiếu máu, tiền đình. Nên uống đủ nước, đứng dậy từ từ, đi khám nội hoặc tim mạch."),
    ("Tôi hay bị đau đầu vào buổi sáng, có sao không?",
     "Đau đầu buổi sáng có thể do ngưng thở khi ngủ, căng thẳng, thiếu ngủ, tăng huyết áp. Nếu dai dẳng nên đi khám thần kinh."),
    ("Em bị ngứa da toàn thân về đêm, nên kiểm tra gì?",
     "Ngứa về đêm có thể do dị ứng, ghẻ, gan mật, đái tháo đường. Bạn nên khám da liễu hoặc nội tổng quát để tìm nguyên nhân."),
    ("Thỉnh thoảng tôi hồi hộp tim đập nhanh không rõ lý do.",
     "Triệu chứng hồi hộp có thể là rối loạn nhịp tim, cường giáp, lo âu. Nên đo điện tim và khám tim mạch để đánh giá."),
    ("Tôi bị ho khan kéo dài 2 tháng rồi, xử lý sao?",
     "Ho khan trên 8 tuần cần loại trừ trào ngược, hen, viêm xoang sau, lao. Hãy khám hô hấp và chụp Xquang phổi."),
    ("Em bị đau bụng dưới bên phải khi vận động.",
     "Đau bụng dưới phải có thể do ruột thừa, buồng trứng, cơ bụng. Nếu kèm sốt hoặc đau tăng nên đến cấp cứu hoặc khám ngoại khoa."),
    ("Tôi hay quên, làm sao cải thiện?",
     "Hay quên có thể do stress, thiếu ngủ, thiếu B12, suy giáp, sa sút trí tuệ sớm. Nên khám thần kinh và xét nghiệm nếu kéo dài."),
    ("Kinh nguyệt của tôi thất thường mấy tháng nay.",
     "Rối loạn kinh nguyệt có thể do nội tiết, buồng trứng đa nang, stress, tuyến giáp. Nên khám sản phụ khoa và xét nghiệm hormone."),
    ("Tôi ngáy to khi ngủ, có cần khám không?",
     "Ngáy to kèm ngừng thở khi ngủ, buồn ngủ ban ngày có thể là hội chứng ngưng thở khi ngủ, nên khám hô hấp và đo đa ký giấc ngủ."),
    ("Mỗi lần ăn xong tôi đau bụng âm ỉ.",
     "Đau bụng sau ăn có thể do viêm dạ dày, trào ngược, hội chứng ruột kích thích, sỏi mật. Nên khám tiêu hóa và có thể cần nội soi."),
    ("Dạo này tôi khó thở khi leo cầu thang.",
     "Khó thở khi gắng sức có thể do thiếu máu, bệnh tim, bệnh phổi, thừa cân. Nên khám tim mạch hoặc hô hấp để đánh giá."),
    ("Tôi đau mỏi vai gáy do ngồi máy tính nhiều.",
     "Đau mỏi vai gáy do ngồi lâu có thể được cải thiện bằng điều chỉnh tư thế, giãn cơ, massage; nếu kéo dài nên khám cơ xương khớp."),
    ("Em bị nổi mề đay liên tục mấy tuần nay.",
     "Mề đay kéo dài trên 6 tuần là mạn tính, có thể do dị ứng thức ăn, thuốc, tự miễn. Nên khám dị ứng miễn dịch để tìm nguyên nhân."),
    ("Tôi hay bị trào ngược dạ dày thực quản.",
     "Trào ngược cần thay đổi lối sống (giảm cân, bỏ thuốc lá, nâng đầu giường), dùng thuốc ức chế acid; khám tiêu hóa nếu kéo dài."),
    ("Chân tôi phù vào cuối ngày, có bình thường không?",
     "Phù chân cuối ngày có thể do suy tĩnh mạch, đứng nhiều; nếu kèm khó thở, tiểu ít cần loại trừ bệnh tim, thận, gan."),
    ("Tôi tiểu rát và đi nhiều lần.",
     "Triệu chứng gợi ý nhiễm trùng đường tiểu, cần xét nghiệm nước tiểu và khám tiết niệu, uống nhiều nước và dùng kháng sinh theo chỉ định."),
    ("Tôi bị rụng tóc nhiều bất thường.",
     "Rụng tóc nhiều có thể do stress, thiếu sắt, rối loạn tuyến giáp, nội tiết, di truyền. Nên khám da liễu hoặc nội tiết."),
    ("Em thấy mình hay cáu gắt và buồn không lý do.",
     "Triệu chứng có thể liên quan rối loạn lo âu, trầm cảm hoặc nội tiết. Nên khám tâm thần hoặc nội tiết để được đánh giá."),
    ("Tôi bị ngứa vùng kín, cần làm gì?",
     "Ngứa vùng kín có thể do nấm, vi khuẩn, trùng roi. Nên khám sản phụ khoa hoặc tiết niệu, tránh tự mua thuốc dùng."),
    ("Tôi đau nhức răng khi ăn đồ lạnh.",
     "Ê buốt răng khi ăn lạnh có thể do mòn men răng, sâu răng, viêm tủy. Nên khám răng hàm mặt để xử lý kịp thời."),
    ("Em bị mất ngủ kéo dài 1 tháng rồi.",
     "Mất ngủ mạn cần đánh giá nguyên nhân (stress, lo âu, bệnh lý), vệ sinh giấc ngủ tốt; có thể cần khám tâm thần để hỗ trợ."),
    ("Dạo này tôi ăn nhiều nhưng vẫn sụt cân.",
     "Ăn nhiều nhưng sụt cân có thể do cường giáp, tiểu đường, nhiễm trùng mạn, ung thư. Cần khám nội và làm xét nghiệm toàn diện."),
    ("Tôi bị nóng rát vùng thượng vị sau ăn.",
     "Nóng rát thượng vị gợi ý trào ngược, viêm dạ dày. Nên giảm ăn cay, dầu mỡ, cà phê; khám tiêu hóa nếu kéo dài."),
    ("Tôi bị đau khớp gối khi lên xuống cầu thang.",
     "Đau khớp gối khi vận động có thể do thoái hóa, tổn thương sụn chêm. Nên khám cơ xương khớp và có thể chụp MRI."),
    ("Em hay bị tê bì tay chân.",
     "Tê bì tay chân có thể do thoát vị đĩa đệm, thiếu vitamin B, tiểu đường, hội chứng ống cổ tay. Nên khám thần kinh."),
]

def gen_symptom_sample(i):
    q, a = random.choice(SYMPTOM_ADVICE)
    return {
        "id": f"e2e_sym_{i:04d}",
        "category": "symptom_advice",
        "needs_recommendation": False,
        "has_location": False,
        "user_query": q,
        "ground_truth": a,
    }

# -----------------------------------------------------------
# 6. SINH NHÓM 5: greeting_smalltalk (30)
# -----------------------------------------------------------

GREETINGS = [
    ("Xin chào",
     "Xin chào! Tôi là trợ lý Healytics. Tôi có thể giúp bạn tìm dịch vụ y tế và tư vấn sức khỏe. Bạn cần hỗ trợ gì ạ?"),
    ("Chào bạn",
     "Chào bạn! Bạn đang có vấn đề sức khỏe gì hoặc muốn tìm cơ sở khám chữa bệnh nào không?"),
    ("Hi",
     "Chào bạn! Mình là trợ lý ảo y tế Healytics, sẵn sàng hỗ trợ bạn tìm dịch vụ hoặc trả lời câu hỏi sức khỏe."),
    ("Hello",
     "Xin chào bạn! Tôi có thể giúp tư vấn sức khỏe hoặc gợi ý phòng khám phù hợp. Bạn cần gì ạ?"),
    ("Bạn là ai?",
     "Tôi là trợ lý ảo Healytics, chuyên hỗ trợ bạn tìm kiếm dịch vụ y tế và cung cấp thông tin sức khỏe tham khảo."),
    ("Bạn làm được gì?",
     "Tôi có thể giới thiệu phòng khám, bệnh viện phù hợp theo chuyên khoa, trả lời câu hỏi sức khỏe phổ thông và hỗ trợ đặt lịch."),
    ("Cảm ơn bạn",
     "Không có gì ạ. Nếu còn thắc mắc gì thêm, bạn cứ hỏi tôi nhé."),
    ("Tạm biệt",
     "Tạm biệt bạn, chúc bạn nhiều sức khỏe! Hẹn gặp lại."),
    ("Bạn có thể giúp tôi không?",
     "Chắc chắn rồi, bạn cần tư vấn về sức khỏe hay tìm dịch vụ y tế nào ạ?"),
    ("Ok thanks",
     "Không có gì, rất vui được hỗ trợ bạn."),
    ("Hello bot",
     "Chào bạn! Bạn cần tư vấn sức khỏe hay tìm phòng khám không?"),
    ("Bạn hoạt động thế nào?",
     "Tôi sử dụng AI để hiểu câu hỏi, tra cứu thông tin y tế và gợi ý dịch vụ từ cơ sở dữ liệu của Healytics."),
    ("Hôm nay bạn có khỏe không?",
     "Tôi là trợ lý AI nên luôn sẵn sàng giúp bạn ạ. Bạn cần hỗ trợ gì về sức khỏe không?"),
    ("Bot gì vậy?",
     "Tôi là trợ lý y tế Healytics, hỗ trợ tư vấn sức khỏe và gợi ý dịch vụ khám chữa bệnh."),
    ("Được rồi",
     "Nếu bạn cần thêm trợ giúp thì cứ hỏi tôi nhé."),
]

def gen_greeting_sample(i):
    q, a = random.choice(GREETINGS)
    return {
        "id": f"e2e_grt_{i:04d}",
        "category": "greeting_smalltalk",
        "needs_recommendation": False,
        "has_location": False,
        "user_query": q,
        "ground_truth": a,
    }

# -----------------------------------------------------------
# 7. SINH NHÓM 6: follow_up_questions (20)
# -----------------------------------------------------------

FOLLOWUPS = [
    ("Tôi nên đi khám lúc nào?",
     "Bạn nên đi khám sớm khi có triệu chứng bất thường kéo dài, không cải thiện hoặc nặng lên; đặc biệt nếu có dấu hiệu cảnh báo."),
    ("Cần làm xét nghiệm gì?",
     "Tùy triệu chứng bác sĩ sẽ chỉ định xét nghiệm máu, nước tiểu, siêu âm hoặc hình ảnh học phù hợp để chẩn đoán chính xác."),
    ("Chi phí khám khoảng bao nhiêu?",
     "Chi phí khám tùy cơ sở và chuyên khoa, thường dao động 150.000-500.000 đồng cho khám thường, cao hơn nếu có xét nghiệm."),
    ("Tôi nên uống thuốc gì?",
     "Việc dùng thuốc cần bác sĩ thăm khám và kê đơn, tôi không thể chỉ định thuốc thay bác sĩ được bạn nhé."),
    ("Có thể khám tại nhà không?",
     "Một số dịch vụ hỗ trợ khám tại nhà, bạn có thể tìm trong danh sách dịch vụ của Healytics hoặc hỏi cụ thể cơ sở."),
    ("Có cần nhịn ăn trước khi khám không?",
     "Nếu làm xét nghiệm máu như đường huyết, mỡ máu thì cần nhịn ăn 8-12 tiếng. Các khám khác thường không cần."),
    ("Khám tổng quát bao gồm những gì?",
     "Khám tổng quát thường gồm khám lâm sàng, đo huyết áp, xét nghiệm máu, nước tiểu, siêu âm ổ bụng, chụp X-quang ngực, điện tim."),
    ("Tôi nên chuẩn bị gì?",
     "Bạn nên mang theo giấy tờ tùy thân, hồ sơ khám cũ, danh sách thuốc đang dùng và ghi lại triệu chứng, thời gian xuất hiện."),
    ("Kết quả có ngay không?",
     "Kết quả khám cơ bản và siêu âm thường có trong ngày; xét nghiệm đặc biệt, giải phẫu bệnh có thể mất vài ngày đến 1 tuần."),
    ("Bác sĩ nào giỏi?",
     "Bạn có thể tham khảo đánh giá của bệnh nhân khác, bằng cấp, kinh nghiệm của bác sĩ trên thông tin dịch vụ được gợi ý."),
]

def gen_followup_sample(i):
    q, a = random.choice(FOLLOWUPS)
    return {
        "id": f"e2e_fu_{i:04d}",
        "category": "follow_up_questions",
        "needs_recommendation": False,
        "has_location": False,
        "user_query": q,
        "ground_truth": a,
    }

# -----------------------------------------------------------
# 8. BUILD FULL DATASET
# -----------------------------------------------------------

def build():
    samples = []
    for i in range(120):
        samples.append(gen_loc_sample(i))
    for i in range(120):
        samples.append(gen_generic_sample(i))
    for i in range(130):
        samples.append(gen_medical_qa_sample(i))
    for i in range(80):
        samples.append(gen_symptom_sample(i))
    for i in range(30):
        samples.append(gen_greeting_sample(i))
    for i in range(20):
        samples.append(gen_followup_sample(i))

    random.shuffle(samples)
    for idx, s in enumerate(samples):
        s["order"] = idx

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUT_PATH.write_text(json.dumps(samples, ensure_ascii=False, indent=2), encoding="utf-8")

    from collections import Counter
    cnt = Counter(s["category"] for s in samples)
    print(f"Wrote {len(samples)} samples to {OUT_PATH}")
    for k, v in cnt.most_common():
        print(f"  - {k:<36s} : {v}")

if __name__ == "__main__":
    build()
