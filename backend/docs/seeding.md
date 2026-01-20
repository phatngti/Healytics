# Database Seeding Guide

This guide explains how to seed initial data for the Healytics application, specifically for Administrative Units (Locations) and Document Requirements.

## Prerequisites

Ensure your `.env` file is correctly configured with your database credentials.

## 1. Seeding Locations (Administrative Units)

The location seeder populates the database with Vietnam's administrative units (Provinces, Districts, Wards) using a hierarchical tree structure (Closure Table pattern).

### Command
```bash
npm run seed:locations
```

### Source File
- **Script:** `seed-data/seed-locations.ts`
- **Logic:** `src/locations/seeds/location.seed.ts`

### What it does:
1.  **Connects** to the database.
2.  **Synchronizes** the schema (creating tables if they don't exist).
3.  **Populates** the `administrative_unit` table using the `vn-provinces` library.
4.  **Builds** the `administrative_unit_closure` table to support efficient tree-based queries (ancestors/descendants).

---

## 2. Seeding Document Requirements

The document requirement seeder populates the rules for which documents are required for different partner types.

### Command
```bash
npm run seed:documents
```

### Source File
- **Script:** `seed-data/seed-document-requirements.ts`
- **Logic:** `src/partners/seeds/document-requirements.seed.ts`

### What it does:
1.  **Connects** to the database.
2.  **Synchronizes** the schema.
3.  **Populates** the `document_requirement` table.
4.  **Defines** requirements mapping:
    - **Partner Type:** (e.g., PHARMACY, CLINIC, INDIVIDUAL)
    - **Document Type:** (e.g., BUSINESS_LICENSE, GPP, IDENTITY_FRONT)
    - **Required:** Boolean flag indicating if it's mandatory.

### Requirement Matrix (Common Examples)

| Partner Type | Document Type | Required |
| :--- | :--- | :--- |
| **PHARMACY** | BUSINESS_LICENSE | Yes |
| **PHARMACY** | GPP | Yes |
| **CLINIC** | BUSINESS_LICENSE | Yes |
| **CLINIC** | OPERATION_LICENSE (RHM/YHCT) | Yes |
| **INDIVIDUAL** | IDENTITY_FRONT | Yes |
| **INDIVIDUAL** | IDENTITY_BACK | Yes |
| **INDIVIDUAL** | AUTHORIZATION_LETTER | No |

## Running All Seeds

To ensure a fully populated database for development, run the seeds in the following order:

1.  `npm run seed:locations`
2.  `npm run seed:documents`
