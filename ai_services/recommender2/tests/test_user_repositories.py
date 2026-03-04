"""
tests/test_user_repositories.py

Two-tier test strategy:
    1. Unit tests  — pure Python, test survey flattening/extraction in
                     isolation (no DB required).
    2. Integration — async DB tests using the SQLite fixture from conftest.py,
                     covering build_user_profile and _get_account.

Run all:
    python -m pytest tests/test_user_repositories.py -v
"""

import uuid
from datetime import date

import pytest
from sqlalchemy.ext.asyncio import AsyncSession

from src.models.account import Account
from src.models.user_profile import UserProfile
from src.repositories.user_repositories import (
    _extract_list,
    _flatten_survey,
    build_user_profile,
    get_user_goals,
    get_user_health_conditions,
    get_user_interests,
)


# ===========================================================================
# 1. UNIT TESTS — pure Python, no database
# ===========================================================================

class TestFlattenSurvey:
    def test_new_flutter_format_flattened_correctly(self):
        """Nested section-based JSON should become a flat {key: value} dict."""
        survey = {
            "general_goals": [
                {"question": "primary_goal", "value": "relax"},
                {"question": "stress_level", "value": "anxious"},
            ],
            "lifestyle_activity": [
                {"question": "screen_time", "value": "high"},
            ],
        }
        flat = _flatten_survey(survey)
        assert flat["primary_goal"] == "relax"
        assert flat["stress_level"] == "anxious"
        assert flat["screen_time"] == "high"

    def test_unknown_sections_are_ignored(self):
        """Only the 4 known survey sections should be flattened."""
        survey = {
            "general_goals": [{"question": "primary_goal", "value": "beauty"}],
            "random_extra_section": [{"question": "foo", "value": "bar"}],
        }
        flat = _flatten_survey(survey)
        assert "foo" not in flat

    def test_none_survey_returns_empty_dict(self):
        assert _flatten_survey(None) == {}

    def test_empty_survey_returns_empty_dict(self):
        assert _flatten_survey({}) == {}


class TestExtractList:
    def test_goals_from_flutter_format(self):
        survey = {
            "general_goals": [
                {"question": "primary_goal", "value": "relax"},
                {"question": "stress_level", "value": "anxious"},
            ],
        }
        assert _extract_list(survey, "goals") == ["relax"]

    def test_interests_from_flutter_format(self):
        survey = {
            "lifestyle_activity": [
                {"question": "screen_time", "value": "extreme"},
                {"question": "exercise_frequency", "value": "athlete"},
            ],
        }
        interests = _extract_list(survey, "interests")
        assert "extreme" in interests
        assert "athlete" in interests

    def test_health_conditions_from_multiple_sections(self):
        survey = {
            "general_goals": [
                {"question": "sleep_quality", "value": "restless"},
            ],
            "health_safety": [
                {"question": "blood_pressure", "value": "high"},
            ],
        }
        health = _extract_list(survey, "health_conditions")
        assert "restless" in health
        assert "high" in health

    def test_legacy_flat_format_still_works(self):
        """Backward compatibility: old flat {category: [values]} format."""
        survey = {
            "goals": ["pain_relief", "beauty"],
            "interests": ["yoga"],
        }
        assert _extract_list(survey, "goals") == ["pain_relief", "beauty"]
        assert _extract_list(survey, "interests") == ["yoga"]
        assert _extract_list(survey, "health_conditions") == []

    def test_none_survey_returns_empty_list(self):
        assert _extract_list(None, "goals") == []

    def test_missing_fields_return_empty_not_error(self):
        """Fields not answered in survey should return empty, not KeyError."""
        survey = {
            "general_goals": [
                {"question": "primary_goal", "value": "relax"},
            ],
        }
        # screen_time, exercise_frequency etc. not answered
        interests = _extract_list(survey, "interests")
        assert isinstance(interests, list)


# ===========================================================================
# 2. INTEGRATION TESTS — database required (fixtures from conftest.py)
# ===========================================================================

@pytest.mark.asyncio
async def test_build_user_profile_with_full_data(
    db_session: AsyncSession,
):
    """User with both Account + UserProfile → full profile returned."""
    user_id = uuid.uuid4()
    account = Account(
        id=user_id,
        email="jane@example.com",
        username="jane_doe",
        survey={
            "general_goals": [
                {"question": "primary_goal", "value": "relax"},
                {"question": "stress_level", "value": "anxious"},
            ],
            "lifestyle_activity": [
                {"question": "screen_time", "value": "high"},
            ],
            "health_safety": [
                {"question": "blood_pressure", "value": "normal"},
            ],
        },
    )
    profile = UserProfile(
        id=uuid.uuid4(),
        account_id=user_id,
        first_name="Jane",
        last_name="Doe",
        phone="0901234567",
        date_of_birth=date(1990, 5, 15),
    )
    db_session.add(account)
    db_session.add(profile)
    await db_session.flush()

    result = await build_user_profile(db_session, user_id)

    assert result is not None
    assert result["email"] == "jane@example.com"
    assert result["username"] == "jane_doe"
    assert result["name"] == "Jane Doe"
    assert result["phone"] == "0901234567"
    assert result["age"] is not None and result["age"] > 0
    assert result["date_of_birth"] == "1990-05-15"
    assert result["goals"] == ["relax"]
    assert "high" in result["interests"]
    assert "anxious" in result["health_conditions"]
    assert "normal" in result["health_conditions"]


@pytest.mark.asyncio
async def test_build_user_profile_account_only(
    db_session: AsyncSession,
):
    """User with Account but no UserProfile — still returns email/survey data."""
    user_id = uuid.uuid4()
    account = Account(
        id=user_id,
        email="newuser@example.com",
        survey={
            "general_goals": [
                {"question": "primary_goal", "value": "therapy"},
            ],
        },
    )
    db_session.add(account)
    await db_session.flush()

    result = await build_user_profile(db_session, user_id)

    assert result is not None
    assert result["email"] == "newuser@example.com"
    assert result["name"] is None        # no profile yet
    assert result["age"] is None
    assert result["goals"] == ["therapy"]  # survey still retrieved


@pytest.mark.asyncio
async def test_build_user_profile_no_survey(
    db_session: AsyncSession,
):
    """User with no survey answered — all recommender lists are empty."""
    user_id = uuid.uuid4()
    account = Account(id=user_id, email="nosruvey@example.com", survey=None)
    db_session.add(account)
    await db_session.flush()

    result = await build_user_profile(db_session, user_id)

    assert result["goals"] == []
    assert result["interests"] == []
    assert result["health_conditions"] == []


@pytest.mark.asyncio
async def test_build_user_profile_nonexistent_user(
    db_session: AsyncSession,
):
    """Unknown user_id — should return None, not raise an exception."""
    result = await build_user_profile(db_session, uuid.uuid4())
    assert result is None


@pytest.mark.asyncio
async def test_get_user_goals(db_session: AsyncSession):
    user_id = uuid.uuid4()
    account = Account(
        id=user_id,
        email="goals@example.com",
        survey={
            "general_goals": [
                {"question": "primary_goal", "value": "beauty"},
            ],
        },
    )
    db_session.add(account)
    await db_session.flush()

    result = await get_user_goals(db_session, user_id)
    assert result == ["beauty"]


@pytest.mark.asyncio
async def test_get_user_interests(db_session: AsyncSession):
    user_id = uuid.uuid4()
    account = Account(
        id=user_id,
        email="interests@example.com",
        survey={
            "lifestyle_activity": [
                {"question": "exercise_frequency", "value": "regular"},
                {"question": "work_posture", "value": "good"},
            ],
        },
    )
    db_session.add(account)
    await db_session.flush()

    result = await get_user_interests(db_session, user_id)
    assert "regular" in result
    assert "good" in result


@pytest.mark.asyncio
async def test_get_user_health_conditions(db_session: AsyncSession):
    user_id = uuid.uuid4()
    account = Account(
        id=user_id,
        email="health@example.com",
        survey={
            "body_energy": [
                {"question": "morning_energy", "value": "tired"},
                {"question": "headache_frequency", "value": "frequent"},
            ],
        },
    )
    db_session.add(account)
    await db_session.flush()

    result = await get_user_health_conditions(db_session, user_id)
    assert "tired" in result
    assert "frequent" in result
