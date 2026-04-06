"""
teardown_runpod.py
==================
Terminate (xoá) tất cả pods Healytics dựa vào file runpod_deploy_result.json
được tạo bởi deploy_runpod.py.

Cách dùng:
  python teardown_runpod.py
  # Hoặc chỉ terminate 1 pod cụ thể:
  python teardown_runpod.py --pod-id abc123
"""

import os
import sys
import json
import argparse
import requests

RUNPOD_API_KEY = os.getenv("RUNPOD_API_KEY", "PASTE_YOUR_RUNPOD_API_KEY_HERE")
RUNPOD_GQL     = "https://api.runpod.io/graphql"
RESULT_FILE    = "runpod_deploy_result.json"


def gql(query: str, variables: dict = None):
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


def terminate_pod(pod_id: str, name: str = ""):
    mutation = """
    mutation TerminatePod($podId: String!) {
      podTerminate(input: { podId: $podId })
    }
    """
    gql(mutation, {"podId": pod_id})
    label = f"'{name}' ({pod_id})" if name else pod_id
    print(f"  ✓ Terminated: {label}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--pod-id", help="Terminate một pod cụ thể thay vì đọc từ file")
    args = parser.parse_args()

    if RUNPOD_API_KEY == "PASTE_YOUR_RUNPOD_API_KEY_HERE":
        print("❌ Chưa set RUNPOD_API_KEY!")
        sys.exit(1)

    if args.pod_id:
        print(f"Terminating pod {args.pod_id}...")
        terminate_pod(args.pod_id)
        return

    if not os.path.exists(RESULT_FILE):
        print(f"❌ Không tìm thấy {RESULT_FILE}. Chạy deploy_runpod.py trước.")
        sys.exit(1)

    with open(RESULT_FILE) as f:
        summary = json.load(f)

    pod_ids = summary.get("pod_ids", {})
    if not pod_ids:
        print("❌ Không có pod_ids trong file kết quả.")
        sys.exit(1)

    print("🛑 Terminating all Healytics pods...")
    for name, pod_id in pod_ids.items():
        try:
            terminate_pod(pod_id, name)
        except Exception as e:
            print(f"  ⚠ Lỗi khi terminate {name}: {e}")

    print("\n✅ Tất cả pods đã được terminate.")


if __name__ == "__main__":
    main()