"""
evaluation/datasets/generate_baseline.py

Generate synthetic baseline dataset for Recommender evaluation with smarter templates.
Creates:
  - ~300 Chatbot queries (5 per service for 60 services)
  - 300 Home profiles
"""

import json
import random
import os

random.seed(42)

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
SERVICES_PATH = os.path.abspath(os.path.join(CURRENT_DIR, "../../data/raw/services.json"))
OUT_CHATBOT = os.path.join(CURRENT_DIR, "chatbot_eval.json")
OUT_HOME = os.path.join(CURRENT_DIR, "home_eval.json")

def load_services():
    with open(SERVICES_PATH, "r", encoding="utf-8") as f:
        return json.load(f)

services = load_services()

cat_to_sv = {}
for sv in services:
    cat = sv.get("category", "unknown")
    cat_to_sv.setdefault(cat, []).append(sv["id"])

def get_hard_negs(sv_id, category, n=3):
    pool = [sid for sid in cat_to_sv.get(category, []) if sid != sv_id]
    if len(pool) < n: return pool
    return random.sample(pool, n)

# Classify tags manually for smarter templates
ACTION_NOUNS = {"yoga", "gym", "pilates", "chạy bộ", "bơi lội", "kickboxing", "crossfit", "đạp xe", "aerobic", "zumba", "leo núi", "võ thuật", "stretching", "kéo giãn", "trx", "thiền", "mindfulness", "nội soi"}
GOALS = {"giảm mỡ", "tăng cơ", "giảm cân", "giảm stress", "linh hoạt", "tăng trao đổi chất", "tiết kiệm thời gian", "tự tin", "vui vẻ", "sức bền", "phát triển thể chất", "an toàn", "phòng ngừa té ngã", "bảo vệ gan", "thư giãn", "phòng ngừa ung thư", "thành công"}
DISEASES = {"đau lưng", "thoái hóa", "viêm khớp", "gout", "loãng xương", "sâu răng", "căng thẳng", "lo âu", "trầm cảm", "chấn thương tâm lý", "huyết áp cao", "sỏi thận", "đái tháo đường", "tiểu đường", "mụn", "viêm da", "trào ngược", "cận thị", "viêm xoang"}
DEMOGRAPHICS = {"trẻ em", "người lớn tuổi", "người cao tuổi", "bà bầu", "nam giới", "phụ nữ", "dân văn phòng", "người bận rộn"}

def get_template_for_tag(name, tag, category):
    tag_l = tag.lower()
    
    # 1. Is it a disease/pain point?
    if any(d in tag_l for d in DISEASES):
        t = [
            f"Dạo này tôi hay bị tình trạng {tag}, phòng khám có tư vấn không?",
            f"Bố tớ đang chịu ảnh hưởng nặng của {tag}, cần một giải pháp điều trị.",
            f"Gói {name} có giúp ích gì cho người mắc bệnh {tag} không ạ?",
            f"Tôi bị chẩn đoán bị {tag}, bác sĩ nào khám tốt ở trung tâm mình?",
            f"Triệu chứng {tag} cứ tái phát liên tục, tôi nên đăng ký gói dịch vụ nào?"
        ]
        return random.choice(t)
        
    # 2. Is it a sports form or specific noun?
    if any(a in tag_l for a in ACTION_NOUNS):
        t = [
            f"Cho tôi xin thông tin lịch tập bộ môn {tag}.",
            f"Lớp {tag} có nhận người mới hoàn toàn chưa biết gì không?",
            f"Chương trình {name} tập chuyên sâu vào mảng {tag} đúng không ạ?",
            f"Trung tâm có khóa dạy {tag} nào tốt giới thiệu cho tôi với.",
            f"Đang quan tâm môn {tag}, xin báo giá khóa học."
        ]
        return random.choice(t)
        
    # 3. Is it a goal/benefit?
    if any(g in tag_l for g in GOALS):
        t = [
            f"Tôi đang cần tìm phương pháp để {tag} an toàn.",
            f"Có gói tư vấn nào tập trung hoàn toàn vào mục tiêu {tag} không ad?",
            f"Làm sao để đạt được hiệu quả {tag} tốt nhất mà không hại sức khỏe?",
            f"Gói dịch vụ {name} có đảm bảo cam kết {tag} như mong muốn không?",
            f"Mình muốn tối ưu hóa việc {tag}, trung tâm tư vấn nhé."
        ]
        return random.choice(t)
        
    # 4. Fallback default realistic prompts
    t = [
        f"Bạn cấp cho tôi xin thông tin về {name} nhé.",
        f"Tôi muốn được hướng dẫn cụ thể về vấn đề {tag}.",
        f"Bên mình có chuyên gia cho mảng {tag} không, tôi cần {name}.",
        f"Tìm hiểu thêm về mảng {tag}.",
        f"Chi phí dịch vụ {name} là bao nhiêu vậy ad?"
    ]
    return random.choice(t)

def generate_datasets():
    chatbot_queries = []
    q_id = 1

    for sv in services:
        sv_id = sv["id"]
        name = sv["name"].lower()
        cat = sv.get("category", "unknown")
        tags = sv.get("tags", [])
        
        # 5 queries per service
        for _ in range(5):
            tag = random.choice(tags) if tags else name
            query_text = get_template_for_tag(name, tag, cat)
            
            # Hard negs
            hn = get_hard_negs(sv_id, cat, random.randint(2, 4))
            
            # Grade 1 rels
            grade1_pool = get_hard_negs(sv_id, cat, random.randint(1, 2))
            
            grades = {sv_id: 2}
            relevant = [sv_id]
            for g1 in grade1_pool:
                if g1 not in hn:
                    grades[g1] = 1
                    relevant.append(g1)
            
            chatbot_queries.append({
                "id": f"CB_{q_id:04d}",
                "query": query_text,
                "relevant_ids": relevant,
                "hard_negative_ids": hn,
                "relevance_grades": grades,
                "category": cat
            })
            q_id += 1

    random.shuffle(chatbot_queries)
    
    with open(OUT_CHATBOT, "w", encoding="utf-8") as f:
        json.dump(chatbot_queries, f, ensure_ascii=False, indent=4)
    print(f"✅ Generated {len(chatbot_queries)} smart chatbot queries -> chatbot_eval.json")

    home_profiles = []
    h_id = 1

    desc_templates = [
        "Người làm việc văn phòng ít vận động, rất hay hỏi về {tag}",
        "Nam giới 45 tuổi, tìm kiếm giải pháp cho tình trạng {tag}",
        "Phụ nữ sau sinh 30 tuổi, mục tiêu hiện tại là {tag}",
        "Sinh viên thường xuyên bị áp lực học tập, hay than phiền về {tag}",
        "Một khách hàng VIP quan tâm chăm sóc sức khỏe, đang tìm trung tâm {tag}"
    ]

    for _ in range(250):
        sv = random.choice(services)
        sv_id = sv["id"]
        cat = sv.get("category", "unknown")
        tags = sv.get("tags", [])
        
        tag = random.choice(tags) if tags else sv["name"].lower()
        desc = random.choice(desc_templates).format(tag=tag.lower())
        
        sv2 = random.choice(services)
        hc = [random.choice(sv2.get("tags", ["Mệt mỏi"]))]
        ints = [random.choice(tags) if tags else "Y tế"]
        goals = ["Nâng cao chất lượng cuộc sống", "Điều trị dự phòng"]
        history = [random.choice(services)["id"]]
        
        hn = get_hard_negs(sv_id, cat, random.randint(2, 4))
        grade1_pool = get_hard_negs(sv_id, cat, 2)
        grades = {sv_id: 2}
        relevant = [sv_id]
        
        for g1 in grade1_pool:
            if g1 not in hn:
                grades[g1] = 1
                relevant.append(g1)
                
        home_profiles.append({
            "id": f"HOME_{h_id:04d}",
            "description": desc,
            "health_conditions": hc,
            "interests": ints,
            "goals": goals,
            "service_history_ids": history,
            "relevant_ids": relevant,
            "hard_negative_ids": hn,
            "relevance_grades": grades
        })
        h_id += 1

    with open(OUT_HOME, "w", encoding="utf-8") as f:
        json.dump(home_profiles, f, ensure_ascii=False, indent=4)
    print(f"✅ Generated {len(home_profiles)} smart home profiles -> home_eval.json")

if __name__ == "__main__":
    generate_datasets()
