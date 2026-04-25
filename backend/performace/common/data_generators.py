"""
Faker-based data generators for request payloads.
Produces realistic Vietnamese test data matching the OpenAPI schema DTOs.

All generators use typed model classes from `models/` and return serialized
dicts via `.to_dict()` — guaranteeing payloads always match the OpenAPI schema.
"""

import random
import string
import uuid
from faker import Faker

from models.auth_controller import (
    AccountRequestDto,
    LegalRepresentativeRequestDto,
    PartnerDocumentVerificationDto,
    PartnerRequestDto,
    RegisterDto,
    RegisterPartnerDto,
    RegisterProfileDto,
)
from models.account_controller import SurveyDto
from models.admin_categories_controller import CreateCategoryDto
from models.admin_partners_controller import ReviewPartnerProfileDto
from models.booking_controller import AsyncCheckoutDto
from models.partner_health_service_controller import (
    CreatePartnerHealthServiceDefinitionDto,
    CreatePartnerHealthServiceDto,
)
from models.service_tags_controller import CreateServiceTagDto
from models.shared import BusinessType, HealthServiceType
from models.slots_controller import MicroLockDto

fake = Faker("vi_VN")


# ── Auth / Account ────────────────────────────────────────────────────────────

def generate_register_user():
    """RegisterDto payload."""
    return RegisterDto(
        email=f"perf_{_short_id()}@test.healytics.com",
        password="Test@12345",
        profile=RegisterProfileDto(
            firstName=fake.first_name(),
            lastName=fake.last_name(),
            phone=fake.phone_number(),
            bio=fake.sentence(nb_words=6),
            dateOfBirth=fake.date_of_birth(minimum_age=18, maximum_age=65).isoformat(),
        ),
    ).to_dict()


def generate_survey():
    """SurveyDto payload."""
    return SurveyDto(
        survey={
            "demographics": {
                "age": random.randint(18, 70),
                "gender": random.choice(["male", "female"]),
                "postalCode": fake.postcode(),
            },
            "lifestyle": {
                "smoking": random.choice([True, False]),
                "alcoholWeeklyUnits": random.randint(0, 10),
                "exercisePerWeek": random.randint(0, 7),
            },
            "conditions": [],
            "questionnaire": [
                {"questionId": "q1", "answer": random.choice(["yes", "no"])},
                {"questionId": "q2", "answer": random.choice(["yes", "no"])},
            ],
        }
    ).to_dict()


# ── Partner Registration ──────────────────────────────────────────────────────

def generate_register_partner():
    """RegisterPartnerDto payload."""
    return RegisterPartnerDto(
        account=AccountRequestDto(
            username=f"partner_{_short_id()}",
            password="Partner@123",
            email=f"partner_{_short_id()}@test.healytics.com",
        ),
        partner=PartnerRequestDto(
            taxCode=_random_digits(10),
            legalName=fake.company(),
            brandName=fake.company_suffix() + " " + fake.first_name(),
            businessType=random.sample(list(BusinessType), k=random.randint(1, 3)),
            provinceId=str(uuid.uuid4()),
            districtId=str(uuid.uuid4()),
            wardId=str(uuid.uuid4()),
            streetAddress=fake.street_address(),
            phoneNumber=fake.phone_number(),
        ),
        legalRepresentative=LegalRepresentativeRequestDto(
            fullName=fake.name().upper(),
            idType="CITIZEN_ID",
            idNumber=_random_digits(12),
            idIssueDate=fake.date_between(start_date="-5y", end_date="today").isoformat(),
            documents=[
                PartnerDocumentVerificationDto(
                    fileType="image",
                    type="BUSINESS_LICENSE",
                    documentKey=f"docs/business_license_{_short_id()}.pdf",
                    urls=[f"https://storage.example.com/bl_{_short_id()}.pdf"],
                )
            ],
            position=random.choice(["Giám đốc", "Trưởng phòng", "Phó giám đốc"]),
            phoneNumber=fake.phone_number(),
        ),
    ).to_dict()


# ── Categories ────────────────────────────────────────────────────────────────

def generate_category():
    """CreateCategoryDto payload."""
    name = fake.word().capitalize() + " " + fake.word()
    return CreateCategoryDto(
        name=name,
        slug=name.lower().replace(" ", "-") + f"-{_short_id()}",
        description=fake.sentence(nb_words=8),
    ).to_dict()


# ── Products ──────────────────────────────────────────────────────────────────

def generate_product(category_id=None):
    """CreatePartnerHealthServiceDto payload."""
    name = fake.catch_phrase()
    dto = CreatePartnerHealthServiceDto(
        name=name,
        slug=name.lower().replace(" ", "-")[:30] + f"-{_short_id()}",
        type=HealthServiceType.SERVICE,
        basePrice=round(random.uniform(100_000, 5_000_000), -3),
        productDefinition=CreatePartnerHealthServiceDefinitionDto(
            durationMinutes=float(random.choice([30, 45, 60, 90, 120])),
        ),
        description=fake.paragraph(nb_sentences=2),
        categoryId=category_id,
    )
    return dto.to_dict()


# ── Service Tags ──────────────────────────────────────────────────────────────

TAG_COLORS = [
    "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4",
    "#FFEAA7", "#DDA0DD", "#98D8C8", "#F7DC6F",
]


def generate_service_tag():
    """CreateServiceTagDto payload."""
    return CreateServiceTagDto(
        name=fake.word().capitalize() + " Tag",
        colorValue=random.choice(TAG_COLORS),
        isActive=True,
    ).to_dict()


# ── Admin ─────────────────────────────────────────────────────────────────────

def generate_review_decision():
    """ReviewPartnerProfileDto payload."""
    decision = random.choice(["APPROVED", "REJECTED", "REQUIRED_RESUBMIT"])
    return ReviewPartnerProfileDto(
        decision=decision,
        generalComment=fake.sentence(nb_words=10) if decision != "APPROVED" else None,
    ).to_dict()


# ── Booking ───────────────────────────────────────────────────────────────────

def generate_async_checkout(staff_id: str, start_time: str,
                            user_id: str, product_id: str = None):
    """AsyncCheckoutDto payload for race condition testing."""
    return AsyncCheckoutDto(
        userId=user_id,
        staffId=staff_id,
        startTime=start_time,
        productId=product_id or "",
        idempotencyKey=f"race_{_short_id(16)}",
    ).to_dict()


def generate_micro_lock(staff_id: str, start_time: str):
    """MicroLockDto payload."""
    return MicroLockDto(
        staffId=staff_id,
        startTime=start_time,
    ).to_dict()


# ── Helpers ───────────────────────────────────────────────────────────────────

def _short_id(length=8):
    return "".join(random.choices(string.ascii_lowercase + string.digits, k=length))


def _random_digits(n):
    return "".join(random.choices(string.digits, k=n))
