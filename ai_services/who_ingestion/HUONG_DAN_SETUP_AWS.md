# Hướng dẫn setup AWS từ đầu (S3 + OpenSearch)

Tài liệu này dành cho trường hợp bạn **đã có tài khoản AWS** nhưng **chưa tạo bucket S3 hay Elasticsearch/OpenSearch**.

Mục tiêu cuối: điền được các biến sau vào `who_ingestion/.env` và `rag_langchain/.env`:

```env
S3_BUCKET=...
S3_PREFIX=who-publications/
AWS_REGION=ap-southeast-1
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...

ELASTICSEARCH_URL=...
ELASTICSEARCH_INDEX=healytics_who_chunks
ELASTICSEARCH_USERNAME=...
ELASTICSEARCH_PASSWORD=...
```

---

## Phần A — Tạo S3 bucket lưu PDF WHO

### Bước A1: Đăng nhập AWS Console

1. Mở https://console.aws.amazon.com/
2. Đăng nhập tài khoản AWS của bạn
3. Góc trên bên phải chọn **Region** = `Asia Pacific (Singapore) ap-southeast-1`
   - Region này gần Việt Nam, latency thấp hơn

### Bước A2: Tạo bucket S3

1. Vào menu **Services** → tìm **S3**
2. Bấm **Create bucket**
3. Điền:
   - **Bucket name**: `healytics-who-docs` (phải unique toàn cầu; nếu bị trùng thử `healytics-who-docs-2025-yourname`)
   - **AWS Region**: `ap-southeast-1`
4. **Block Public Access**: giữ mặc định **Bật tất cả** (bucket private, an toàn)
5. Các mục khác giữ mặc định → **Create bucket**

→ Ghi lại: `S3_BUCKET=healytics-who-docs` (tên bạn vừa tạo)

### Bước A3: Tạo IAM User + Access Key (để code upload được)

> Không dùng root account key. Tạo IAM user riêng cho Healytics.

1. Vào **IAM** → **Users** → **Create user**
2. User name: `healytics-who-ingestion`
3. **Next** → chọn **Attach policies directly**
4. Bấm **Create policy** (mở tab mới) → chọn **JSON**, dán:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "HealyticsWhoS3Access",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:HeadObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::healytics-who-docs",
        "arn:aws:s3:::healytics-who-docs/*"
      ]
    }
  ]
}
```

> Thay `healytics-who-docs` bằng tên bucket thật của bạn.

5. Policy name: `HealyticsWhoS3Policy` → **Create policy**
6. Quay lại tab tạo user → refresh → chọn policy vừa tạo → **Next** → **Create user**
7. Vào user `healytics-who-ingestion` → tab **Security credentials**
8. **Create access key** → chọn **Application running outside AWS** → **Next** → **Create access key**
9. **Lưu ngay** (chỉ hiện 1 lần):
   - Access key ID → `AWS_ACCESS_KEY_ID`
   - Secret access key → `AWS_SECRET_ACCESS_KEY`

### Bước A4: Điền .env cho S3

Tạo file `ai_services/who_ingestion/.env`:

```env
S3_BUCKET=healytics-who-docs
S3_PREFIX=who-publications/
AWS_REGION=ap-southeast-1
AWS_ACCESS_KEY_ID=AKIA................
AWS_SECRET_ACCESS_KEY=................................
```

### Bước A5: Kiểm tra S3 hoạt động

```bash
cd ai_services
pip install boto3
python3 -c "
import boto3, os
from dotenv import load_dotenv
load_dotenv('who_ingestion/.env')
s3 = boto3.client('s3',
    region_name=os.environ['AWS_REGION'],
    aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY'])
print('Buckets:', s3.list_buckets()['Buckets'])
"
```

Nếu in ra danh sách bucket (có bucket của bạn) → S3 OK.

---

## Phần B — Tạo Amazon OpenSearch (Elasticsearch tương thích)

Pipeline RAG advanced cần:
- **Full-text search** (BM25) trên field `content_en`
- **Vector search** (kNN) trên field `embedding` (768 chiều)

AWS **OpenSearch Service** hỗ trợ cả hai.

### Bước B1: Vào OpenSearch Service

1. AWS Console → **Amazon OpenSearch Service**
2. **Create domain** (tạo cluster)

### Bước B2: Cấu hình domain (gợi ý cho đồ án / dev)

| Mục | Giá trị gợi ý |
|-----|----------------|
| Domain name | `healytics-who` |
| Deployment type | **Development and testing** (rẻ nhất) |
| Version | OpenSearch **2.11** trở lên |
| Instance type | `t3.small.search` (1 node) |
| Storage | 20 GB EBS |
| Network | **Public access** (dễ dev; production nên dùng VPC) |
| Fine-grained access | **Enable** |
| Master user | Username `healytics_admin`, password mạnh |

> Cluster public + fine-grained access: bạn truy cập bằng username/password qua HTTPS.

3. **Create** → đợi 10–20 phút (status **Active**)

### Bước B3: Lấy URL cluster (QUAN TRỌNG — hay copy nhầm)

1. Vào domain `healytics-who` vừa tạo
2. Copy **Domain endpoint** (mục General information), ví dụ:
   ```
   https://search-healytics-who-xxxxx.ap-southeast-1.es.amazonaws.com
   ```
   hoặc (endpoint mới):
   ```
   https://search-healytics-who-xxxxx.aos.ap-southeast-1.on.aws
   ```

**KHÔNG** copy URL từ thanh trình duyệt khi mở Dashboards — URL đó có `/_dashboards` ở cuối và sẽ báo **401 Unauthorized** khi gọi API.

→ Điền `ELASTICSEARCH_URL=...` (không có `/_dashboards`)

### Bước B4: Điền credentials OpenSearch

**Trường hợp A — Domain `.es.amazonaws.com` + Fine-grained access (master user):**

```env
ELASTICSEARCH_URL=https://search-healytics-who-xxxxx.ap-southeast-1.es.amazonaws.com
ELASTICSEARCH_INDEX=healytics_who_chunks
ELASTICSEARCH_USERNAME=healytics_admin
ELASTICSEARCH_PASSWORD=MatKhauManhCuaBan
ELASTICSEARCH_VERIFY_CERTS=true
# ELASTICSEARCH_USE_AWS_IAM=false
```

**Trường hợp B — Endpoint `.aos.` / `.on.aws` (cần AWS IAM, không dùng master user password):**

```env
ELASTICSEARCH_URL=https://search-healytics-who-xxxxx.aos.ap-southeast-1.on.aws
ELASTICSEARCH_USE_AWS_IAM=true
ELASTICSEARCH_INDEX=healytics_who_chunks
AWS_REGION=ap-southeast-1
AWS_ACCESS_KEY_ID=...    # cùng IAM user đã có quyền OpenSearch
AWS_SECRET_ACCESS_KEY=...
```

Gắn **một policy đủ** cho user `healytics-who-ingestion` (file có sẵn):

`who_ingestion/aws/iam-healytics-who-ingestion-policy.json`

Gồm: S3 bucket + `es:ESHttp*` (gọi API index) + `es:DescribeDomain` (script chẩn đoán).

**Quan trọng:** `es:ESHttp*` chỉ cho phép IAM **vào** cluster. Còn lỗi 403 `no permissions for cluster:monitor/main` → cần **map FGAC role** (Bước B7).

### Bước B7: Map IAM user vào FGAC (nếu dùng AWS key thay master password)

1. Đăng nhập **OpenSearch Dashboards** bằng **master user** (không phải IAM user):
   ```
   https://search-healytics-who-xxxxx.ap-southeast-1.es.amazonaws.com/_dashboards
   ```
2. Menu ☰ → **Security** → **Roles** → **all_access**
3. Tab **Mapped users** → **Manage mapping** → Add:
   ```
   arn:aws:iam::206193621163:user/healytics-who-ingestion
   ```
4. Save → trong `.env` đặt `ELASTICSEARCH_USE_AWS_IAM=true`

Hoặc sau khi master user đúng, chạy script:
```bash
python who_ingestion/scripts/setup_fgac_iam_mapping.py
```

### Bước B5: Kiểm tra kết nối

```bash
cd ai_services
pip install requests-aws4auth
python who_ingestion/scripts/test_es_connection.py
```

Nếu in `✅ Kết nối thành công` → OpenSearch OK.

### Bước B6: (Tuỳ chọn) CORS / Access policy

Nếu chatbot AWS gọi OpenSearch từ ngoài, kiểm tra **Access policy** của domain cho phép IP/user của bạn. Development/testing thường đủ với fine-grained master user.

---

## Phần C — Chạy pipeline WHO sau khi có S3 + OpenSearch

```bash
cd ai_services
cp who_ingestion/.env.example who_ingestion/.env
# Điền đủ biến S3 + ELASTICSEARCH như trên

pip install -r requirements.txt
python -m who_ingestion.pipeline --domain nutrition --limit 5   # test nhỏ trước
python -m who_ingestion.pipeline --all                           # crawl đủ 200 docs
```

### Bước C1: Bật Advanced RAG đọc từ OpenSearch

Trong `rag_langchain/.env`:

```env
RAG_MODE=advanced
ELASTICSEARCH_URL=...          # cùng URL ở trên
ELASTICSEARCH_INDEX=healytics_who_chunks
ELASTICSEARCH_USERNAME=healytics_admin
ELASTICSEARCH_PASSWORD=...
MISTRAL_API_KEY=...            # dịch query VI→EN cho BM25
```

Restart chatbot service.

---

## Phần D — Checklist thông tin cần gửi cho team / agent

Sau khi làm xong, bạn có thể cung cấp (không gửi public chat nếu là production):

| # | Thông tin | Ví dụ |
|---|-----------|-------|
| 1 | `S3_BUCKET` | `healytics-who-docs` |
| 2 | `AWS_REGION` | `ap-southeast-1` |
| 3 | `AWS_ACCESS_KEY_ID` | `AKIA...` |
| 4 | `AWS_SECRET_ACCESS_KEY` | (bí mật) |
| 5 | `ELASTICSEARCH_URL` | `https://search-...es.amazonaws.com` |
| 6 | `ELASTICSEARCH_USERNAME` | `healytics_admin` |
| 7 | `ELASTICSEARCH_PASSWORD` | (bí mật) |
| 8 | `ELASTICSEARCH_INDEX` | `healytics_who_chunks` |

---

## Chi phí ước tính (tham khảo)

| Dịch vụ | Dev/testing |
|---------|-------------|
| S3 (~200 PDF, vài GB) | ~$0.1–1/tháng |
| OpenSearch `t3.small.search` 1 node | ~$25–35/tháng |
| Data transfer | tuỳ lượng crawl |

**Tiết kiệm:** sau khi ingest xong, có thể **tắt OpenSearch domain** khi không eval; bật lại khi cần. S3 giữ PDF làm backup.

---

## Lỗi thường gặp

| Lỗi | Cách xử lý |
|-----|------------|
| `Access Denied` S3 | Kiểm tra IAM policy đúng tên bucket |
| `401 Unauthorized` | Sai master username/password; hoặc URL có `/_dashboards`; đừng dùng tên IAM user làm `ELASTICSEARCH_USERNAME` |
| `403 security_exception` IAM | IAM đã vào cluster nhưng **chưa map FGAC role** → Bước B7 |
| `AccessDenied DescribeDomain` | IAM thiếu `es:DescribeDomain` → gắn policy file `aws/iam-healytics-who-ingestion-policy.json` |
| Crawl WHO ít kết quả | Tăng `WHO_CRAWL_DELAY_SECONDS`, thử lại; WHO có thể đổi HTML |
| `dense_vector` lỗi | OpenSearch version ≥ 2.11 |
