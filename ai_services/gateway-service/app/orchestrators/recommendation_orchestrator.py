# app/orchestrators/recommendation_orchestrator.py
from datetime import datetime, timezone
from typing import Any, Dict
import json
import logging
import httpx
from fastapi import HTTPException
from app.clients.recommender_client import RecommenderClient
from app.clients.backend_ai_client import BackendAIClient
from app.core.config import settings

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Mock service data — thay bằng gọi API thật khi backend sẵn sàng
# ---------------------------------------------------------------------------

MOCK_SERVICES: Dict[str, Dict] = {
    "SV001": {"service_id": "SV001", "name": "Tư vấn tim mạch trực tuyến", "description": "Dịch vụ tư vấn sức khỏe tim mạch với bác sĩ chuyên khoa. Bao gồm đánh giá nguy cơ bệnh tim mạch, tư vấn chế độ dinh dưỡng phòng ngừa, hướng dẫn tập luyện an toàn.", "image_url": "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 980, "price": {"amount": 350000, "currency": "VND"}, "staff_name": "BS Nguyễn Văn A", "rating": {"average": 4.8, "total_reviews": 210}, "location": {"address": "45 Lý Thường Kiệt", "district": "Quận 10", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T09:00:00", "2026-03-10T14:00:00"]},
    "SV002": {"service_id": "SV002", "name": "Khám sức khỏe tổng quát", "description": "Gói khám sức khỏe định kỳ toàn diện bao gồm xét nghiệm máu, siêu âm, đo điện tim, chụp X-quang ngực. Phát hiện sớm các bệnh lý tim mạch, đái tháo đường, ung thư.", "image_url": "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400&h=300&fit=crop", "badge": "Premium", "booked_count": 1200, "price": {"amount": 800000, "currency": "VND"}, "staff_name": "BS Trần Thị B", "rating": {"average": 4.9, "total_reviews": 340}, "location": {"address": "123 Nguyễn Huệ", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T08:00:00", "2026-03-11T10:00:00"]},
    "SV003": {"service_id": "SV003", "name": "Tư vấn đái tháo đường", "description": "Chương trình quản lý đái tháo đường toàn diện với bác sĩ nội tiết. Hướng dẫn theo dõi đường huyết, kế hoạch ăn uống, tư vấn sử dụng thuốc.", "image_url": "https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 650, "price": {"amount": 400000, "currency": "VND"}, "staff_name": "BS Lê Văn C", "rating": {"average": 4.7, "total_reviews": 180}, "location": {"address": "88 Điện Biên Phủ", "district": "Bình Thạnh", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T09:00:00", "2026-03-12T14:00:00"]},
    "SV004": {"service_id": "SV004", "name": "Tư vấn huyết áp cao", "description": "Chương trình quản lý và điều trị huyết áp cao với bác sĩ tim mạch. Theo dõi huyết áp qua app, tư vấn thuốc, chế độ ăn ít muối, quản lý stress.", "image_url": "https://images.unsplash.com/photo-1628595351029-c2bf17511435?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 870, "price": {"amount": 350000, "currency": "VND"}, "staff_name": "BS Phạm Thị D", "rating": {"average": 4.6, "total_reviews": 155}, "location": {"address": "200 Hoàng Văn Thụ", "district": "Phú Nhuận", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T10:00:00", "2026-03-13T15:00:00"]},
    "SV005": {"service_id": "SV005", "name": "Khám phụ khoa định kỳ", "description": "Gói khám phụ khoa toàn diện cho phụ nữ bao gồm siêu âm vú, buồng trứng, xét nghiệm PAP. Phát hiện sớm các bệnh lý phụ khoa.", "image_url": "https://images.unsplash.com/photo-1551076805-e1869033e561?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 740, "price": {"amount": 500000, "currency": "VND"}, "staff_name": "BS Ngô Thị E", "rating": {"average": 4.9, "total_reviews": 220}, "location": {"address": "56 Cách Mạng Tháng 8", "district": "Quận 3", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T08:00:00", "2026-03-12T11:00:00"]},
    "SV006": {"service_id": "SV006", "name": "Tư vấn sức khỏe trẻ em", "description": "Dịch vụ tư vấn sức khỏe và phát triển cho trẻ em 0-12 tuổi. Tư vấn dinh dưỡng, tiêm chủng, theo dõi phát triển.", "image_url": "https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 560, "price": {"amount": 300000, "currency": "VND"}, "staff_name": "BS Vũ Văn F", "rating": {"average": 4.8, "total_reviews": 190}, "location": {"address": "12 Nguyễn Thị Minh Khai", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T14:00:00", "2026-03-11T16:00:00"]},
    "SV007": {"service_id": "SV007", "name": "Khám da liễu chuyên sâu", "description": "Khám và điều trị các bệnh da liễu như mụn trứng cá, viêm da, nấm da. Sử dụng công nghệ soi da hiện đại.", "image_url": "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 430, "price": {"amount": 450000, "currency": "VND"}, "staff_name": "BS Đặng Thị G", "rating": {"average": 4.7, "total_reviews": 140}, "location": {"address": "78 Lê Lợi", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-12T09:00:00", "2026-03-13T14:00:00"]},
    "SV008": {"service_id": "SV008", "name": "Tư vấn tiêu hóa", "description": "Tư vấn và điều trị các bệnh lý đường tiêu hóa như viêm dạ dày, trào ngược, hội chứng ruột kích thích.", "image_url": "https://images.unsplash.com/photo-1585854467604-cf2080ebe05a?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 390, "price": {"amount": 350000, "currency": "VND"}, "staff_name": "BS Hoàng Văn H", "rating": {"average": 4.5, "total_reviews": 110}, "location": {"address": "34 Pasteur", "district": "Quận 3", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T11:00:00", "2026-03-12T15:00:00"]},
    "SV009": {"service_id": "SV009", "name": "Khám mắt và đo thị lực", "description": "Khám mắt tổng quát bao gồm đo thị lực, nhãn áp, khám đáy mắt. Phát hiện cận thị, viễn thị, glaucoma.", "image_url": "https://images.unsplash.com/photo-1574258495973-f010dfbb5371?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 510, "price": {"amount": 250000, "currency": "VND"}, "staff_name": "BS Lý Thị I", "rating": {"average": 4.6, "total_reviews": 165}, "location": {"address": "90 Nguyễn Đình Chiểu", "district": "Quận 3", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T10:00:00", "2026-03-13T09:00:00"]},
    "SV010": {"service_id": "SV010", "name": "Tư vấn cai thuốc lá", "description": "Chương trình cai thuốc lá với bác sĩ và nhà tâm lý. Đánh giá mức độ nghiện, kế hoạch cai từng bước.", "image_url": "https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?w=400&h=300&fit=crop", "badge": "Mới", "booked_count": 210, "price": {"amount": 300000, "currency": "VND"}, "staff_name": "BS Phan Văn J", "rating": {"average": 4.4, "total_reviews": 75}, "location": {"address": "15 Võ Văn Tần", "district": "Quận 3", "city": "Hồ Chí Minh"}, "slots": ["2026-03-12T14:00:00", "2026-03-14T10:00:00"]},
    "SV011": {"service_id": "SV011", "name": "Khám răng định kỳ", "description": "Khám răng miệng tổng quát bao gồm cạo vôi răng, đánh bóng, kiểm tra sâu răng, viêm nướu.", "image_url": "https://images.unsplash.com/photo-1606811841689-23dfddce3e95?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 920, "price": {"amount": 200000, "currency": "VND"}, "staff_name": "BS Trương Thị K", "rating": {"average": 4.7, "total_reviews": 280}, "location": {"address": "67 Hai Bà Trưng", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T08:30:00", "2026-03-11T13:00:00"]},
    "SV012": {"service_id": "SV012", "name": "Tư vấn xương khớp", "description": "Tư vấn và điều trị các bệnh lý xương khớp như viêm khớp, thoái hóa khớp, gout, loãng xương.", "image_url": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 670, "price": {"amount": 400000, "currency": "VND"}, "staff_name": "BS Đinh Văn L", "rating": {"average": 4.8, "total_reviews": 195}, "location": {"address": "23 Trần Hưng Đạo", "district": "Quận 5", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T09:00:00", "2026-03-13T11:00:00"]},
    "SV013": {"service_id": "SV013", "name": "Khám tai mũi họng", "description": "Khám và điều trị viêm xoang, viêm amidan, polyp mũi, viêm tai giữa. Sử dụng nội soi hiện đại.", "image_url": "https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 480, "price": {"amount": 300000, "currency": "VND"}, "staff_name": "BS Bùi Thị M", "rating": {"average": 4.6, "total_reviews": 130}, "location": {"address": "111 Lý Tự Trọng", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T10:30:00", "2026-03-12T14:30:00"]},
    "SV014": {"service_id": "SV014", "name": "Tư vấn gan mật", "description": "Tư vấn về sức khỏe gan mật, điều trị gan nhiễm mỡ, viêm gan, xơ gan, sỏi mật.", "image_url": "https://images.unsplash.com/photo-1530026405186-ed1f139313f8?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 320, "price": {"amount": 380000, "currency": "VND"}, "staff_name": "BS Lưu Văn N", "rating": {"average": 4.5, "total_reviews": 98}, "location": {"address": "55 Nguyễn Trãi", "district": "Quận 5", "city": "Hồ Chí Minh"}, "slots": ["2026-03-13T09:00:00", "2026-03-14T14:00:00"]},
    "SV015": {"service_id": "SV015", "name": "Khám tiết niệu", "description": "Khám và điều trị viêm bàng quang, sỏi thận, nhiễm trùng tiết niệu, phì đại tuyến tiền liệt.", "image_url": "https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 290, "price": {"amount": 420000, "currency": "VND"}, "staff_name": "BS Mai Văn O", "rating": {"average": 4.6, "total_reviews": 88}, "location": {"address": "77 Nguyễn Văn Cừ", "district": "Quận 5", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T11:00:00", "2026-03-13T15:00:00"]},
    "SV016": {"service_id": "SV016", "name": "Tâm lý trị liệu căng thẳng", "description": "Liệu trình tâm lý điều trị căng thẳng, lo âu và trầm cảm nhẹ. Sử dụng CBT kết hợp mindfulness.", "image_url": "https://images.unsplash.com/photo-1527137342181-19aab11a8ee8?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 540, "price": {"amount": 500000, "currency": "VND"}, "staff_name": "ThS Nguyễn Thị P", "rating": {"average": 4.9, "total_reviews": 175}, "location": {"address": "14 Ngô Đức Kế", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T15:00:00", "2026-03-12T10:00:00"]},
    "SV017": {"service_id": "SV017", "name": "Lớp học thiền định mindfulness", "description": "Khóa học 8 tuần về thiền định chánh niệm giúp giảm stress, cải thiện tập trung và giấc ngủ.", "image_url": "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400&h=300&fit=crop", "badge": "Hot", "booked_count": 730, "price": {"amount": 250000, "currency": "VND"}, "staff_name": "GV Trần Văn Q", "rating": {"average": 4.8, "total_reviews": 240}, "location": {"address": "38 Lê Duẩn", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T07:00:00", "2026-03-12T07:00:00"]},
    "SV018": {"service_id": "SV018", "name": "Tư vấn tâm lý gia đình", "description": "Tư vấn tâm lý cho mâu thuẫn vợ chồng, xung đột cha mẹ con cái, khủng hoảng hôn nhân.", "image_url": "https://images.unsplash.com/photo-1511895426328-dc8714191011?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 310, "price": {"amount": 600000, "currency": "VND"}, "staff_name": "ThS Lê Thị R", "rating": {"average": 4.7, "total_reviews": 102}, "location": {"address": "29 Đinh Tiên Hoàng", "district": "Bình Thạnh", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T14:00:00", "2026-03-14T10:00:00"]},
    "SV019": {"service_id": "SV019", "name": "Tư vấn tâm lý trẻ em", "description": "Tư vấn tâm lý cho trẻ em và thanh thiếu niên gặp vấn đề về học tập, hành vi, cảm xúc.", "image_url": "https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 280, "price": {"amount": 450000, "currency": "VND"}, "staff_name": "ThS Phạm Văn S", "rating": {"average": 4.8, "total_reviews": 95}, "location": {"address": "62 Nguyễn Bỉnh Khiêm", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-12T09:00:00", "2026-03-13T14:00:00"]},
    "SV020": {"service_id": "SV020", "name": "Trị liệu lo âu xã hội", "description": "Chương trình điều trị lo âu xã hội, sợ giao tiếp, sợ nói trước đám đông. Sử dụng CBT và exposure therapy.", "image_url": "https://images.unsplash.com/photo-1544027993-37dbfe43562a?w=400&h=300&fit=crop", "badge": "Mới", "booked_count": 190, "price": {"amount": 500000, "currency": "VND"}, "staff_name": "ThS Hoàng Thị T", "rating": {"average": 4.6, "total_reviews": 67}, "location": {"address": "18 Nam Kỳ Khởi Nghĩa", "district": "Quận 3", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T15:00:00", "2026-03-14T09:00:00"]},
    "SV021": {"service_id": "SV021", "name": "Tư vấn trầm cảm", "description": "Tư vấn và điều trị trầm cảm với nhà tâm lý lâm sàng. Kết hợp thuốc và tâm lý trị liệu, theo dõi hàng tuần.", "image_url": "https://images.unsplash.com/photo-1493836512294-502baa1986e2?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 420, "price": {"amount": 550000, "currency": "VND"}, "staff_name": "ThS Vũ Thị U", "rating": {"average": 4.9, "total_reviews": 145}, "location": {"address": "101 Trần Quốc Thảo", "district": "Quận 3", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T16:00:00", "2026-03-12T11:00:00"]},
    "SV022": {"service_id": "SV022", "name": "Quản lý cơn giận", "description": "Chương trình quản lý cơn giận và cảm xúc tiêu cực. Học cách nhận biết trigger, kỹ thuật kiểm soát cảm xúc.", "image_url": "https://images.unsplash.com/photo-1541199249251-f713e6145474?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 250, "price": {"amount": 450000, "currency": "VND"}, "staff_name": "ThS Đặng Văn V", "rating": {"average": 4.5, "total_reviews": 80}, "location": {"address": "47 Bùi Thị Xuân", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-13T10:00:00", "2026-03-14T15:00:00"]},
    "SV023": {"service_id": "SV023", "name": "Tư vấn nghiện game và mạng xã hội", "description": "Tư vấn và điều trị nghiện game, internet, mạng xã hội. Kế hoạch cai nghiện từng bước.", "image_url": "https://images.unsplash.com/photo-1542751371-adc38448a05e?w=400&h=300&fit=crop", "badge": "Mới", "booked_count": 160, "price": {"amount": 400000, "currency": "VND"}, "staff_name": "ThS Lý Văn W", "rating": {"average": 4.4, "total_reviews": 52}, "location": {"address": "33 Trương Định", "district": "Quận 3", "city": "Hồ Chí Minh"}, "slots": ["2026-03-12T16:00:00", "2026-03-14T11:00:00"]},
    "SV024": {"service_id": "SV024", "name": "Tư vấn hôn nhân trước kết hôn", "description": "Tư vấn cho các cặp đôi chuẩn bị kết hôn về kỹ năng giao tiếp, quản lý tài chính gia đình.", "image_url": "https://images.unsplash.com/photo-1519225421980-715cb0215aed?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 340, "price": {"amount": 700000, "currency": "VND"}, "staff_name": "ThS Phan Thị X", "rating": {"average": 4.8, "total_reviews": 115}, "location": {"address": "25 Đoàn Thị Điểm", "district": "Phú Nhuận", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T10:00:00", "2026-03-13T16:00:00"]},
    "SV025": {"service_id": "SV025", "name": "Trị liệu chấn thương tâm lý", "description": "Điều trị chấn thương tâm lý sau tai nạn, bạo lực, lạm dụng. Sử dụng EMDR và trauma-focused CBT.", "image_url": "https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 270, "price": {"amount": 650000, "currency": "VND"}, "staff_name": "ThS Bùi Văn Y", "rating": {"average": 4.9, "total_reviews": 90}, "location": {"address": "52 Nguyễn Du", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T14:00:00", "2026-03-12T16:00:00"]},
    "SV026": {"service_id": "SV026", "name": "Tư vấn rối loạn ăn uống", "description": "Tư vấn và điều trị anorexia, bulimia, binge eating. Kết hợp tâm lý trị liệu và tư vấn dinh dưỡng.", "image_url": "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 180, "price": {"amount": 550000, "currency": "VND"}, "staff_name": "ThS Trương Thị Z", "rating": {"average": 4.7, "total_reviews": 60}, "location": {"address": "16 Hồ Xuân Hương", "district": "Quận 3", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T11:00:00", "2026-03-14T14:00:00"]},
    "SV027": {"service_id": "SV027", "name": "Nhóm hỗ trợ tâm lý", "description": "Nhóm hỗ trợ tâm lý cho người gặp vấn đề tương tự như trầm cảm, lo âu, mất mát. Điều hành bởi nhà tâm lý.", "image_url": "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=400&h=300&fit=crop", "badge": "Miễn phí", "booked_count": 890, "price": {"amount": 0, "currency": "VND"}, "staff_name": "ThS Lưu Thị AA", "rating": {"average": 4.6, "total_reviews": 310}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T19:00:00", "2026-03-12T19:00:00"]},
    "SV028": {"service_id": "SV028", "name": "Coaching phát triển bản thân", "description": "Coaching cá nhân giúp phát triển bản thân, đạt mục tiêu nghề nghiệp và cuộc sống.", "image_url": "https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=400&h=300&fit=crop", "badge": "Hot", "booked_count": 610, "price": {"amount": 800000, "currency": "VND"}, "staff_name": "Coach Nguyễn Văn BB", "rating": {"average": 4.8, "total_reviews": 200}, "location": {"address": "88 Lê Văn Sỹ", "district": "Quận 3", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T18:00:00", "2026-03-13T18:00:00"]},
    "SV029": {"service_id": "SV029", "name": "Tư vấn nghề nghiệp", "description": "Tư vấn định hướng nghề nghiệp, chuyển đổi nghề, phát triển sự nghiệp dài hạn.", "image_url": "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 450, "price": {"amount": 500000, "currency": "VND"}, "staff_name": "Chuyên gia Trần Thị CC", "rating": {"average": 4.7, "total_reviews": 150}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T17:00:00", "2026-03-12T17:00:00"]},
    "SV030": {"service_id": "SV030", "name": "Tư vấn cân bằng công việc cuộc sống", "description": "Tư vấn cân bằng giữa công việc và cuộc sống cá nhân, phòng ngừa burnout.", "image_url": "https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 380, "price": {"amount": 450000, "currency": "VND"}, "staff_name": "Coach Lê Văn DD", "rating": {"average": 4.6, "total_reviews": 125}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T19:00:00", "2026-03-13T19:00:00"]},
    "SV031": {"service_id": "SV031", "name": "Chương trình Yoga trị liệu", "description": "Yoga chuyên biệt cho người có vấn đề cột sống, đau lưng mãn tính. Thiết kế bởi chuyên gia vật lý trị liệu.", "image_url": "https://images.unsplash.com/photo-1575052814086-f385e2e2ad1b?w=400&h=300&fit=crop", "badge": "Hot", "booked_count": 850, "price": {"amount": 350000, "currency": "VND"}, "staff_name": "HLV Phạm Thị EE", "rating": {"average": 4.9, "total_reviews": 290}, "location": {"address": "45 Nguyễn Thượng Hiền", "district": "Bình Thạnh", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T06:00:00", "2026-03-12T17:00:00"]},
    "SV032": {"service_id": "SV032", "name": "Chương trình gym cá nhân hóa", "description": "Lịch tập gym thiết kế riêng theo mục tiêu tăng cơ, giảm mỡ, tăng sức bền. Theo dõi với huấn luyện viên cá nhân.", "image_url": "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&h=300&fit=crop", "badge": "Premium", "booked_count": 1100, "price": {"amount": 1200000, "currency": "VND"}, "staff_name": "HLV Vũ Văn FF", "rating": {"average": 4.8, "total_reviews": 380}, "location": {"address": "120 Đinh Bộ Lĩnh", "district": "Bình Thạnh", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T06:00:00", "2026-03-11T06:00:00"]},
    "SV033": {"service_id": "SV033", "name": "Lớp Pilates cải thiện tư thế", "description": "Pilates tập trung vào core, cải thiện tư thế, tăng linh hoạt. Phù hợp người làm văn phòng, đau cổ vai gáy.", "image_url": "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 620, "price": {"amount": 400000, "currency": "VND"}, "staff_name": "HLV Hoàng Thị GG", "rating": {"average": 4.7, "total_reviews": 205}, "location": {"address": "30 Phan Xích Long", "district": "Phú Nhuận", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T07:00:00", "2026-03-13T17:00:00"]},
    "SV034": {"service_id": "SV034", "name": "Chạy bộ cùng huấn luyện viên", "description": "Chương trình chạy bộ từ cơ bản đến nâng cao. Kỹ thuật chạy đúng cách, phòng tránh chấn thương, chuẩn bị marathon.", "image_url": "https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 490, "price": {"amount": 300000, "currency": "VND"}, "staff_name": "HLV Đặng Văn HH", "rating": {"average": 4.6, "total_reviews": 170}, "location": {"address": "Công viên Gia Định", "district": "Gò Vấp", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T05:30:00", "2026-03-12T05:30:00"]},
    "SV035": {"service_id": "SV035", "name": "Bơi lội trị liệu", "description": "Bơi lội trị liệu cho người chấn thương, phục hồi sau phẫu thuật, người cao tuổi. Không tác động mạnh lên khớp.", "image_url": "https://images.unsplash.com/photo-1560090995-01632a28895b?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 360, "price": {"amount": 350000, "currency": "VND"}, "staff_name": "HLV Lý Thị II", "rating": {"average": 4.8, "total_reviews": 120}, "location": {"address": "15 Lam Sơn", "district": "Bình Thạnh", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T08:00:00", "2026-03-13T08:00:00"]},
    "SV036": {"service_id": "SV036", "name": "Kickboxing giảm stress", "description": "Kickboxing kết hợp cardio và giải tỏa stress. Đốt cháy calo hiệu quả, tăng sức mạnh và sự linh hoạt.", "image_url": "https://images.unsplash.com/photo-1549719386-74dfcbf7dbed?w=400&h=300&fit=crop", "badge": "Hot", "booked_count": 570, "price": {"amount": 300000, "currency": "VND"}, "staff_name": "HLV Bùi Văn JJ", "rating": {"average": 4.7, "total_reviews": 185}, "location": {"address": "72 Hoàng Diệu", "district": "Quận 4", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T18:00:00", "2026-03-12T18:00:00"]},
    "SV037": {"service_id": "SV037", "name": "Yoga buổi sáng online", "description": "Lớp yoga online mỗi sáng giúp bắt đầu ngày tràn đầy năng lượng. Kéo giãn, thở, hạ huyết áp.", "image_url": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 940, "price": {"amount": 150000, "currency": "VND"}, "staff_name": "GV Phan Thị KK", "rating": {"average": 4.8, "total_reviews": 320}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T06:30:00", "2026-03-11T06:30:00"]},
    "SV038": {"service_id": "SV038", "name": "CrossFit cho người mới bắt đầu", "description": "CrossFit dành cho người mới, tập trung vào functional fitness. Kết hợp cardio, sức mạnh, sự linh hoạt.", "image_url": "https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?w=400&h=300&fit=crop", "badge": "Mới", "booked_count": 310, "price": {"amount": 400000, "currency": "VND"}, "staff_name": "HLV Trương Văn LL", "rating": {"average": 4.6, "total_reviews": 100}, "location": {"address": "88 Ngô Gia Tự", "district": "Quận 10", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T17:00:00", "2026-03-13T17:00:00"]},
    "SV039": {"service_id": "SV039", "name": "Đạp xe ngoài trời", "description": "Nhóm đạp xe ngoài trời cuối tuần. Cải thiện sức khỏe tim mạch, đốt cháy calo, kết nối với thiên nhiên.", "image_url": "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 420, "price": {"amount": 200000, "currency": "VND"}, "staff_name": "HLV Lưu Văn MM", "rating": {"average": 4.7, "total_reviews": 140}, "location": {"address": "Công viên Lê Văn Tám", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-14T06:00:00", "2026-03-15T06:00:00"]},
    "SV040": {"service_id": "SV040", "name": "Yoga cho bà bầu", "description": "Yoga dành riêng cho phụ nữ mang thai, giảm đau lưng, chuẩn bị sinh nở. Bài tập an toàn cho mẹ và bé.", "image_url": "https://images.unsplash.com/photo-1518310383802-640c2de311b2?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 380, "price": {"amount": 350000, "currency": "VND"}, "staff_name": "GV Mai Thị NN", "rating": {"average": 4.9, "total_reviews": 130}, "location": {"address": "19 Cống Quỳnh", "district": "Quận 1", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T09:00:00", "2026-03-13T09:00:00"]},
    "SV041": {"service_id": "SV041", "name": "Aerobic giảm cân", "description": "Aerobic vui nhộn, âm nhạc sôi động giúp giảm cân hiệu quả. Đốt cháy 500-700 calo mỗi buổi.", "image_url": "https://images.unsplash.com/photo-1540497077202-7c8a3999166f?w=400&h=300&fit=crop", "badge": "Hot", "booked_count": 760, "price": {"amount": 200000, "currency": "VND"}, "staff_name": "HLV Đinh Thị OO", "rating": {"average": 4.7, "total_reviews": 255}, "location": {"address": "55 Tô Hiến Thành", "district": "Quận 10", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T17:30:00", "2026-03-12T17:30:00"]},
    "SV042": {"service_id": "SV042", "name": "Bơi lội cơ bản cho người lớn", "description": "Khóa học bơi lội cho người lớn chưa biết bơi. Từ làm quen với nước đến bơi thành thạo 4 kiểu.", "image_url": "https://images.unsplash.com/photo-1519315901367-f34ff9154487?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 440, "price": {"amount": 300000, "currency": "VND"}, "staff_name": "HLV Vũ Văn PP", "rating": {"average": 4.6, "total_reviews": 148}, "location": {"address": "Hồ bơi Lãnh Binh Thăng", "district": "Quận 11", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T16:00:00", "2026-03-13T16:00:00"]},
    "SV043": {"service_id": "SV043", "name": "Thể dục dụng cụ cho trẻ", "description": "Thể dục dụng cụ cho trẻ 4-12 tuổi, phát triển thể chất toàn diện. Tăng linh hoạt, sức mạnh, cân bằng.", "image_url": "https://images.unsplash.com/photo-1595435742656-5272d0b3fa82?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 330, "price": {"amount": 350000, "currency": "VND"}, "staff_name": "HLV Hoàng Văn QQ", "rating": {"average": 4.8, "total_reviews": 110}, "location": {"address": "7 Trần Phú", "district": "Quận 5", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T15:00:00", "2026-03-12T15:00:00"]},
    "SV044": {"service_id": "SV044", "name": "Zumba dance fitness", "description": "Zumba kết hợp nhảy và fitness, âm nhạc Latin sôi động. Đốt cháy calo cao, cải thiện điệu nhịp.", "image_url": "https://images.unsplash.com/photo-1524594152303-9fd13543fe6e?w=400&h=300&fit=crop", "badge": "Hot", "booked_count": 680, "price": {"amount": 200000, "currency": "VND"}, "staff_name": "GV Đặng Thị RR", "rating": {"average": 4.8, "total_reviews": 225}, "location": {"address": "40 Trường Chinh", "district": "Tân Bình", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T18:30:00", "2026-03-12T18:30:00"]},
    "SV045": {"service_id": "SV045", "name": "Leo núi cuối tuần", "description": "Nhóm leo núi cuối tuần chinh phục các đỉnh núi đẹp. Tăng sức bền, sức mạnh chân, thưởng thức thiên nhiên.", "image_url": "https://images.unsplash.com/photo-1551632811-561732d1e306?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 290, "price": {"amount": 250000, "currency": "VND"}, "staff_name": "HDV Lý Văn SS", "rating": {"average": 4.7, "total_reviews": 95}, "location": {"address": "Núi Bà Đen", "district": "Tây Ninh", "city": "Tây Ninh"}, "slots": ["2026-03-14T05:00:00", "2026-03-15T05:00:00"]},
    "SV046": {"service_id": "SV046", "name": "Võ thuật tự vệ cho phụ nữ", "description": "Võ thuật tự vệ dành riêng cho phụ nữ. Kỹ thuật tự vệ đơn giản hiệu quả, tăng tự tin và nhận thức an toàn.", "image_url": "https://images.unsplash.com/photo-1555597673-b21d5c935865?w=400&h=300&fit=crop", "badge": "Mới", "booked_count": 240, "price": {"amount": 350000, "currency": "VND"}, "staff_name": "HLV Phan Thị TT", "rating": {"average": 4.8, "total_reviews": 78}, "location": {"address": "66 Bạch Đằng", "district": "Bình Thạnh", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T18:00:00", "2026-03-13T18:00:00"]},
    "SV047": {"service_id": "SV047", "name": "Stretching & flexibility", "description": "Kéo giãn và tăng linh hoạt, giảm đau cơ, phòng ngừa chấn thương. Phù hợp sau tập luyện hoặc người ngồi nhiều.", "image_url": "https://images.unsplash.com/photo-1566241440091-ec10de8db2e1?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 520, "price": {"amount": 150000, "currency": "VND"}, "staff_name": "HLV Bùi Thị UU", "rating": {"average": 4.6, "total_reviews": 175}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T20:00:00", "2026-03-12T20:00:00"]},
    "SV048": {"service_id": "SV048", "name": "TRX suspension training", "description": "TRX dùng dây đeo tập luyện toàn thân. Tăng sức mạnh cơ, core, cân bằng. Hiệu quả cao, ít tác động lên khớp.", "image_url": "https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 350, "price": {"amount": 400000, "currency": "VND"}, "staff_name": "HLV Trương Văn VV", "rating": {"average": 4.7, "total_reviews": 115}, "location": {"address": "95 Cách Mạng Tháng 8", "district": "Quận 3", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T07:00:00", "2026-03-13T07:00:00"]},
    "SV049": {"service_id": "SV049", "name": "Thể dục người cao tuổi", "description": "Thể dục nhẹ nhàng cho người cao tuổi, tập trung linh hoạt, cân bằng, phòng ngừa té ngã.", "image_url": "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 410, "price": {"amount": 200000, "currency": "VND"}, "staff_name": "HLV Lưu Thị WW", "rating": {"average": 4.8, "total_reviews": 135}, "location": {"address": "Công viên Hoàng Văn Thụ", "district": "Phú Nhuận", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T06:00:00", "2026-03-12T06:00:00"]},
    "SV050": {"service_id": "SV050", "name": "HIIT training giảm mỡ", "description": "HIIT đốt cháy mỡ nhanh chóng. Tập 30-45 phút hiệu quả cao, tăng trao đổi chất, giữ cơ bắp.", "image_url": "https://images.unsplash.com/photo-1517963879433-6ad2b056d712?w=400&h=300&fit=crop", "badge": "Hot", "booked_count": 790, "price": {"amount": 350000, "currency": "VND"}, "staff_name": "HLV Mai Văn XX", "rating": {"average": 4.8, "total_reviews": 265}, "location": {"address": "150 Nguyễn Oanh", "district": "Gò Vấp", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T17:00:00", "2026-03-12T17:00:00"]},
    "SV051": {"service_id": "SV051", "name": "Tư vấn dinh dưỡng cá nhân hóa", "description": "Tư vấn dinh dưỡng riêng biệt dựa trên tình trạng sức khỏe, mục tiêu cá nhân và phong cách sống.", "image_url": "https://images.unsplash.com/photo-1498837167922-ddd27525d352?w=400&h=300&fit=crop", "badge": "Premium", "booked_count": 580, "price": {"amount": 600000, "currency": "VND"}, "staff_name": "CN Nguyễn Thị YY", "rating": {"average": 4.9, "total_reviews": 195}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T10:00:00", "2026-03-12T10:00:00"]},
    "SV052": {"service_id": "SV052", "name": "Kế hoạch ăn kiêng Keto", "description": "Chương trình Keto cá nhân hóa để giảm cân và cải thiện sức khỏe chuyển hóa. Thực đơn 30 ngày chi tiết.", "image_url": "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 460, "price": {"amount": 450000, "currency": "VND"}, "staff_name": "CN Trần Văn ZZ", "rating": {"average": 4.6, "total_reviews": 155}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T10:00:00", "2026-03-13T10:00:00"]},
    "SV053": {"service_id": "SV053", "name": "Thực đơn ăn chay khoa học", "description": "Kế hoạch ăn chay cân bằng dinh dưỡng, đủ protein, vitamin B12, sắt, canxi. Thực đơn đa dạng.", "image_url": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=300&fit=crop", "badge": "Mới", "booked_count": 320, "price": {"amount": 400000, "currency": "VND"}, "staff_name": "CN Lê Thị AAA", "rating": {"average": 4.7, "total_reviews": 105}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-12T10:00:00", "2026-03-14T10:00:00"]},
    "SV054": {"service_id": "SV054", "name": "Dinh dưỡng tăng cơ", "description": "Kế hoạch dinh dưỡng cho người tập gym muốn tăng cơ. Tính toán protein, carb, fat phù hợp.", "image_url": "https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 540, "price": {"amount": 500000, "currency": "VND"}, "staff_name": "CN Phạm Văn BBB", "rating": {"average": 4.8, "total_reviews": 180}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T11:00:00", "2026-03-12T11:00:00"]},
    "SV055": {"service_id": "SV055", "name": "Thực đơn cho người tiểu đường", "description": "Kế hoạch ăn uống khoa học cho người đái tháo đường type 1 và 2. Kiểm soát đường huyết, chỉ số GI thấp.", "image_url": "https://images.unsplash.com/photo-1505576399279-565b52d4ac71?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 390, "price": {"amount": 500000, "currency": "VND"}, "staff_name": "CN Hoàng Thị CCC", "rating": {"average": 4.8, "total_reviews": 130}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T11:00:00", "2026-03-13T11:00:00"]},
    "SV056": {"service_id": "SV056", "name": "Dinh dưỡng cho bà bầu", "description": "Kế hoạch dinh dưỡng toàn diện cho phụ nữ mang thai. Thực đơn theo từng giai đoạn thai kỳ.", "image_url": "https://images.unsplash.com/photo-1519500099198-fd81846b8d4f?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 410, "price": {"amount": 550000, "currency": "VND"}, "staff_name": "CN Vũ Thị DDD", "rating": {"average": 4.9, "total_reviews": 140}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T14:00:00", "2026-03-12T14:00:00"]},
    "SV057": {"service_id": "SV057", "name": "Thực đơn giảm cholesterol", "description": "Kế hoạch ăn uống giúp giảm LDL, tăng HDL. Tập trung chất xơ, omega-3, hạn chế chất béo bão hòa.", "image_url": "https://images.unsplash.com/photo-1466637574441-749b8f19452f?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 280, "price": {"amount": 450000, "currency": "VND"}, "staff_name": "CN Đặng Văn EEE", "rating": {"average": 4.6, "total_reviews": 92}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T14:00:00", "2026-03-13T14:00:00"]},
    "SV058": {"service_id": "SV058", "name": "Intermittent fasting coaching", "description": "Hướng dẫn nhịn ăn gián đoạn an toàn. Các phương pháp 16/8, 5:2. Giảm cân, cải thiện trao đổi chất.", "image_url": "https://images.unsplash.com/photo-1523294587484-bae6cc870010?w=400&h=300&fit=crop", "badge": "Hot", "booked_count": 620, "price": {"amount": 400000, "currency": "VND"}, "staff_name": "CN Lý Thị FFF", "rating": {"average": 4.7, "total_reviews": 210}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-10T16:00:00", "2026-03-12T16:00:00"]},
    "SV059": {"service_id": "SV059", "name": "Dinh dưỡng cho vận động viên", "description": "Dinh dưỡng chuyên nghiệp cho vận động viên và người tập cường độ cao. Tối ưu hiệu suất, phục hồi nhanh.", "image_url": "https://images.unsplash.com/photo-1532384748853-8f54a8f476e2?w=400&h=300&fit=crop", "badge": "Chuyên khoa", "booked_count": 290, "price": {"amount": 600000, "currency": "VND"}, "staff_name": "CN Bùi Văn GGG", "rating": {"average": 4.8, "total_reviews": 95}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-11T16:00:00", "2026-03-13T16:00:00"]},
    "SV060": {"service_id": "SV060", "name": "Thực đơn Mediterranean diet", "description": "Chế độ ăn Địa Trung Hải - một trong những chế độ ăn lành mạnh nhất thế giới. Nhiều rau củ, cá, dầu ô liu.", "image_url": "https://images.unsplash.com/photo-1544025162-d76694265947?w=400&h=300&fit=crop", "badge": "Phổ biến", "booked_count": 370, "price": {"amount": 450000, "currency": "VND"}, "staff_name": "CN Trương Thị HHH", "rating": {"average": 4.7, "total_reviews": 125}, "location": {"address": "Online", "district": "Toàn quốc", "city": "Hồ Chí Minh"}, "slots": ["2026-03-12T14:00:00", "2026-03-14T14:00:00"]},
}

# products.id từ ner-service seed_local / môi trường test — trùng với DB mà NER filter ra.
# MOCK_SERVICES chỉ có khóa SVxxx nên UUID từ pipeline sẽ thành "Unknown" nếu không có bảng này.
SEED_PRODUCT_FALLBACK: dict[str, dict[str, str]] = {
    "f0000001-0000-0000-0000-000000000001": {
        "name": "Tư vấn tim mạch trực tuyến",
        "description": "Tư vấn và đánh giá sức khỏe tim mạch qua video call với bác sĩ chuyên khoa.",
    },
    "f0000001-0000-0000-0000-000000000002": {
        "name": "Vật lý trị liệu thoát vị đĩa đệm",
        "description": "Chương trình phục hồi chuyên sâu cho bệnh nhân thoát vị đĩa đệm.",
    },
    "f0000001-0000-0000-0000-000000000003": {
        "name": "Châm cứu bấm huyệt tại gia",
        "description": "Dịch vụ châm cứu và bấm huyệt tại nhà bởi lương y có kinh nghiệm.",
    },
    "f0000001-0000-0000-0000-000000000004": {
        "name": "Tư vấn tâm lý trị liệu",
        "description": "Buổi tư vấn tâm lý 1-1 với chuyên gia trị liệu tâm lý.",
    },
    "f0000001-0000-0000-0000-000000000005": {
        "name": "Làm sạch răng chuyên sâu",
        "description": "Vệ sinh răng miệng chuyên sâu, loại bỏ cao răng và làm trắng nhẹ.",
    },
    "f0000001-0000-0000-0000-000000000006": {
        "name": "Massage cổ vai gáy 45 phút",
        "description": "Liệu trình massage cổ vai gáy giảm căng cứng, phù hợp dân văn phòng.",
    },
    "f0000001-0000-0000-0000-000000000007": {
        "name": "Massage đá nóng thư giãn 60 phút",
        "description": "Massage toàn thân kết hợp đá nóng giúp thư giãn sâu và ngủ ngon.",
    },
    "f0000001-0000-0000-0000-000000000008": {
        "name": "Gội đầu dưỡng sinh 60 phút",
        "description": "Gội đầu dưỡng sinh kết hợp bấm huyệt đầu vai gáy.",
    },
}


def _enrichment_fallback_detail(service_id: str) -> dict:
    """Khi không gọi được backend hoặc backend không trả đủ — vẫn hiển thị tên từ seed/mock."""
    sid = str(service_id)
    mock = MOCK_SERVICES.get(sid)
    if mock:
        return mock
    seed = SEED_PRODUCT_FALLBACK.get(sid)
    if seed:
        return {
            "service_id": sid,
            "name": seed["name"],
            "description": seed.get("description", ""),
        }
    return {"service_id": sid, "name": "Unknown", "description": ""}

def _safe_sample(values: list[str], max_items: int = 5) -> list[str]:
    if not values:
        return []
    out: list[str] = []
    for v in values[:max_items]:
        try:
            out.append(str(v))
        except Exception:
            out.append("<unprintable>")
    return out


def _extract_service_id_any_shape(obj: dict) -> str | None:
    """
    Extract service identifier from various backend response shapes without changing behavior.
    (Used for logging + ordering diagnostics only.)
    """
    if not isinstance(obj, dict):
        return None
    for key in ("service_id", "serviceId", "id", "serviceID", "service_id_str"):
        val = obj.get(key)
        if val is None:
            continue
        try:
            s = str(val).strip()
        except Exception:
            continue
        if s:
            return s
    return None


async def _enrich_with_service_info(service_ids: list[str]) -> list[dict]:
    """Dùng API backend thật để lấy full thông tin service."""
    if not service_ids:
        return []

    # Don't break current system if key missing.
    if not settings.AI_API_KEY:
        logger.warning(
            "[ENRICH] skip_backend reason=AI_API_KEY_unset service_ids_count=%s service_ids_sample=%s backend_base_url=%s",
            len(service_ids),
            _safe_sample(service_ids),
            settings.BACKEND_BASE_URL,
        )
        return [_enrichment_fallback_detail(sid) for sid in service_ids]

    client = BackendAIClient()
    try:
        logger.info(
            "[ENRICH] backend_request endpoint=/backend/ai/recommendations service_ids_count=%s service_ids_sample=%s backend_base_url=%s header=%s",
            len(service_ids),
            _safe_sample(service_ids),
            settings.BACKEND_BASE_URL,
            settings.AI_API_KEY_HEADER,
        )
        services = await client.get_service_details(service_ids)
    except Exception as e:
        # Do not break main recommendation flow if backend enrichment API is down.
        logger.warning("Backend enrichment failed, fallback to basic payload. error=%r", e)
        return [_enrichment_fallback_detail(sid) for sid in service_ids]
    if not services:
        logger.warning(
            "Backend enrichment returned empty list for service_ids=%s — using local fallback",
            service_ids,
        )
        return [_enrichment_fallback_detail(sid) for sid in service_ids]

    # Preserve the ordering from recommender response
    by_id: dict[str, dict] = {}
    returned_ids: list[str] = []
    for s in services:
        sid = s.get("service_id") or s.get("id")
        if sid is not None:
            sid_str = str(sid)
            by_id[sid_str] = s
            returned_ids.append(sid_str)

    # Diagnostics: detect missing IDs / mismatched key naming.
    returned_any = [_extract_service_id_any_shape(s) for s in services if isinstance(s, dict)]
    returned_any = [r for r in returned_any if r]
    missing = [sid for sid in service_ids if sid not in by_id]
    logger.info(
        "[ENRICH] backend_response services_count=%s returned_ids_count=%s returned_ids_sample=%s returned_any_ids_sample=%s missing_count=%s missing_sample=%s",
        len(services),
        len(returned_ids),
        _safe_sample(returned_ids),
        _safe_sample(returned_any),
        len(missing),
        _safe_sample(missing),
    )

    return [
        by_id[sid] if sid in by_id else _enrichment_fallback_detail(sid)
        for sid in service_ids
    ]


def _format_services_for_prompt(services: list[Any]) -> str:
    """Format thông tin dịch vụ thành text để inject vào prompt chatbot."""
    if not services:
        return ""
    lines = []
    for s in services:
        if not isinstance(s, dict):
            # Graceful degradation for unexpected shapes (e.g., list[str]).
            try:
                raw = str(s)
            except Exception:
                raw = "<unprintable>"
            lines.append(f"- {raw}")
            continue

        name = s.get("name", "")
        desc = s.get("description", "")

        price_obj = s.get("price")
        price = None
        if isinstance(price_obj, dict):
            price = price_obj.get("amount")

        staff = s.get("staff_name", "")

        rating_obj = s.get("rating")
        rating = None
        if isinstance(rating_obj, dict):
            rating = rating_obj.get("average")

        sid = s.get("service_id", "") or s.get("id", "")

        # Optional extra debug for bad backend shapes (kept small).
        if not name and not desc and isinstance(sid, str) and sid and len(s.keys()) <= 3:
            try:
                logger.debug("[ENRICH] thin_service_payload=%s", json.dumps(s, ensure_ascii=False)[:300])
            except Exception:
                pass

        lines.append(
            f"- [{sid}] {name}: {desc} "
            f"(Giá: {price:,} VND, Bác sĩ/HLV: {staff}, Rating: {rating}/5)"
            if isinstance(price, int) else
            f"- [{sid}] {name}: {desc} (Bác sĩ/HLV: {staff}, Rating: {rating}/5)"
        )
    return "\n".join(lines)


class RecommendationOrchestrator:

    def __init__(self):
        self.recommender_client = RecommenderClient()

    async def recommend_home(self, request: Any) -> Dict:
        payload = {"user_id": str(request.user_id), "top_k": request.top_k}
        try:
            result = await self.recommender_client.recommend_home(payload)
        except httpx.HTTPStatusError as e:
            detail = None
            try:
                detail = e.response.json()
            except Exception:
                detail = e.response.text or "Downstream recommender error"
            raise HTTPException(status_code=e.response.status_code, detail=detail) from e

        service_ids = result["recommendations"][0]["service_ids"] if result.get("recommendations") else []

        # Enrich service_ids → AiRecommendationItemDto (pass-through từ backend AI)
        services = await _enrich_with_service_info(service_ids)

        return {
            "recommendations": services,
            "total": len(services),
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }

    async def recommend_chatbot(self, request: Any) -> Dict:
        payload = {
            "conversation_id": str(request.conversation_id),
            "query": request.query,
            "top_k": request.top_k,
        }
        try:
            result = await self.recommender_client.recommend_chatbot(payload)
        except httpx.HTTPStatusError as e:
            detail = None
            try:
                detail = e.response.json()
            except Exception:
                detail = e.response.text or "Downstream recommender error"
            raise HTTPException(status_code=e.response.status_code, detail=detail) from e

        service_ids = result["recommendations"][0]["service_ids"] if result.get("recommendations") else []

        # Enrich
        services = await _enrich_with_service_info(service_ids)

        return {
            "conversation_id": str(request.conversation_id),
            "recommendations": services,
            "total": len(services),
            "timestamp": datetime.now(timezone.utc).isoformat(),
        }

    async def get_enriched_services_for_prompt(self, service_ids: list[str]) -> str:
        """
        Dùng bởi ChatbotOrchestrator để enrich prompt.
        Trả về string mô tả dịch vụ để inject vào prompt LLM.
        """
        services = await _enrich_with_service_info(service_ids)
        return _format_services_for_prompt(services)
    
    async def get_enriched_services(self, service_ids: list[str]) -> list[dict]:
        """Trả về list service detail — dùng cho SSE event."""
        return await _enrich_with_service_info(service_ids)