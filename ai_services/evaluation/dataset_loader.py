import json
from typing import Any, Dict, List, Tuple


def load_eval_dataset(path: str) -> Tuple[List[Dict[str, Any]], List[Dict[str, Any]], Dict[str, str]]:
    """
    Load dataset JSON format:
    {
      "documents": [{"doc_id": "...", "content": "..."}],
      "eval_dataset": [{"id": "...", "query": "...", "ground_truth": "...", "relevant_doc_ids": [...] }]
    }
    """
    with open(path, "r", encoding="utf-8") as f:
        raw = json.load(f)

    documents = raw.get("documents", [])
    eval_dataset = raw.get("eval_dataset", [])
    docid_to_content = {d["doc_id"]: d.get("content", "") for d in documents if "doc_id" in d}

    return documents, eval_dataset, docid_to_content

