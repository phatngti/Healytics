import json
from typing import List, Dict
from config.settings import SERVICES_JSON_PATH

class ServiceLoader:
    """Load và xử lý dữ liệu services"""
    
    def __init__(self, file_path: str = SERVICES_JSON_PATH):
        self.file_path = file_path
        self.services = []
    
    def load_services(self) -> List[Dict]:
        """Load services từ file JSON"""
        with open(self.file_path, 'r', encoding='utf-8') as f:
            self.services = json.load(f)
        return self.services
    
    def services_to_texts_and_metadata(self) -> tuple:
        """
        Chuyển đổi services thành texts và metadata
        Returns: (texts, metadatas, ids)
        """
        if not self.services:
            self.load_services()
        
        texts = []
        metadatas = []
        ids = []
        
        for service in self.services:
            # Tạo content từ các textual features
            content_parts = [
                f"Tên dịch vụ: {service['name']}",
                f"Mô tả: {service['description']}",
                f"Danh mục: {service['category']}",
                f"Từ khóa: {', '.join(service['tags'])}"
            ]
            content = "\n".join(content_parts)
            
            # Metadata
            metadata = {
                "service_id": service["id"],
                "name": service["name"],
                "category": service["category"],
                "type": service["type"],
                "tags": ",".join(service["tags"])  # ChromaDB cần string
            }
            
            texts.append(content)
            metadatas.append(metadata)
            ids.append(service["id"])
        
        return texts, metadatas, ids
    
    def get_service_by_id(self, service_id: str) -> Dict:
        """Lấy thông tin service theo ID"""
        if not self.services:
            self.load_services()
        
        for service in self.services:
            if service["id"] == service_id:
                return service
        return None
    
    def get_all_services(self) -> List[Dict]:
        """Lấy tất cả services"""
        if not self.services:
            self.load_services()
        return self.services