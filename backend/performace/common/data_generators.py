"""
Faker-based data generators for request payloads.
Produces realistic Vietnamese test data matching the OpenAPI schema DTOs.
"""

import random
import string
import uuid
from faker import Faker

fake = Faker("vi_VN")


# ── Auth / Account ────────────────────────────────────────────────────────────

def generate_register_user():
    """RegisterDto payload."""
    return {
        "email": f"perf_{_short_id()}@test.healytics.com",
        "password": "Test@12345",
        "profile": {
            "firstName": fake.first_name(),
            "lastName": fake.last_name(),
            "phone": fake.phone_number(),
            "bio": fake.sentence(nb_words=6),
            "dateOfBirth": fake.date_of_birth(minimum_age=18, maximum_age=65).isoformat(),
        },
    }


def generate_survey():
    """SurveyDto payload."""
    return {
        "survey": {
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
    }


# ── Partner Registration ──────────────────────────────────────────────────────

BUSINESS_TYPES = [
    "MASSAGE_THERAPY", "MASSAGE_REHABILITATION", "SPA_BEAUTY",
    "FITNESS", "PHARMACY", "DENTAL", "TRADITIONAL_MEDICINE",
    "PSYCHOLOGY", "DERMATOLOGY", "NUTRITION", "PSYCHIATRY",
]


def generate_register_partner():
    """RegisterPartnerDto payload."""
    return {
        "account": {
            "username": f"partner_{_short_id()}",
            "password": "Partner@123",
            "email": f"partner_{_short_id()}@test.healytics.com",
        },
        "partner": {
            "taxCode": _random_digits(10),
            "legalName": fake.company(),
            "brandName": fake.company_suffix() + " " + fake.first_name(),
            "businessType": random.sample(BUSINESS_TYPES, k=random.randint(1, 3)),
            "provinceId": str(uuid.uuid4()),
            "districtId": str(uuid.uuid4()),
            "wardId": str(uuid.uuid4()),
            "streetAddress": fake.street_address(),
            "phoneNumber": fake.phone_number(),
        },
        "legalRepresentative": {
            "fullName": fake.name().upper(),
            "position": random.choice(["Giám đốc", "Trưởng phòng", "Phó giám đốc"]),
            "phoneNumber": fake.phone_number(),
            "idType": "CITIZEN_ID",
            "idNumber": _random_digits(12),
            "idIssueDate": fake.date_between(start_date="-5y", end_date="today").isoformat(),
            "documents": [
                {
                    "fileType": "image",
                    "type": "BUSINESS_LICENSE",
                    "documentKey": f"docs/business_license_{_short_id()}.pdf",
                    "urls": [f"https://storage.example.com/bl_{_short_id()}.pdf"],
                }
            ],
        },
    }


# ── Categories ────────────────────────────────────────────────────────────────

def generate_category():
    """CreateCategoryDto payload."""
    name = fake.word().capitalize() + " " + fake.word()
    return {
        "name": name,
        "slug": name.lower().replace(" ", "-") + f"-{_short_id()}",
        "description": fake.sentence(nb_words=8),
    }


# ── Products ──────────────────────────────────────────────────────────────────

def generate_product(category_id=None):
    """CreateProductDto payload."""
    name = fake.catch_phrase()
    payload = {
        "name": name,
        "slug": name.lower().replace(" ", "-")[:30] + f"-{_short_id()}",
        "description": fake.paragraph(nb_sentences=2),
        "price": round(random.uniform(100_000, 5_000_000), -3),
        "duration": random.choice([30, 45, 60, 90, 120]),
    }
    if category_id:
        payload["categoryId"] = category_id
    return payload


# ── Employees ─────────────────────────────────────────────────────────────────

def generate_doctor():
    """CreateDoctorDto payload."""
    return {
        "name": fake.name(),
        "email": f"dr_{_short_id()}@test.healytics.com",
        "phone": fake.phone_number(),
        "specialization": random.choice([
            "Da liễu", "Nội khoa", "Nhi khoa", "Tim mạch", "Thần kinh",
        ]),
        "licenseNumber": f"BS-{_random_digits(6)}",
    }


def generate_therapist():
    """CreateTherapistDto payload."""
    return {
        "name": fake.name(),
        "email": f"therapist_{_short_id()}@test.healytics.com",
        "phone": fake.phone_number(),
        "specialization": random.choice([
            "Vật lý trị liệu", "Massage trị liệu", "Châm cứu", "Phục hồi chức năng",
        ]),
        "certificationNumber": f"KTV-{_random_digits(6)}",
    }


# ── Service Tags ──────────────────────────────────────────────────────────────

TAG_COLORS = [
    "#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4",
    "#FFEAA7", "#DDA0DD", "#98D8C8", "#F7DC6F",
]


def generate_service_tag():
    """CreateServiceTagDto payload."""
    return {
        "name": fake.word().capitalize() + " Tag",
        "colorValue": random.choice(TAG_COLORS),
        "isActive": True,
    }


# ── Admin ─────────────────────────────────────────────────────────────────────

def generate_review_decision():
    """ReviewPartnerProfileDto payload."""
    decision = random.choice(["APPROVED", "REJECTED", "REQUIRED_RESUBMIT"])
    return {
        "decision": decision,
        "notes": fake.sentence(nb_words=10) if decision != "APPROVED" else "",
    }


# ── Helpers ───────────────────────────────────────────────────────────────────

def _short_id(length=8):
    return "".join(random.choices(string.ascii_lowercase + string.digits, k=length))


def _random_digits(n):
    return "".join(random.choices(string.digits, k=n))
