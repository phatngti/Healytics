#!/usr/bin/env python3
"""
Tạo báo cáo HTML trực quan — hiển thị TOÀN BỘ tài liệu/chunk trên OpenSearch.

Chạy:
  cd ai_services
  python who_ingestion/scripts/generate_es_report.py
  open who_ingestion/reports/es_preview.html
"""

from __future__ import annotations

import html
import os
import sys
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

AI_SERVICES = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(AI_SERVICES))

from dotenv import load_dotenv

load_dotenv(AI_SERVICES / "who_ingestion" / ".env")
load_dotenv(AI_SERVICES / "rag_langchain" / ".env")

from common.es_client import build_elasticsearch_client

REPORT_PATH = AI_SERVICES / "who_ingestion" / "reports" / "es_preview.html"
_SOURCE = ["title", "domain", "doc_id", "chunk_id", "chunk_index", "content_en", "source_url", "token_count"]


def _client():
    return build_elasticsearch_client(
        url=os.getenv("ELASTICSEARCH_URL", ""),
        username=os.getenv("ELASTICSEARCH_USERNAME", ""),
        password=os.getenv("ELASTICSEARCH_PASSWORD", ""),
        verify_certs=os.getenv("ELASTICSEARCH_VERIFY_CERTS", "true").lower() == "true",
    )


def _fetch_all_chunks(es, index: str) -> list[dict]:
    """Lấy mọi chunk bằng scroll API."""
    all_chunks: list[dict] = []
    page_size = 500
    resp = es.search(
        index=index,
        scroll="5m",
        size=page_size,
        body={
            "_source": _SOURCE,
            "query": {"match_all": {}},
            "sort": [{"doc_id": "asc"}, {"chunk_index": "asc"}],
        },
    )
    scroll_id = resp.get("_scroll_id")
    hits = resp["hits"]["hits"]
    while hits:
        all_chunks.extend(h["_source"] for h in hits)
        resp = es.scroll(scroll_id=scroll_id, scroll="5m")
        scroll_id = resp.get("_scroll_id")
        hits = resp["hits"]["hits"]
    if scroll_id:
        try:
            es.clear_scroll(scroll_id=scroll_id)
        except Exception:
            pass
    return all_chunks


def _fetch_stats(es, index: str, chunks: list[dict]) -> dict:
    count = len(chunks)
    domain_counts: dict[str, int] = defaultdict(int)
    for c in chunks:
        domain_counts[c.get("domain") or "unknown"] += 1
    domains = sorted(
        [{"domain": k, "chunks": v} for k, v in domain_counts.items()],
        key=lambda x: -x["chunks"],
    )
    pubs: dict[str, list[dict]] = defaultdict(list)
    for c in chunks:
        pubs[c.get("doc_id") or "unknown"].append(c)
    publications = []
    for doc_id, doc_chunks in sorted(pubs.items(), key=lambda x: x[1][0].get("title", "")):
        first = doc_chunks[0]
        publications.append({
            "doc_id": doc_id,
            "title": first.get("title") or "—",
            "domain": first.get("domain") or "—",
            "source_url": first.get("source_url") or "#",
            "num_chunks": len(doc_chunks),
            "chunks": sorted(doc_chunks, key=lambda c: c.get("chunk_index", 0)),
        })
    return {
        "count": count,
        "domains": domains,
        "num_docs": len(publications),
        "publications": publications,
    }


def _render_pub(pub: dict, idx: int) -> str:
    title = html.escape(pub["title"][:120])
    domain = html.escape(pub["domain"])
    url = html.escape(pub["source_url"])
    doc_id = html.escape(pub["doc_id"])
    chunk_rows = ""
    for ch in pub["chunks"]:
        preview = html.escape((ch.get("content_en") or "")[:400].replace("\n", " "))
        chunk_id = html.escape(ch.get("chunk_id") or "—")
        chunk_idx = ch.get("chunk_index", 0)
        tokens = ch.get("token_count", "—")
        chunk_rows += f"""
          <tr>
            <td class="num">{chunk_idx}</td>
            <td><code>{chunk_id}</code></td>
            <td class="num">{tokens}</td>
            <td class="preview-cell">{preview}…</td>
          </tr>"""
    return f"""
    <details class="pub" data-title="{title.lower()}" data-domain="{domain.lower()}">
      <summary>
        <span class="pub-idx">#{idx}</span>
        <span class="badge">{domain}</span>
        <strong>{title}</strong>
        <span class="meta">{pub['num_chunks']} chunks · <code>{doc_id}</code></span>
        <a href="{url}" target="_blank" onclick="event.stopPropagation()">WHO ↗</a>
      </summary>
      <table class="chunk-table">
        <thead><tr>
          <th class="num">#</th><th>chunk_id</th><th class="num">tokens</th><th>Nội dung</th>
        </tr></thead>
        <tbody>{chunk_rows}</tbody>
      </table>
    </details>"""


def _render(stats: dict, *, index: str, cluster_url: str) -> str:
    now = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    domain_rows = "".join(
        f"<tr><td>{html.escape(d['domain'])}</td>"
        f"<td class='num'>{d['chunks']:,}</td></tr>"
        for d in stats["domains"]
    )
    pub_blocks = "".join(
        _render_pub(pub, i) for i, pub in enumerate(stats["publications"], 1)
    )
    return f"""<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8"/>
  <title>Healytics — Báo cáo OpenSearch WHO (đầy đủ)</title>
  <style>
    * {{ box-sizing: border-box; }}
    body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            margin: 0; background: #f0f4f8; color: #1a202c; }}
    .hero {{ background: linear-gradient(135deg, #0f766e, #0369a1); color: white; padding: 2rem; }}
    .hero h1 {{ margin: 0 0 .5rem; font-size: 1.6rem; }}
    .hero p {{ margin: 0; opacity: .9; }}
    .wrap {{ max-width: 1200px; margin: 0 auto; padding: 1.5rem; }}
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
    th, td {{ padding: .6rem .85rem; text-align: left; border-bottom: 1px solid #e2e8f0; }}
    th {{ background: #f8fafc; font-weight: 600; font-size: .85rem; }}
    .num {{ text-align: right; font-variant-numeric: tabular-nums; }}
    .foot {{ text-align: center; color: #94a3b8; font-size: .8rem; padding: 2rem; }}
    .flow {{ background: white; border-radius: 12px; padding: 1rem 1.2rem;
              box-shadow: 0 2px 8px rgba(0,0,0,.06); font-size: .9rem; line-height: 1.7; }}
    .flow span {{ background: #e0f2fe; padding: .15rem .45rem; border-radius: 6px; }}
    .search {{ width: 100%; padding: .75rem 1rem; border: 2px solid #e2e8f0;
               border-radius: 10px; font-size: 1rem; margin-bottom: 1rem; }}
    .search:focus {{ outline: none; border-color: #0f766e; }}
    .pub {{ background: white; border-radius: 12px; margin-bottom: .75rem;
            box-shadow: 0 2px 8px rgba(0,0,0,.06); overflow: hidden; }}
    .pub summary {{ padding: 1rem 1.2rem; cursor: pointer; list-style: none;
                     display: flex; flex-wrap: wrap; align-items: center; gap: .5rem .75rem; }}
    .pub summary::-webkit-details-marker {{ display: none; }}
    .pub summary strong {{ flex: 1 1 300px; font-size: .95rem; }}
    .pub-idx {{ color: #94a3b8; font-size: .85rem; min-width: 2rem; }}
    .badge {{ background: #ccfbf1; color: #0f766e; padding: .2rem .6rem;
               border-radius: 999px; font-size: .75rem; font-weight: 600; }}
    .meta {{ font-size: .8rem; color: #64748b; }}
    .meta code {{ font-size: .75rem; }}
    .pub a {{ font-size: .8rem; color: #0369a1; }}
    .chunk-table {{ box-shadow: none; border-radius: 0; margin: 0; }}
    .chunk-table td {{ font-size: .82rem; vertical-align: top; }}
    .preview-cell {{ color: #475569; line-height: 1.45; max-width: 600px; }}
    code {{ background: #f1f5f9; padding: .1rem .35rem; border-radius: 4px; font-size: .78rem; }}
    .hidden {{ display: none !important; }}
    .toolbar {{ display: flex; gap: .75rem; align-items: center; margin-bottom: .75rem; flex-wrap: wrap; }}
    .toolbar button {{ padding: .5rem 1rem; border: none; background: #0f766e; color: white;
                        border-radius: 8px; cursor: pointer; font-size: .85rem; }}
    .toolbar button:hover {{ background: #0d9488; }}
    .count-label {{ font-size: .85rem; color: #64748b; }}
  </style>
</head>
<body>
  <div class="hero">
    <div class="wrap">
      <h1>📊 Healytics — Toàn bộ dữ liệu WHO trên OpenSearch</h1>
      <p>Index: <strong>{html.escape(index)}</strong> · {stats['num_docs']} tài liệu · {stats['count']:,} chunks · {now}</p>
    </div>
  </div>
  <div class="wrap">
    <div class="kpis">
      <div class="kpi"><div class="val">{stats['count']:,}</div><div class="lbl">Tổng chunks (100%)</div></div>
      <div class="kpi"><div class="val">{stats['num_docs']:,}</div><div class="lbl">Tài liệu WHO (PDF)</div></div>
      <div class="kpi"><div class="val">{len(stats['domains'])}</div><div class="lbl">Lĩnh vực</div></div>
    </div>

    <h2>Phân bố theo lĩnh vực</h2>
    <table>
      <thead><tr><th>Domain</th><th class="num">Số chunk</th></tr></thead>
      <tbody>{domain_rows}</tbody>
    </table>

    <h2>Tất cả tài liệu ({stats['num_docs']}) — click để xem từng chunk</h2>
    <div class="toolbar">
      <input class="search" id="q" type="search" placeholder="Lọc theo tiêu đề hoặc domain…"/>
      <button type="button" onclick="document.querySelectorAll('.pub').forEach(p=>p.open=true)">Mở tất cả</button>
      <button type="button" onclick="document.querySelectorAll('.pub').forEach(p=>p.open=false)">Đóng tất cả</button>
      <span class="count-label" id="visible-count"></span>
    </div>
    <div id="pub-list">{pub_blocks}</div>

    <p class="foot">Cluster: {html.escape(cluster_url)} · Hiển thị đầy đủ {stats['count']:,} chunks</p>
  </div>
  <script>
    const q = document.getElementById('q');
    const pubs = document.querySelectorAll('.pub');
    const label = document.getElementById('visible-count');
    function filter() {{
      const term = q.value.trim().toLowerCase();
      let n = 0;
      pubs.forEach(p => {{
        const match = !term || p.dataset.title.includes(term) || p.dataset.domain.includes(term);
        p.classList.toggle('hidden', !match);
        if (match) n++;
      }});
      label.textContent = n + ' / {stats['num_docs']} tài liệu hiển thị';
    }}
    q.addEventListener('input', filter);
    filter();
  </script>
</body>
</html>"""


def main() -> None:
    index = os.getenv("ELASTICSEARCH_INDEX", "healytics_who_chunks")
    es = _client()
    print("Đang tải toàn bộ chunk từ OpenSearch…")
    chunks = _fetch_all_chunks(es, index)
    stats = _fetch_stats(es, index, chunks)
    REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)
    REPORT_PATH.write_text(
        _render(stats, index=index, cluster_url=os.getenv("ELASTICSEARCH_URL", "")),
        encoding="utf-8",
    )
    print(f"✅ Đã tạo báo cáo: {REPORT_PATH}")
    print(f"   {stats['num_docs']} tài liệu · {stats['count']:,} chunks (đầy đủ)")
    print("   Mở: open who_ingestion/reports/es_preview.html")


if __name__ == "__main__":
    main()
