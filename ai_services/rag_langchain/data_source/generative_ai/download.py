import os
import requests
import time

# DANH SÁCH LINK TRỰC TIẾP (Đã update sequence=1 để lấy file gốc)
file_links = [
    # 1. Tim mạch (WHO HEARTS) - Link direct
    {
        "title": "WHO_HEARTS_CVD_Management",
        "url": "https://iris.who.int/bitstream/handle/10665/333221/9789240001367-eng.pdf?sequence=1"
    },
    # 2. Huyết áp (WHO Hypertension 2021)
    {
        "title": "WHO_Hypertension_Guideline_2021",
        "url": "https://iris.who.int/bitstream/handle/10665/344424/9789240033986-eng.pdf?sequence=1"
    },
    # 3. Tiểu đường (Global Report)
    {
        "title": "WHO_Global_Report_Diabetes",
        "url": "https://iris.who.int/bitstream/handle/10665/204871/9789241565257_eng.pdf?sequence=1"
    },
    # 4. Phân loại tiểu đường
    {
        "title": "WHO_Classification_Diabetes",
        "url": "https://iris.who.int/bitstream/handle/10665/325182/9789241515702-eng.pdf?sequence=1"
    },
    # 5. Sức khỏe tâm thần (mhGAP)
    {
        "title": "WHO_mhGAP_Intervention_Guide",
        "url": "https://iris.who.int/bitstream/handle/10665/250239/9789241549790-eng.pdf?sequence=1"
    },
    # 6. Dinh dưỡng (USDA Guidelines) - Link dự phòng từ server thay thế nếu .gov chặn
    {
        "title": "USDA_Dietary_Guidelines_2020_2025",
        "url": "https://www.dietaryguidelines.gov/sites/default/files/2020-12/Dietary_Guidelines_for_Americans_2020-2025.pdf"
    },
    # 7. Hoạt động thể chất
    {
        "title": "WHO_Physical_Activity_Guidelines",
        "url": "https://iris.who.int/bitstream/handle/10665/336656/9789240015128-eng.pdf?sequence=1"
    },
    # 8. Cấp cứu cơ bản
    {
        "title": "WHO_Basic_Emergency_Care",
        "url": "https://iris.who.int/bitstream/handle/10665/260545/9789241513081-eng.pdf?sequence=1"
    },
    # 9. Danh mục thuốc thiết yếu 2023
    {
        "title": "WHO_Essential_Medicines_2023",
        "url": "https://iris.who.int/bitstream/handle/10665/371090/WHO-MHP-HPS-EML-2023.02-eng.pdf?sequence=1"
    },
    # 10. Chăm sóc thai kỳ
    {
        "title": "WHO_Antenatal_Care",
        "url": "https://iris.who.int/bitstream/handle/10665/250796/9789241549912-eng.pdf?sequence=1"
    }
]

# Giả lập trình duyệt thật (Chrome trên Windows) để tránh lỗi 403
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Connection": "keep-alive",
}

def download_file(link_info):
    filename = f"./{link_info['title']}.pdf"
    url = link_info['url']
    
    if os.path.exists(filename):
        print(f"⏭️  [BỎ QUA] Đã có file: {filename}")
        return

    print(f"⬇️  [ĐANG TẢI] {link_info['title']}...", end=" ", flush=True)
    
    try:
        # Tăng timeout lên 60s và cho phép redirect (allow_redirects=True)
        response = requests.get(url, headers=HEADERS, stream=True, timeout=60, allow_redirects=True)
        
        if response.status_code != 200:
            print(f"\n❌ [LỖI HTTP] Mã {response.status_code} - Link có thể bị chặn.")
            return

        # Kiểm tra Content-Type hoặc Magic Bytes để đảm bảo là PDF
        content_type = response.headers.get('Content-Type', '').lower()
        if 'pdf' not in content_type and 'application/octet-stream' not in content_type:
            # Kiểm tra kỹ hơn bằng 4 byte đầu
            first_chunk = next(response.iter_content(4))
            if not first_chunk.startswith(b'%PDF'):
                print(f"\n❌ [LỖI ĐỊNH DẠNG] File tải về là HTML (Trang web), không phải PDF.")
                return
            # Nếu đúng là PDF thì ghi lại chunk đầu tiên đó và tiếp tục
            with open(filename, 'wb') as f:
                f.write(first_chunk)
                for chunk in response.iter_content(chunk_size=1024*1024): # 1MB chunks
                    if chunk:
                        f.write(chunk)
        else:
            # Content-type đúng là PDF
            with open(filename, 'wb') as f:
                for chunk in response.iter_content(chunk_size=1024*1024):
                    if chunk:
                        f.write(chunk)
        
        print(f"✅ Xong!")
        # Ngủ 2 giây để tránh bị server chặn vì spam request
        time.sleep(2)

    except Exception as e:
        print(f"\n❌ [EXCEPTION] Lỗi: {e}")

if __name__ == "__main__":
    print(f"--- Bắt đầu tải {len(file_links)} tài liệu ---")
    for link in file_links:
        download_file(link)
    print("--- Hoàn tất ---")