""" Nguyên sẽ thực hiện file này
1. Mục tiêu: Implement User Repository Layer cho recommender service.
    Repository layer có nhiệm vụ:
    - Truy vấn dữ liệu user từ database
    - Xây dựng thông tin cần thiết để recommender hoạt động

2. Luồng tổng quan

    Gateway Service
        ↓
    Recommender API (FastAPI)
        ↓
    User Repository   ← (NGUYÊN implement)
        ↓
    Database

    ===> UI sẽ gửi user_id, và Nguyên dựa vào user_id rồi đi vào database để lấy các thông tin cần thiết cho recommender system (health_conditions, interests, goals, services_history)

3. Required Output Format

    Repository phải trả về normalized profile:

    {
        "health_conditions": List[str],
        "interests": List[str],
        "goals" : List[str],
        "service_history_ids": List[str]
    }

    Đây là format mà recommender model cần.

4. Required Functions
    async def get_user_health_conditions(session, user_id: str) -> list[str]:
        pass
    
    async def get_user_interests(session, user_id: str) -> list[str]:
        pass

    async def get_user_service_history(session, user_id: str) -> list[str]:
        pass

    async def get_user_goals(session, user_id: str) -> list[str]:
        pass
    
    async def build_user_profile(session, user_id: str) -> dict:
        Hàm này sẽ gọi 4 hàm ở trên  rồi trả về 1 dict hoàn chỉnh cho bên recommender system

"""

import logging
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from src.models.account import Account
from src.models.user_profile import UserProfile

logger = logging.getLogger(__name__)


async def get_user_health_conditions(
    session: AsyncSession, user_id: str | UUID
) -> list[str]:
    """
    Return the user's health conditions from account.survey JSONB.
    Returns an empty list if the user has no survey data.
    """
    account = await _get_account(session, user_id)
    return _extract_list(account.survey if account else None, "health_conditions")


async def get_user_interests(
    session: AsyncSession, user_id: str | UUID
) -> list[str]:
    """
    Return the user's interests from account.survey JSONB.
    Returns an empty list if the user has no survey data.
    """
    account = await _get_account(session, user_id)
    return _extract_list(account.survey if account else None, "interests")


async def get_user_goals(
    session: AsyncSession, user_id: str | UUID
) -> list[str]:
    """
    Return the user's goals from account.survey JSONB.
    Returns an empty list if the user has no survey data.
    """
    account = await _get_account(session, user_id)
    return _extract_list(account.survey if account else None, "goals")


async def get_user_service_history(
    session: AsyncSession, user_id: str | UUID
) -> list[str]:
    """
    Return completed service IDs for the user.

    NOTE: Service history will be wired to the orders table once that
    data model is finalised. Returns an empty list for now.
    """
    # TODO: query orders table when the schema is available
    return []


async def build_user_profile(
    session: AsyncSession, user_id: str | UUID
) -> dict:
    """
    Build the normalised user profile dict expected by the recommender.

    Queries run sequentially — AsyncSession does not support concurrent
    queries on the same connection (asyncio.gather would cause
    InvalidRequestError: Can't operate on closed transaction).

    Returned shape::

        {
            "user_id":             str,
            "email":               str | None,
            "username":            None,
            "name":                str | None,
            "phone":               str | None,
            "bio":                 str | None,
            "date_of_birth":       str | None,   # ISO-8601 (YYYY-MM-DD)
            "age":                 int | None,
            "goals":               list[str],
            "interests":           list[str],
            "health_conditions":   list[str],
            "service_history_ids": list[str],
        }
    """
    from datetime import date as date_type

    # 1. Fetch account first — abort early if user doesn't exist at all.
    account = await _get_account(session, user_id)
    if not account:
        return None

    # 2. Fetch profile and service history sequentially.
    profile = await _get_user_profile(session, user_id)
    service_history = await get_user_service_history(session, user_id)

    # 3. Derive name and age from user_profile fields.
    name: str | None = None
    age: int | None = None
    if profile:
        parts = [profile.first_name or "", profile.last_name or ""]
        name = " ".join(p for p in parts if p).strip() or None

        if profile.date_of_birth:
            today = date_type.today()
            dob = profile.date_of_birth
            age = (
                today.year - dob.year
                - ((today.month, today.day) < (dob.month, dob.day))
            )

    return {
        # ── Identity (from account) ──────────────────────────────────
        "user_id":             str(user_id),
        "email":               account.email,
        "username":            None,

        # ── Personal info (from user_profile) ───────────────────────
        "name":                name,                 # first + last
        "phone":               profile.phone if profile else None,
        "bio":                 profile.bio if profile else None,
        "date_of_birth":       (
            profile.date_of_birth.isoformat()
            if profile and profile.date_of_birth else None
        ),
        "age":                 age,                  # derived at query time

        # ── Recommender inputs (from account.survey) ─────────────────
        "goals":               _extract_list(account.survey, "goals"),
        "interests":           _extract_list(account.survey, "interests"),
        "health_conditions":   _extract_list(account.survey, "health_conditions"),
        "service_history_ids": service_history,
    }


# ---------------------------------------------------------------------------
# Survey field → recommender category mapping
# ---------------------------------------------------------------------------
# The Flutter app stores survey answers by section, each as a list of
# {"question": <field_key>, "value": <chosen_value>} objects:
#
#   {
#     "general_goals":     [{"question": "primary_goal",  "value": "relax"}, ...],
#     "lifestyle_activity":[{"question": "screen_time",   "value": "high"},  ...],
#     "body_energy":       [{"question": "morning_energy","value": "fresh"},  ...],
#     "health_safety":     [{"question": "blood_pressure","value": "normal"}, ...]
#   }
#
# We flatten those sections into a {field_key: value} dict, then group
# values into the three categories the recommender model expects.

# All 4 survey sections, in submission order.
_SURVEY_SECTIONS = [
    "general_goals",
    "lifestyle_activity",
    "body_energy",
    "health_safety",
]

# Which of the 14 field keys map to each recommender category.
_CATEGORY_FIELDS: dict[str, list[str]] = {
    "goals": [
        "primary_goal",
    ],
    "interests": [
        "lifestyle_nature",
        "screen_time",
        "exercise_frequency",
        "work_posture",
        "hydration_habit",
    ],
    "health_conditions": [
        "sleep_quality",
        "stress_level",
        "morning_energy",
        "headache_frequency",
        "leg_condition",
        "blood_pressure",
        "women_condition",
        "injury_history",
    ],
}


# ---------------------------------------------------------------------------
# Private helpers
# ---------------------------------------------------------------------------

async def _get_account(
    session: AsyncSession, user_id: str | UUID
) -> Account | None:
    """Fetch the full Account row for the given user id."""
    result = await session.execute(
        select(Account).where(Account.id == user_id)
    )
    row = result.scalar_one_or_none()
    if row is None:
        logger.warning("Account not found for user_id=%s", user_id)
    return row


async def _get_user_profile(
    session: AsyncSession, user_id: str | UUID
) -> UserProfile | None:
    """
    Fetch the UserProfile row for the given user.
    Returns None if no profile exists yet — this is valid for new users
    who have not completed the profile setup step.
    """
    result = await session.execute(
        select(UserProfile).where(UserProfile.account_id == user_id)
    )
    row = result.scalar_one_or_none()
    if row is None:
        logger.warning("UserProfile not found for user_id=%s", user_id)
    return row


def _flatten_survey(survey: dict | None) -> dict[str, str]:
    """
    Convert the section-based survey JSONB into a flat field→value dict.

    Input (from DB)::

        {
            "general_goals": [
                {"question": "primary_goal", "value": "relax"},
                ...
            ],
            ...
        }

    Output::

        {"primary_goal": "relax", "screen_time": "high", ...}
    """
    if not survey:
        return {}
    flat: dict[str, str] = {}
    for section in _SURVEY_SECTIONS:
        entries = survey.get(section, [])
        if not isinstance(entries, list):
            continue
        for entry in entries:
            if isinstance(entry, dict):
                q = entry.get("question") or entry.get("key")
                v = entry.get("value")
                if q and v is not None:
                    flat[str(q)] = str(v)
    return flat


def _extract_list(
    survey: dict | None, category: str
) -> list[str]:
    """
    Return the list of chosen values for all fields in *category*.

    Handles both the new section-based format (from the Flutter app)
    and the legacy flat format {category: [value, ...]}  so existing
    data keeps working without a migration.
    """
    if not survey:
        return []

    # --- New format: section-based, needs flattening ---
    if any(s in survey for s in _SURVEY_SECTIONS):
        flat = _flatten_survey(survey)
        field_keys = _CATEGORY_FIELDS.get(category, [])
        return [flat[k] for k in field_keys if k in flat]

    # --- Legacy flat format: {category: [str, ...]} ---
    value = survey.get(category, [])
    if isinstance(value, list):
        return [str(v) for v in value]
    return []