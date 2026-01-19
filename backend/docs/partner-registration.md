# Partner Registration & Administrative Division APIs

## Overview
This implementation adds two major features to the Healytics backend:

1. **Vietnam Administrative Division System** - Database-backed provinces, districts, and wards
2. **Partner Registration API** - Complete business partner onboarding with validation

## New Modules

### LocationsModule (`src/locations/`)
Provides APIs for Vietnam's administrative divisions using the `vn-provinces` library.

**Endpoints:**
- `GET /locations/provinces` - Get all provinces
- `GET /locations/provinces/:provinceId/districts` - Get districts in a province  
- `GET /locations/districts/:districtId/wards` - Get wards in a district

**All endpoints are PUBLIC** (no authentication required).

### PartnersModule (`src/partners/`)
Handles business partner registration with comprehensive validation.

**Endpoint:**
- `POST /partners/register` - Register a new partner (PUBLIC)

## Database Setup

### 1. Run Database Synchronization
Since you have `synchronize: true` in development, the entities will be created automatically when you start the server:

```bash
npm run start:dev
```

### 2. Seed Administrative Divisions
After the database schema is created, run the seeding script:

```bash
npm run seed:locations
```

This will populate all 63 provinces, hundreds of districts, and thousands of wards from the `vn-provinces` library.

## Partner Registration API

### Request Format

```json
{
  "account": {
    "username": "spahanoi123",
    "password": "Password123",
    "email": "contact@spahanoi.com",
    "phoneNumber": "0912345678"
  },
  "businessEntity": {
    "taxCode": "0101234567",
    "legalName": "CÔNG TY TNHH SPA HÀ NỘI",
    "brandName": "Hanoi Spa",
    "businessType": "SPA",
    "address": {
      "provinceId": 1,
      "districtId": 10,
      "wardId": 50,
      "streetAddress": "123 Đường Nguyễn Huệ"
    }
  },
  "legalRepresentative": {
    "fullName": "NGUYỄN VĂN A",
    "position": "Giám đốc",
    "idType": "CITIZEN_ID",
    "idNumber": "079090000001",
    "idIssueDate": "2020-01-01",
    "images": {
      "frontImgUrl": "https://storage.example.com/id_front.jpg",
      "backImgUrl": "https://storage.example.com/id_back.jpg"
    },
    "authorization": {
      "isAuthorizedUser": true,
      "authLetterDocUrl": null
    }
  }
}
```

### Response Format

```json
{
  "accountId": "uuid",
  "businessEntityId": "uuid",
  "status": "success",
  "message": "Partner registration successful"
}
```

### Validation

**Address Validation:**
- Validates that provinceId, districtId, and wardId exist
- Validates hierarchy (ward belongs to district, district belongs to province)

**Uniqueness Checks:**
- Email must be unique
- Tax code must be unique

**Field Validation:**
- Phone number: Vietnamese format (10 digits starting with 0)
- Password: Minimum 8 characters
- All required fields validated

### Business Types
Available values: `SPA`, `CLINIC`, `HOSPITAL`, `WELLNESS_CENTER`, `REHABILITATION_CENTER`, `MEDICAL_CENTER`, `BEAUTY_SALON`, `FITNESS_CENTER`

### ID Types  
Available values: `CITIZEN_ID`, `PASSPORT`, `MILITARY_ID`

## New Database Tables

1. **province** - Vietnamese provinces/cities (63 records)
2. **district** - Districts/Quận/Huyện (hundreds of records)
3. **ward** - Wards/Phường/Xã (thousands of records)
4. **business_entity** - Partner business information
5. **legal_representative** - Legal representative details

## Testing

### Test Locations API

```bash
# Get all provinces
curl http://localhost:3000/locations/provinces

# Get districts in Hà Nội (provinceId=1)
curl http://localhost:3000/locations/provinces/1/districts

# Get wards in a district
curl http://localhost:3000/locations/districts/1/wards
```

### Test Partner Registration

```bash
curl -X POST http://localhost:3000/partners/register \
  -H "Content-Type: application/json" \
  -d @sample-partner-data.json
```

## Important Notes

1. **Data Source**: Using `vn-provinces` npm package for accurate, up-to-date Vietnam administrative data
2. **Transaction Safety**: Partner registration uses database transactions - all entities created together or none
3. **Password Security**: Passwords are hashed with bcrypt before storage
4. **Role-Based Access**: Partner accounts get the `PARTNER` role automatically
5. **Cascade Deletion**: Deleting a province/district will cascade to children (configured in entities)

## Swagger Documentation

Access API documentation at: `http://localhost:3000/api`

Both new modules are fully documented with Swagger decorators.
