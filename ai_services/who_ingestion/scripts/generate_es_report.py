#!/usr/bin/env python3
"""
Tạo báo cáo HTML trực quan dữ liệu OpenSearch — mở bằng browser cho giáo viên xem.

Chạy:
  cd ai_services
  python who_ingestion/scripts/generate_es_report.py
  open who_ingestion/reports/es_preview.html
"""

from __future__ import annotations

import html
import os
import sys
from datetime import datetime, timezone
from pathlib import Path

AI_SERVICES = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(AI_SERVICES))

from dotenv import load_dotenv

load_dotenv(AI_SERVICES / "who_ingestion" / ".env")
load_dotenv(AI_SERVICES / "rag_langchain" / ".env")

from common.es_client import build_elasticsearch_client

REPORT_PATH = AI_SERVICES / "who_ingestion" / "reports" / "es_preview.html"


def _client():
    return build_elasticsearch_client(
        url=os.getenv("ELASTICSEARCH_URL", ""),
        username=os.getenv("ELASTICSEARCH_USERNAME", ""),
        password=os.getenv("ELASTICSEARCH_PASSWORD", ""),
        verify_certs=os.getenv("ELASTICSEARCH_VERIFY_CERTS", "true").lower() == "true",
    )


def _fetch_stats(es, index: str) -> dict:
    count = es.count(index=index)["count"]
    agg = es.search(
        index=index,
        body={
            "size": 0,
            "aggs": {
                "by_domain": {"terms": {"field": "domain", "size": 20}},
                "by_doc": {"terms": {"field": "doc_id", "size": 500}},
            },
        },
    )
    domains = [
        {"domain": b["key"], "chunks": b["doc_count"]}
        for b in agg["aggregations"]["by_domain"]["buckets"]
    ]
    num_docs = len(agg["aggregations"]["by_doc"]["buckets"])
    samples = es.search(
        index=index,
        body={
            "size": 12,
            "_source": ["title", "domain", "chunk_id", "content_en", "source_url"],
            "query": {"match_all": {}},
            "sort": [{"_id": "asc"}],
        },
    )
    return {
        "count": count,
        "domains": domains,
        "num_docs": num_docs,
        "samples": [h["_source"] for h in samples["hits"]["hits"]],
    }


def _render(stats: dict, *, index: str, cluster_url: str) -> str:
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    domain_rows = "".join(
        f"<tr><td>{html.escape(d['domain'])}</td>"
        f"<td class='num'>{d['chunks']:,}</td></tr>"
        for d in stats["domains"]
    )
    sample_cards = ""
    for i, doc in enumerate(stats["samples"], 1):
        title = html.escape((doc.get("title") or "—")[:100])
        domain = html.escape(doc.get("domain") or "—")
        preview = html.escape((doc.get("content_en") or "")[:280].replace("\n", " "))
        url = html.escape(doc.get("source_url") or "#")
        sample_cards += f"""
        <article class="card">
          <div class="card-head"><span class="badge">{domain}</span> #{i}</div>
          <h3>{title}</h3>
          <p class="preview">{preview}…</p>
          <a href="{url}" target="_blank">Nguồn WHO ↗</a>
        </article>"""

    return f"""<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <title>Healytics — Báo cáo OpenSearch WHO</title>
  <style>
    * {{ box-sizing: border-box; }}
    body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 0; background: #f0f4f8; color: #1a202c; }}
    .hero {{ background: linear-gradient(135deg, #0f766e, #0369a1); color: white;
             padding: 2rem; }}
    .hero h1 {{ margin: 0 0 .5rem; font-size: 1.6rem; }}
    .hero p {{ margin: 0; opacity: .9; }}
    .wrap {{ max-width: 1100px; margin: 0 auto; padding: 1.5rem; }}
    .kpis {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
              gap: 1rem; margin-bottom: 1.5rem; }}
    .kpi {{ background: white; border-radius: 12px; padding: 1.2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,.06); }}
    .kpi .val {{ font-size: 2rem; font-weight: 700; color: #0f766e; }}
    .kpi .lbl {{ font-size: .85rem; color: #64748b; margin-top: .25rem; }}
    h2 {{ font-size: 1.1rem; margin: 1.5rem 0 .75rem; }}
    table {{ width: 100%; border-collapse: collapse; background: white;
              border-radius: 12px; overflow: hidden;
              box-shadow: 0 2px 8px rgba(0,0,0,.06); }}
    th, td {{ padding: .75rem 1rem; text-align: left; border-bottom: 1px solid #e2e8f0; }}
    th {{ background: #f8fafc; font-weight: 600; }}
    .num {{ text-align: right; font-variant-numeric: tabular-nums; }}
    .cards {{ display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1rem; }}
    .card {{ background: white; border-radius: 12px; padding: 1rem;
              box-shadow: 0 2px 8px rgba(0,0,0,.06); }}
    .card-head {{ display: flex; justify-content: space-between; margin-bottom: .5rem; }}
    .badge {{ background: #ccfbf1; color: #0f766e; padding: .2rem .6rem;
               border-radius: 999px; font-size: .75rem; font-weight: 600; }}
    .card h3 {{ margin: 0 0 .5rem; font-size: .95rem; line-height: 1.35; }}
    .preview {{ font-size: .82rem; color: #475569; line-height: 1.5; margin: 0 0 .5rem; }}
    .card a {{ font-size: .8rem; color: #0369a1; }}
    .foot {{ text-align: center; color: #94a3b8; font-size: .8rem; padding: 2rem; }}
    .flow {{ background: white; border-radius: 12px; padding: 1rem 1.2rem;
              box-shadow: 0 2px 8px rgba(0,0,0,.06); font-size: .9rem; line-height: 1.7; }}
    .flow span {{ background: #e0f2fe; padding: .15rem .45rem; border-radius: 6px; }}
  </style>
</head>
<body>
  <div class="hero">
    <div class="wrap">
      <h1>📊 Healytics — Kho tri thức WHO trên AWS OpenSearch</h1>
      <p>Index: <strong>{html.escape(index)}</strong> · Cập nhật: {now}</p>
    </div>
  </div>
  <div class="wrap">
    <div class="kpis">
      <div class="kpi"><div class="val">{stats['count']:,}</div><div class="lbl">Tổng đoạn văn (chunks)</div></div>
      <div class="kpi"><div class="val">{stats['num_docs']:,}</div><div class="lbl">Tài liệu WHO (PDF)</div></div>
      <div class="kpi"><div class="val">{len(stats['domains'])}</div><div class="lbl">Lĩnh vực y tế</div></div>
    </div>

    <h2>Luồng hệ thống (cho giáo viên)</h2>
    <div class="flow">
      Crawl WHO → Đọc PDF → Cắt đoạn + <span>Embedding 768 chiều</span>
      → Lưu <span>OpenSearch</span> (BM25 + Vector) → Chatbot <span>RAG hybrid</span> trả lời
    </div>

    <h2>Phân bố theo lĩnh vực</h2>
    <table>
      <thead><tr><th>Domain</th><th class="num">Số chunk</th></tr></thead>
      <tbody>{domain_rows}</tbody>
    </table>

    <h2>Mẫu dữ liệu đã lưu (12 chunk đầu)</h2>
    <div class="cards">{sample_cards}</div>

    <p class="foot">
      Cluster: {html.escape(cluster_url)} ·
      Mở file này bằng Chrome/Safari để demo — không cần Dev Tools.
    </p>
  </div>
</body>
</html>"""


def main() -> None:
    index = os.getenv("ELASTICSEARCH_INDEX", "healytics_who_chunks")
    es = _client()
    stats = _fetch_stats(es, index)
    REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)
    REPORT_PATH.write_text(
        _render(stats, index=index, cluster_url=os.getenv("ELASTICSEARCH_URL", "")),
        encoding="utf-8",
    )
    print(f"✅ Đã tạo báo cáo: {REPORT_PATH}")
    print(f"   Chunks: {stats['count']:,} | Tài liệu: {stats['num_docs']:,}")
    print("   Mở bằng: open who_ingestion/reports/es_preview.html")


if __name__ == "__main__":
    main()
