"""
Streamlit Demo UI cho Health Service Recommender System
Chạy: streamlit run app.py
"""

import streamlit as st
import sys
import os

# Add paths
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'src'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'endpoints'))

from main import recommend_home, recommend_chatbot, get_service

# ============================================================================
# PAGE CONFIG
# ============================================================================
st.set_page_config(
    page_title="Health Service Recommender",
    page_icon="🏥",
    layout="wide",
    initial_sidebar_state="expanded"
)

# ============================================================================
# CUSTOM CSS
# ============================================================================
st.markdown("""
<style>
    .main-header {
        font-size: 2.5rem;
        font-weight: bold;
        color: #1f77b4;
        text-align: center;
        margin-bottom: 2rem;
    }
    .sub-header {
        font-size: 1.5rem;
        color: #2c3e50;
        margin-top: 1.5rem;
        margin-bottom: 1rem;
    }
    .service-card {
        background-color: #f8f9fa;
        padding: 1.5rem;
        border-radius: 10px;
        border-left: 5px solid #1f77b4;
        margin-bottom: 1rem;
        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .service-name {
        font-size: 1.3rem;
        font-weight: bold;
        color: #2c3e50;
        margin-bottom: 0.5rem;
    }
    .service-category {
        display: inline-block;
        background-color: #1f77b4;
        color: white;
        padding: 0.3rem 0.8rem;
        border-radius: 15px;
        font-size: 0.85rem;
        margin-right: 0.5rem;
    }
    .service-tag {
        display: inline-block;
        background-color: #e9ecef;
        color: #495057;
        padding: 0.2rem 0.6rem;
        border-radius: 10px;
        font-size: 0.8rem;
        margin-right: 0.3rem;
        margin-top: 0.3rem;
    }
    .similarity-score {
        font-size: 1.1rem;
        font-weight: bold;
        color: #28a745;
    }
    .reason-text {
        color: #6c757d;
        font-style: italic;
        margin-top: 0.5rem;
    }
    .info-box {
        background-color: #e7f3ff;
        padding: 1rem;
        border-radius: 8px;
        border-left: 4px solid #1f77b4;
        margin-bottom: 1rem;
    }
    .stTabs [data-baseweb="tab-list"] {
        gap: 2rem;
    }
    .stTabs [data-baseweb="tab"] {
        height: 3rem;
        padding: 0 2rem;
        font-size: 1.1rem;
    }
</style>
""", unsafe_allow_html=True)

# ============================================================================
# SESSION STATE
# ============================================================================
if 'chat_history' not in st.session_state:
    st.session_state.chat_history = []
if 'selected_services' not in st.session_state:
    st.session_state.selected_services = []

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

def display_service_card(service, show_score=True):
    """Hiển thị service card đẹp mắt"""
    with st.container():
        st.markdown(f"""
        <div class="service-card">
            <div class="service-name">🏥 {service['name']}</div>
            <div style="margin: 0.8rem 0;">
                <span class="service-category">{service['category']}</span>
                <span class="service-category" style="background-color: #6c757d;">{service['type']}</span>
            </div>
        """, unsafe_allow_html=True)
        
        if show_score:
            st.markdown(f"""
            <div class="similarity-score">
                📊 Độ phù hợp: {service['similarity_score']:.1%}
            </div>
            """, unsafe_allow_html=True)
        
        st.markdown(f"**📝 Mô tả:** {service['description']}")
        
        # Tags
        tags_html = "".join([f'<span class="service-tag">#{tag}</span>' for tag in service['tags']])
        st.markdown(f'<div style="margin-top: 0.8rem;">{tags_html}</div>', unsafe_allow_html=True)
        
        if 'reason' in service:
            st.markdown(f'<div class="reason-text">💡 {service["reason"]}</div>', unsafe_allow_html=True)
        
        st.markdown("</div>", unsafe_allow_html=True)
        
        # Buttons
        col1, col2 = st.columns([1, 4])
        with col1:
            if st.button(f"📋 Chi tiết", key=f"detail_{service['service_id']}"):
                st.session_state.selected_service_detail = service['service_id']
        with col2:
            if st.button(f"✅ Đã sử dụng", key=f"select_{service['service_id']}"):
                if service['service_id'] not in st.session_state.selected_services:
                    st.session_state.selected_services.append(service['service_id'])
                    st.success(f"Đã thêm '{service['name']}' vào danh sách dịch vụ đã sử dụng!")

def display_category_badge(category):
    """Map category sang tiếng Việt"""
    category_map = {
        "y_te": "Y tế",
        "the_thao": "Thể thao",
        "dinh_duong": "Dinh dưỡng",
        "tam_ly": "Tâm lý",
        "phuc_hoi": "Phục hồi"
    }
    return category_map.get(category, category)

# ============================================================================
# MAIN UI
# ============================================================================

# Header
st.markdown('<div class="main-header">🏥 Health Service Recommender System</div>', unsafe_allow_html=True)
st.markdown('<p style="text-align: center; color: #6c757d; font-size: 1.1rem;">Hệ thống gợi ý dịch vụ sức khỏe thông minh sử dụng AI & Vector Search</p>', unsafe_allow_html=True)

# Tabs
tab1, tab2, tab3 = st.tabs(["🏠 Trang chủ - Gợi ý cá nhân", "💬 Chatbot - Tìm kiếm", "📊 Thống kê"])

# ============================================================================
# TAB 1: HOME RECOMMENDER
# ============================================================================
with tab1:
    st.markdown('<div class="sub-header">Gợi ý dịch vụ phù hợp với bạn</div>', unsafe_allow_html=True)
    
    # Info box
    st.markdown("""
    <div class="info-box">
        <strong>ℹ️ Hướng dẫn:</strong> Điền thông tin về tình trạng sức khỏe, sở thích và mục tiêu của bạn. 
        Hệ thống sẽ gợi ý các dịch vụ phù hợp nhất dựa trên AI và lịch sử sử dụng.
    </div>
    """, unsafe_allow_html=True)
    
    # Sidebar cho user profile
    with st.sidebar:
        st.markdown("### 👤 Thông tin cá nhân")
        
        # Health Conditions
        st.markdown("**🏥 Tình trạng sức khỏe**")
        health_conditions = st.multiselect(
            "Chọn tình trạng sức khỏe của bạn:",
            ["Tim mạch", "Đái tháo đường", "Huyết áp cao", "Béo phì", "Đau lưng", 
             "Căng thẳng", "Lo âu", "Trầm cảm", "Chấn thương"],
            key="health_conditions"
        )
        
        # Interests
        st.markdown("**❤️ Sở thích**")
        interests = st.multiselect(
            "Bạn quan tâm đến:",
            ["Yoga", "Gym", "Thể thao", "Dinh dưỡng", "Thiền định", 
             "Massage", "Tư vấn tâm lý", "Phục hồi chức năng"],
            key="interests"
        )
        
        # Goals
        st.markdown("**🎯 Mục tiêu**")
        goals = st.multiselect(
            "Mục tiêu của bạn:",
            ["Giảm cân", "Tăng cơ", "Giảm stress", "Cải thiện sức khỏe tim mạch",
             "Kiểm soát đường huyết", "Tăng sức bền", "Giảm đau", "Cải thiện giấc ngủ"],
            key="goals"
        )
        
        # Age
        age = st.slider("**🎂 Độ tuổi**", 18, 80, 30)
        
        # Show selected services
        st.markdown("---")
        st.markdown("**✅ Dịch vụ đã sử dụng**")
        if st.session_state.selected_services:
            for service_id in st.session_state.selected_services:
                st.markdown(f"- {service_id}")
            if st.button("🗑️ Xóa tất cả"):
                st.session_state.selected_services = []
                st.rerun()
        else:
            st.info("Chưa có dịch vụ nào")
    
    # Main content
    col1, col2 = st.columns([3, 1])
    with col1:
        top_k = st.slider("Số lượng gợi ý:", 1, 10, 5, key="home_top_k")
    with col2:
        st.markdown("<br>", unsafe_allow_html=True)
        recommend_button = st.button("🔍 Tìm gợi ý", key="home_recommend", type="primary")
    
    if recommend_button:
        # Build user profile
        user_profile = {}
        if health_conditions:
            user_profile["health_conditions"] = [h.lower() for h in health_conditions]
        if interests:
            user_profile["interests"] = [i.lower() for i in interests]
        if goals:
            user_profile["goals"] = [g.lower() for g in goals]
        if age:
            user_profile["age"] = age
        
        with st.spinner("🔄 Đang tìm kiếm dịch vụ phù hợp..."):
            result = recommend_home(
                user_profile=user_profile if user_profile else None,
                selected_services=st.session_state.selected_services,
                top_k=top_k
            )
        
        if result.get("error"):
            st.error(f"❌ Lỗi: {result['error']}")
        elif result["total"] == 0:
            st.warning("⚠️ Không tìm thấy dịch vụ phù hợp. Hãy thử điều chỉnh thông tin của bạn!")
        else:
            st.success(f"✅ Tìm thấy {result['total']} dịch vụ phù hợp!")
            st.markdown("---")
            
            for idx, service in enumerate(result["recommendations"], 1):
                st.markdown(f"### Gợi ý #{idx}")
                display_service_card(service)
                st.markdown("<br>", unsafe_allow_html=True)

# ============================================================================
# TAB 2: CHATBOT RECOMMENDER
# ============================================================================
with tab2:
    st.markdown('<div class="sub-header">Tìm kiếm dịch vụ bằng ngôn ngữ tự nhiên</div>', unsafe_allow_html=True)
    
    st.markdown("""
    <div class="info-box">
        <strong>ℹ️ Hướng dẫn:</strong> Nhập câu hỏi hoặc mô tả nhu cầu của bạn bằng ngôn ngữ tự nhiên. 
        Ví dụ: "Tôi muốn tìm dịch vụ giúp giảm stress" hoặc "Có khóa học yoga nào không?"
    </div>
    """, unsafe_allow_html=True)
    
    # Chat interface
    col1, col2 = st.columns([4, 1])
    with col1:
        user_query = st.text_input(
            "💭 Nhập câu hỏi của bạn:",
            placeholder="VD: Tôi muốn tìm dịch vụ về tim mạch...",
            key="chatbot_query"
        )
    with col2:
        st.markdown("<br>", unsafe_allow_html=True)
        top_k_chat = st.selectbox("Số gợi ý:", [3, 5, 7, 10], index=0, key="chat_top_k")
    
    if st.button("🚀 Tìm kiếm", key="chatbot_search", type="primary") and user_query:
        # Add to history
        st.session_state.chat_history.append({"query": user_query, "timestamp": "now"})
        
        with st.spinner("🔄 Đang tìm kiếm..."):
            result = recommend_chatbot(user_query, top_k=top_k_chat)
        
        if result.get("error"):
            st.error(f"❌ Lỗi: {result['error']}")
        elif result["total"] == 0:
            st.warning("⚠️ Không tìm thấy dịch vụ phù hợp với câu hỏi của bạn.")
        else:
            st.success(f"✅ Tìm thấy {result['total']} kết quả cho: **'{user_query}'**")
            st.markdown("---")
            
            for idx, service in enumerate(result["recommendations"], 1):
                st.markdown(f"### Kết quả #{idx}")
                display_service_card(service)
                st.markdown("<br>", unsafe_allow_html=True)
    
    # Chat history
    if st.session_state.chat_history:
        st.markdown("---")
        st.markdown("### 📜 Lịch sử tìm kiếm")
        for idx, chat in enumerate(reversed(st.session_state.chat_history[-5:]), 1):
            st.markdown(f"**{idx}.** {chat['query']}")
        
        if st.button("🗑️ Xóa lịch sử"):
            st.session_state.chat_history = []
            st.rerun()

# ============================================================================
# TAB 3: STATISTICS
# ============================================================================
with tab3:
    st.markdown('<div class="sub-header">Thống kê hệ thống</div>', unsafe_allow_html=True)
    
    col1, col2, col3 = st.columns(3)
    
    with col1:
        st.metric(
            label="📊 Tổng số dịch vụ",
            value="60",
            delta="Đã cập nhật"
        )
    
    with col2:
        st.metric(
            label="🔍 Lượt tìm kiếm",
            value=len(st.session_state.chat_history),
            delta=f"+{len(st.session_state.chat_history)}"
        )
    
    with col3:
        st.metric(
            label="✅ Dịch vụ đã chọn",
            value=len(st.session_state.selected_services),
            delta=f"+{len(st.session_state.selected_services)}"
        )
    
    st.markdown("---")
    
    # Service categories
    st.markdown("### 📋 Danh mục dịch vụ")
    col1, col2 = st.columns(2)
    
    with col1:
        st.markdown("""
        **Các danh mục có sẵn:**
        - 🏥 Y tế (Y_te)
        - 🏃 Thể thao (The_thao)
        - 🥗 Dinh dưỡng (Dinh_duong)
        - 🧠 Tâm lý (Tam_ly)
        - 💪 Phục hồi (Phuc_hoi)
        """)
    
    with col2:
        st.markdown("""
        **Công nghệ sử dụng:**
        - 🤖 Sentence Transformers
        - 🔍 ChromaDB Vector Database
        - 📊 Cosine Similarity Search
        - 🎯 Personalized Recommendations
        """)
    
    st.markdown("---")
    st.markdown("### 🎯 Demo queries gợi ý")
    
    example_queries = [
        "Tôi muốn tìm dịch vụ về tim mạch",
        "Có dịch vụ nào giúp giảm căng thẳng không?",
        "Tư vấn dinh dưỡng cho người đái tháo đường",
        "Tôi muốn tập yoga",
        "Dịch vụ massage trị liệu"
    ]
    
    for query in example_queries:
        if st.button(f"💡 {query}", key=f"example_{query}"):
            st.session_state.chatbot_query = query
            st.rerun()

# ============================================================================
# FOOTER
# ============================================================================
st.markdown("---")
st.markdown("""
<div style="text-align: center; color: #6c757d; padding: 2rem 0;">
    <p><strong>Health Service Recommender System v1.0</strong></p>
    <p>Powered by Sentence Transformers & ChromaDB | Built with Streamlit</p>
    <p>🎓 Demo cho báo cáo</p>
</div>
""", unsafe_allow_html=True)