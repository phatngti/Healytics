"""
deploy_runpod.py
================
Tự động tạo 4 pods Healytics trên RunPod theo đúng thứ tự dependency:
  1. healytics_chatbot   (GPU - cần chạy trước)
  2. healytics_recommender
  3. healytics_ner
  4. healytics_gateway   (cần URL của 3 pod trên)

Cách dùng:
  pip install requests
  python deploy_runpod.py

Hoặc override bất kỳ biến nào qua environment:
  RUNPOD_API_KEY=xxx python deploy_runpod.py
"""

import os
import sys
import time
import json
import requests

# =============================================================================
# ⚙️  CẤU HÌNH 
# =============================================================================

RUNPOD_API_KEY = os.getenv("RUNPOD_API_KEY", "rpa_YLFOSR3Y8TV48UIROA1M30BE76DKOPJUD2STEOYArbg62b")

# Shared env cho tất cả pods
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+asyncpg://healytics:abcd%401234@healytics.postgres.database.azure.com:5432/postgres?ssl=require",
)

# NER / Gemini
GEMINI_API_KEY  = os.getenv("GEMINI_API_KEY",  "AIzaSyAABEaGsCp4jb5n8YKPzDiVkRs84YHV2Ys")
GEMINI_MODEL    = os.getenv("GEMINI_MODEL",    "gemini-2.5-flash")
GEMINI_API_BASE = os.getenv("GEMINI_API_BASE", "https://generativelanguage.googleapis.com/v1beta")

# Thời gian chờ tối đa (giây) để pod chuyển sang RUNNING
POD_READY_TIMEOUT = int(os.getenv("POD_READY_TIMEOUT", "300"))   # 5 phút
POD_POLL_INTERVAL = int(os.getenv("POD_POLL_INTERVAL", "10"))    # poll mỗi 10s

# =============================================================================
# RunPod GraphQL helper
# =============================================================================

RUNPOD_GQL = "https://api.runpod.io/graphql"

def gql(query: str, variables: dict = None):
    """Gọi RunPod GraphQL API."""
    payload = {"query": query}
    if variables:
        payload["variables"] = variables
    resp = requests.post(
        RUNPOD_GQL,
        json=payload,
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {RUNPOD_API_KEY}",
        },
        timeout=30,
    )
    resp.raise_for_status()
    data = resp.json()
    if "errors" in data:
        raise RuntimeError(f"GraphQL error: {json.dumps(data['errors'], indent=2)}")
    return data["data"]


def create_pod(
    name: str,
    image: str,
    ports: str,             # e.g. "5000/http"
    env: dict,
    gpu_type_id: str = None,
    container_disk_gb: int = 5,
    volume_disk_gb: int = 0,
    min_vcpu: int = 2,
    min_memory_gb: int = 4,
) -> str:
    """Tạo pod, trả về pod_id."""

    env_list = [{"key": k, "value": v} for k, v in env.items()]

    if gpu_type_id:
        # GPU pod
        mutation = """
        mutation CreateGpuPod($input: PodFindAndDeployOnDemandInput!) {
          podFindAndDeployOnDemand(input: $input) {
            id
            name
            desiredStatus
          }
        }
        """
        variables = {
            "input": {
                "name": name,
                "imageName": image,
                "gpuTypeId": gpu_type_id,
                "containerDiskInGb": container_disk_gb,
                "volumeInGb": volume_disk_gb,
                "ports": ports,
                "env": env_list,
                "dockerArgs": "",
                "minVcpuCount": 2,
                "minMemoryInGb": 15,
            }
        }
        data = gql(mutation, variables)
        pod = data["podFindAndDeployOnDemand"]
    else:
        # CPU pod
        mutation = """
        mutation CreateCpuPod($input: PodFindAndDeployOnDemandInput!) {
          podFindAndDeployOnDemand(input: $input) {
            id
            name
            desiredStatus
          }
        }
        """
        variables = {
            "input": {
                "name": name,
                "imageName": image,
                "gpuTypeId": None,
                "containerDiskInGb": container_disk_gb,
                "volumeInGb": volume_disk_gb,
                "ports": ports,
                "env": env_list,
                "dockerArgs": "",
                "minVcpuCount": min_vcpu,
                "minMemoryInGb": min_memory_gb,
                "cloudType": "SECURE",   # CPU pods thường là SECURE cloud
            }
        }
        data = gql(mutation, variables)
        pod = data["podFindAndDeployOnDemand"]

    pod_id = pod["id"]
    print(f"  ✓ Pod '{name}' created → id: {pod_id}")
    return pod_id


def wait_for_pod(pod_id: str, pod_name: str, timeout: int = POD_READY_TIMEOUT) -> str:
    """
    Poll đến khi pod RUNNING, trả về pod_id để build URL.
    RunPod không trả runtime URL qua API — URL được tính từ pod_id.
    """
    query = """
    query Pod($podId: String!) {
      pod(input: { podId: $podId }) {
        id
        desiredStatus
        runtime {
          uptimeInSeconds
          ports {
            ip
            isIpPublic
            privatePort
            publicPort
            type
          }
        }
      }
    }
    """
    deadline = time.time() + timeout
    print(f"  ⏳ Waiting for '{pod_name}' to be RUNNING", end="", flush=True)
    while time.time() < deadline:
        try:
            data = gql(query, {"podId": pod_id})
            pod = data.get("pod") or {}
            status = pod.get("desiredStatus", "")
            runtime = pod.get("runtime")
            if status == "RUNNING" and runtime:
                print(" ✓")
                return pod_id
        except Exception as e:
            print(f"\n  ⚠ Poll error: {e}")
        print(".", end="", flush=True)
        time.sleep(POD_POLL_INTERVAL)

    print(f"\n  ✗ Timeout waiting for {pod_name} after {timeout}s")
    sys.exit(1)


def pod_url(pod_id: str, port: int) -> str:
    """Build RunPod proxy URL từ pod_id và port."""
    return f"https://{pod_id}-{port}.proxy.runpod.net"


# =============================================================================
# Deploy sequence
# =============================================================================

def main():
    if RUNPOD_API_KEY == "PASTE_YOUR_RUNPOD_API_KEY_HERE":
        print("❌ Chưa set RUNPOD_API_KEY! Sửa trong script hoặc:")
        print("   export RUNPOD_API_KEY=your_key && python deploy_runpod.py")
        sys.exit(1)

    print("=" * 60)
    print("🚀 Healytics — RunPod Auto Deploy")
    print("=" * 60)

    # ------------------------------------------------------------------
    # STEP 1: POD1 — healytics_chatbot (GPU)
    # ------------------------------------------------------------------
    print("\n[1/4] Creating healytics_chatbot (GPU - RTX A5000)...")
    pod1_id = create_pod(
        name="healytics_chatbot",
        image="giahung2111/healytics_chatbot_rag:8b",
        gpu_type_id="NVIDIA RTX A5000",   # RunPod GPU type ID
        ports="5000/http",
        container_disk_gb=30,
        volume_disk_gb=50,
        env={
            "DATABASE_URL": DATABASE_URL,
        },
    )
    wait_for_pod(pod1_id, "healytics_chatbot")
    chatbot_url = pod_url(pod1_id, 5000)
    print(f"  🌐 Chatbot URL: {chatbot_url}")

    # ------------------------------------------------------------------
    # STEP 2: POD3 — healytics_recommender (CPU)
    # ------------------------------------------------------------------
    print("\n[2/4] Creating healytics_recommender (CPU)...")
    pod3_id = create_pod(
        name="healytics_recommender",
        image="giahung2111/healytics_recommender:latest",
        ports="8000/http",
        container_disk_gb=5,
        env={
            "DATABASE_URL": DATABASE_URL,
        },
    )
    wait_for_pod(pod3_id, "healytics_recommender")
    recommender_url = pod_url(pod3_id, 8000)
    print(f"  🌐 Recommender URL: {recommender_url}")

    # ------------------------------------------------------------------
    # STEP 3: POD4 — healytics_ner (CPU)
    # ------------------------------------------------------------------
    print("\n[3/4] Creating healytics_ner (CPU)...")
    pod4_id = create_pod(
        name="healytics_ner",
        image="giahung2111/healytics_ner:latest",
        ports="7000/http",
        container_disk_gb=5,
        env={
            "DATABASE_URL": DATABASE_URL,
            "LOCATION_CACHE_TTL": "86400",
            "CATEGORY_CACHE_TTL": "300",
            "QUERY_CACHE_MAXSIZE": "512",
            "PORT": "8002",
            "LLM_NER_ENABLED": "true",
            "GEMINI_API_KEY": GEMINI_API_KEY,
            "GEMINI_MODEL": GEMINI_MODEL,
            "GEMINI_API_BASE_URL": GEMINI_API_BASE,
            "GEMINI_TIMEOUT_MS": "8000",
        },
    )
    wait_for_pod(pod4_id, "healytics_ner")
    ner_url = pod_url(pod4_id, 7000)
    print(f"  🌐 NER URL: {ner_url}")

    # ------------------------------------------------------------------
    # STEP 4: POD2 — healytics_gateway (CPU) — tạo SAU cùng với đầy đủ URL
    # ------------------------------------------------------------------
    print("\n[4/4] Creating healytics_gateway (CPU) with all URLs pre-filled...")
    pod2_id = create_pod(
        name="healytics_gateway",
        image="giahung2111/healytics_gateway:latest",
        ports="9000/http",
        container_disk_gb=5,
        env={
            "DATABASE_URL": DATABASE_URL,
            "CHATBOT_SERVICE_URL":     chatbot_url + "/",
            "RECOMMENDER_SERVICE_URL": recommender_url + "/",
            "NER_SERVICE_URL":         ner_url + "/",
            "HTTP_CONNECT_TIMEOUT":    "5.0",
            "HTTP_READ_TIMEOUT":       "500.0",
            "HTTP_WRITE_TIMEOUT":      "10.0",
            "HTTP_POOL_TIMEOUT":       "5.0",
        },
    )
    wait_for_pod(pod2_id, "healytics_gateway")
    gateway_url = pod_url(pod2_id, 9000)
    print(f"  🌐 Gateway URL: {gateway_url}")

    # ------------------------------------------------------------------
    # SUMMARY
    # ------------------------------------------------------------------
    print("\n" + "=" * 60)
    print("✅ Deploy hoàn tất!")
    print("=" * 60)
    print(f"  Gateway    → {gateway_url}")
    print(f"  Chatbot    → {chatbot_url}")
    print(f"  Recommender→ {recommender_url}")
    print(f"  NER        → {ner_url}")
    print()
    print("Pod IDs (dùng để terminate sau này):")
    print(f"  POD1 chatbot    : {pod1_id}")
    print(f"  POD2 gateway    : {pod2_id}")
    print(f"  POD3 recommender: {pod3_id}")
    print(f"  POD4 ner        : {pod4_id}")

    # Ghi ra file để tiện dùng lại
    summary = {
        "gateway_url":     gateway_url,
        "chatbot_url":     chatbot_url,
        "recommender_url": recommender_url,
        "ner_url":         ner_url,
        "pod_ids": {
            "chatbot":     pod1_id,
            "gateway":     pod2_id,
            "recommender": pod3_id,
            "ner":         pod4_id,
        },
    }
    out_file = "runpod_deploy_result.json"
    with open(out_file, "w") as f:
        json.dump(summary, f, indent=2)
    print(f"\n  📄 Đã lưu kết quả vào: {out_file}")


if __name__ == "__main__":
    main()