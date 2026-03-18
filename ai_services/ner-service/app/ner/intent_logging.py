import json
import logging
from datetime import datetime, timezone
from pathlib import Path

from app.core.config import settings
from app.schemas.ner_schema import NerEntity

logger = logging.getLogger(__name__)


def log_location_intent_samples(text: str, entities: list[NerEntity], query_params: dict) -> None:
    """
    Persist weakly-labeled samples for offline threshold calibration.

    Weak label:
      - applied_filter=True if current pipeline applied locationCode
      - This is not gold truth; keep for analysis / human labeling bootstrap.
    """
    if not settings.LOCATION_INTENT_LOG_ENABLED:
        return

    location_entities = [e for e in entities if e.type == "LOCATION" and e.location_code]
    if not location_entities:
        return

    applied_code = query_params.get("locationCode")

    log_path = Path(settings.LOCATION_INTENT_LOG_PATH)
    if not log_path.is_absolute():
        # Resolve relative path from service root (current process cwd in Docker/local usually service root).
        log_path = Path.cwd() / log_path

    try:
        log_path.parent.mkdir(parents=True, exist_ok=True)

        with log_path.open("a", encoding="utf-8") as f:
            for e in location_entities:
                record = {
                    "timestamp": datetime.now(timezone.utc).isoformat(),
                    "text": text,
                    "location_value": e.value,
                    "location_code": e.location_code,
                    "location_level": e.location_level,
                    "intent_score": e.location_intent_score,
                    "intent_decision": e.location_intent,
                    "applied_filter": bool(applied_code and applied_code == e.location_code),
                    "label": None,
                }
                f.write(json.dumps(record, ensure_ascii=False) + "\n")
    except Exception as exc:
        logger.warning("[IntentLogging] Failed to write location-intent sample: %s", exc)
