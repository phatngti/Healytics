""" Nguyên sẽ thực hiện file này
1. Mục tiêu: Implement User Repository Layer cho recommender service.
    Repository layer có nhiệm vụ:
    - Truy vấn dữ liệu user từ database
    - Xây dựng thông tin cần thiết để recommender hoạt động

2. Luồng tổng quan

    Gateway Service
        ↓
    Recommender API (FastAPI)
        ↓
    User Repository   ← (NGUYÊN implement)
        ↓
    Database

    ===> UI sẽ gửi user_id, và Nguyên dựa vào user_id rồi đi vào database để lấy các thông tin cần thiết cho recommender system (health_conditions, interests, goals, services_history)

3. Required Output Format

    Repository phải trả về normalized profile:

    {
        "health_conditions": List[str],
        "interests": List[str],
        "goals" : List[str],
        "service_history_ids": List[str]
    }

    Đây là format mà recommender model cần.

4. Required Functions
    async def get_user_health_conditions(session, user_id: str) -> list[str]:
        pass
    
    async def get_user_interests(session, user_id: str) -> list[str]:
        pass

    async def get_user_service_history(session, user_id: str) -> list[str]:
        pass

    async def get_user_goals(session, user_id: str) -> list[str]:
        pass
    
    async def build_user_profile(session, user_id: str) -> dict:
        Hàm này sẽ gọi 4 hàm ở trên  rồi trả về 1 dict hoàn chỉnh cho bên recommender system

"""