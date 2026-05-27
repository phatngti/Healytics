#!/usr/bin/env node

/*
 * Create and remove dedicated USER accounts for performance tests.
 *
 * The create path mirrors AuthService.register() for USER accounts:
 * - reject/update only accounts in the strict perf namespace
 * - bcrypt hash the configured password with cost 10 by default
 * - insert account rows with role = user and is_active = true
 * - insert optional user_profile rows with registration-style profile data
 *
 * With --with-support-accounts it also creates one perf-only admin, partner,
 * and employee account so the all-module suite can authenticate every role.
 */

const fs = require("fs");
const path = require("path");
const bcrypt = require("bcrypt");
const dotenv = require("dotenv");
const { Client } = require("pg");

const SCRIPT_DIR = __dirname;
const PERF_ROOT = path.resolve(SCRIPT_DIR, "..");
const BACKEND_ROOT = path.resolve(PERF_ROOT, "..");
const PERF_ENV_FILE = path.join(PERF_ROOT, ".env");
const BACKEND_ENV_FILE = path.join(BACKEND_ROOT, ".env");
const DEFAULT_ENV_FILE = fs.existsSync(PERF_ENV_FILE) ? PERF_ENV_FILE : BACKEND_ENV_FILE;
const REPORTS_DIR = path.join(PERF_ROOT, "reports");
const DEFAULT_POOL_FILE = path.join(REPORTS_DIR, "perf_user_pool.json");
const DEFAULT_ENV_OUTPUT_FILE = path.join(REPORTS_DIR, "perf_user_pool.env");
const DEFAULT_CSV_OUTPUT_FILE = path.join(REPORTS_DIR, "perf_user_pool.csv");

const DEFAULT_COUNT = 1200;
const DEFAULT_EMAIL_PREFIX = "perfload-user-";
const DEFAULT_EMAIL_DOMAIN = "perf.healytics.vn";
const DEFAULT_PASSWORD = "Perf@12345";
const DEFAULT_BCRYPT_ROUNDS = 10;
const DEFAULT_BATCH_SIZE = 100;
const DEFAULT_SUPPORT_DOMAIN = "perf.healytics.vn";
const DEFAULT_ADMIN_EMAIL = `perfload-admin@${DEFAULT_SUPPORT_DOMAIN}`;
const DEFAULT_ADMIN_PASSWORD = "PerfAdmin@12345";
const DEFAULT_PARTNER_EMAIL = `perfload-partner@${DEFAULT_SUPPORT_DOMAIN}`;
const DEFAULT_PARTNER_PASSWORD = "PerfPartner@12345";
const DEFAULT_EMPLOYEE_EMAIL = `perfload-employee@${DEFAULT_SUPPORT_DOMAIN}`;
const DEFAULT_EMPLOYEE_PASSWORD = "PerfEmployee@12345";
const DEFAULT_PARTNER_TAX_CODE = "PERF00000001";
const DEFAULT_EMPLOYEE_CODE = "PERF-EMP-0001";
const DEFAULT_RACE_PRODUCT_SLUG = "perf-booking-race-service";
const DEFAULT_RACE_PRODUCT_NAME = "Performance Booking Race Service";
const DEFAULT_RACE_PRODUCT_PRICE = 100000;
const DEFAULT_CHAT_SEED_MESSAGE = "Performance chat seed conversation";
const DEFAULT_PARTNER_DESCRIPTION =
  "Dedicated partner profile for Healytics performance testing. This description is intentionally long enough to satisfy the public-profile completion gate while remaining clearly scoped to load-test data.";
const DEFAULT_PARTNER_GALLERY = [
  "https://example.com/perf-gallery-1.jpg",
  "https://example.com/perf-gallery-2.jpg",
  "https://example.com/perf-gallery-3.jpg",
];

main().catch((error) => {
  console.error(`ERROR: ${error.message}`);
  process.exit(1);
});

async function main() {
  const { command, options } = parseArgs(process.argv.slice(2));

  if (options.help || command === "help") {
    printHelp();
    return;
  }

  loadEnv(options.envFile || DEFAULT_ENV_FILE, Boolean(options.envFile));

  const settings = buildSettings(options);
  validateSettings(command, settings);

  const client = new Client({
    host: process.env.POSTGRES_HOST || "localhost",
    port: Number(process.env.POSTGRES_PORT || 5432),
    user: process.env.POSTGRES_USER,
    password: process.env.POSTGRES_PASSWORD,
    database: process.env.POSTGRES_DB,
  });

  await client.connect();
  try {
    if (command === "create") {
      await createPerfAccounts(client, settings);
    } else if (command === "cleanup" || command === "delete") {
      await cleanupPerfAccounts(client, settings);
    } else if (command === "reset") {
      await cleanupPerfAccounts(client, settings);
      await createPerfAccounts(client, settings);
    } else if (command === "status") {
      await printStatus(client, settings);
    } else {
      throw new Error(`Unknown command "${command}". Use --help for usage.`);
    }
  } finally {
    await client.end();
  }
}

function parseArgs(argv) {
  const first = argv[0];
  const command = !first || first.startsWith("--") ? "help" : first;
  const rest = !first || first.startsWith("--") ? argv : argv.slice(1);
  const options = {};

  for (let index = 0; index < rest.length; index += 1) {
    const arg = rest[index];
    if (arg === "--help" || arg === "-h") {
      options.help = true;
      continue;
    }
    if (!arg.startsWith("--")) {
      throw new Error(`Unexpected argument "${arg}"`);
    }

    const [rawKey, inlineValue] = arg.slice(2).split("=", 2);
    const key = toCamelCase(rawKey);
    if (inlineValue !== undefined) {
      options[key] = inlineValue;
      continue;
    }

    const next = rest[index + 1];
    if (next === undefined || next.startsWith("--")) {
      options[key] = true;
      continue;
    }
    options[key] = next;
    index += 1;
  }

  return { command, options };
}

function toCamelCase(value) {
  return value.replace(/-([a-z])/g, (_, char) => char.toUpperCase());
}

function loadEnv(envFile, override = false) {
  if (envFile && fs.existsSync(envFile)) {
    dotenv.config({ path: envFile, quiet: true, override });
  }
}

function buildSettings(options) {
  const count = Number(options.count || process.env.PERF_ACCOUNT_COUNT || DEFAULT_COUNT);
  const emailPrefix =
    String(options.emailPrefix || process.env.PERF_ACCOUNT_EMAIL_PREFIX || DEFAULT_EMAIL_PREFIX);
  const emailDomain =
    String(options.emailDomain || process.env.PERF_ACCOUNT_EMAIL_DOMAIN || DEFAULT_EMAIL_DOMAIN);
  const password = String(options.password || process.env.PERF_ACCOUNT_PASSWORD || DEFAULT_PASSWORD);
  const bcryptRounds = Number(
    options.bcryptRounds || process.env.PERF_ACCOUNT_BCRYPT_ROUNDS || DEFAULT_BCRYPT_ROUNDS,
  );
  const batchSize = Number(options.batchSize || DEFAULT_BATCH_SIZE);
  const poolFile = path.resolve(options.poolFile || process.env.PERF_USER_POOL_FILE || DEFAULT_POOL_FILE);
  const envOutputFile = path.resolve(options.envOutputFile || DEFAULT_ENV_OUTPUT_FILE);
  const csvOutputFile = path.resolve(options.csvFile || DEFAULT_CSV_OUTPUT_FILE);
  const withSupportAccounts = booleanOption(
    options.withSupportAccounts,
    process.env.PERF_WITH_SUPPORT_ACCOUNTS,
  );
  const adminEmail = String(options.adminEmail || process.env.PERF_ADMIN_EMAIL || DEFAULT_ADMIN_EMAIL);
  const adminPassword = String(options.adminPassword || process.env.PERF_ADMIN_PASSWORD || DEFAULT_ADMIN_PASSWORD);
  const partnerEmail = String(options.partnerEmail || process.env.PERF_PARTNER_EMAIL || DEFAULT_PARTNER_EMAIL);
  const partnerPassword = String(
    options.partnerPassword || process.env.PERF_PARTNER_PASSWORD || DEFAULT_PARTNER_PASSWORD,
  );
  const employeeEmail = String(
    options.employeeEmail || process.env.PERF_EMPLOYEE_EMAIL || DEFAULT_EMPLOYEE_EMAIL,
  );
  const employeePassword = String(
    options.employeePassword || process.env.PERF_EMPLOYEE_PASSWORD || DEFAULT_EMPLOYEE_PASSWORD,
  );
  const raceProductSlug = String(
    options.raceProductSlug || process.env.PERF_RACE_PRODUCT_SLUG || DEFAULT_RACE_PRODUCT_SLUG,
  );
  const raceProductName = String(
    options.raceProductName || process.env.PERF_RACE_PRODUCT_NAME || DEFAULT_RACE_PRODUCT_NAME,
  );
  const raceProductPrice = Number(
    options.raceProductPrice || process.env.PERF_RACE_PRODUCT_PRICE || DEFAULT_RACE_PRODUCT_PRICE,
  );

  return {
    count,
    emailPrefix,
    emailDomain,
    password,
    bcryptRounds,
    batchSize,
    poolFile,
    envOutputFile,
    csvOutputFile,
    withSupportAccounts,
    adminEmail,
    adminPassword,
    partnerEmail,
    partnerPassword,
    employeeEmail,
    employeePassword,
    raceProductSlug,
    raceProductName,
    raceProductPrice,
    emailLikePattern: `${emailPrefix}%@${emailDomain}`,
  };
}

function booleanOption(optionValue, envValue) {
  const raw = optionValue === undefined ? envValue : optionValue;
  if (raw === true) {
    return true;
  }
  if (raw === undefined) {
    return false;
  }
  return ["1", "true", "yes", "on"].includes(String(raw).trim().toLowerCase());
}

function validateSettings(command, settings) {
  if (!process.env.POSTGRES_USER || !process.env.POSTGRES_PASSWORD || !process.env.POSTGRES_DB) {
    throw new Error(
      "POSTGRES_USER, POSTGRES_PASSWORD, and POSTGRES_DB must be set in backend/.env or the environment",
    );
  }

  if (!/^[a-zA-Z0-9.-]+$/.test(settings.emailDomain)) {
    throw new Error("Email domain may contain only letters, numbers, dots, and dashes");
  }

  if (!/^[a-zA-Z0-9.-]+-$/.test(settings.emailPrefix)) {
    throw new Error("Email prefix must contain only letters, numbers, dots, dashes, and end with '-'");
  }

  if (settings.password.length < 8) {
    throw new Error("Password must be at least 8 characters, matching RegisterDto validation");
  }

  if (!Number.isInteger(settings.bcryptRounds) || settings.bcryptRounds < 4) {
    throw new Error("bcrypt rounds must be an integer >= 4");
  }

  if (!Number.isInteger(settings.batchSize) || settings.batchSize < 1) {
    throw new Error("batch size must be an integer >= 1");
  }

  if ((command === "create" || command === "reset") && (!Number.isInteger(settings.count) || settings.count <= 1000)) {
    throw new Error("count must be greater than 1000 for performance-test account creation");
  }

  if (settings.withSupportAccounts) {
    for (const [name, value] of [
      ["admin password", settings.adminPassword],
      ["partner password", settings.partnerPassword],
      ["employee password", settings.employeePassword],
    ]) {
      if (value.length < 8) {
        throw new Error(`${name} must be at least 8 characters`);
      }
    }
  }

  if (!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(settings.raceProductSlug)) {
    throw new Error("race product slug must be lowercase kebab-case");
  }

  if (!Number.isFinite(settings.raceProductPrice) || settings.raceProductPrice <= 0) {
    throw new Error("race product price must be a positive number");
  }
}

async function createPerfAccounts(client, settings) {
  fs.mkdirSync(REPORTS_DIR, { recursive: true });

  console.log(`Creating ${settings.count} perf USER accounts`);
  console.log(`Email namespace: ${settings.emailPrefix}NNNNNN@${settings.emailDomain}`);

  const users = buildUsers(settings);
  await assertNoNonPerfConflicts(client, settings, users);

  // Query existing perf accounts so we can skip them
  const existingEmails = await fetchExistingPerfEmails(client, settings);
  const newUsers = users.filter((user) => !existingEmails.has(user.email));

  console.log(`Found ${existingEmails.size} existing account(s) — skipping`);
  console.log(`Will create ${newUsers.length} new account(s)`);

  if (newUsers.length > 0) {
    await client.query("BEGIN");
    try {
      for (let start = 0; start < newUsers.length; start += settings.batchSize) {
        const batch = newUsers.slice(start, start + settings.batchSize);
        const accounts = [];

        for (const user of batch) {
          accounts.push({
            ...user,
            passwordHash: await bcrypt.hash(settings.password, settings.bcryptRounds),
          });
        }

        const insertedAccounts = await insertAccountBatch(client, accounts);
        await insertProfileBatch(client, insertedAccounts, batch);

        const done = Math.min(start + batch.length, newUsers.length);
        process.stdout.write(`\rCreated ${done}/${newUsers.length}`);
      }

      await client.query("COMMIT");
      process.stdout.write("\n");
    } catch (error) {
      await client.query("ROLLBACK");
      throw error;
    }
  } else {
    console.log("All accounts already exist — nothing to insert");
  }

  let supportSeed = null;
  if (settings.withSupportAccounts) {
    supportSeed = await createSupportAccounts(client, settings, users[0].email);
  }

  // Write pool files for ALL users (existing + new) so test runners have the full list
  writePoolFiles(settings, users, supportSeed);
  console.log(`Pool file: ${settings.poolFile}`);
  console.log(`CSV file:  ${settings.csvOutputFile}`);
  console.log(`Env file:  ${settings.envOutputFile}`);
}

function buildUsers(settings) {
  return Array.from({ length: settings.count }, (_, index) => {
    const ordinal = index + 1;
    const padded = String(ordinal).padStart(6, "0");
    return {
      email: `${settings.emailPrefix}${padded}@${settings.emailDomain}`,
      password: settings.password,
      firstName: "Perf",
      lastName: `User ${padded}`,
      phone: `0908${padded}`,
      bio: "Dedicated account for Healytics performance testing.",
      dateOfBirth: dateOfBirthForIndex(index),
    };
  });
}

function dateOfBirthForIndex(index) {
  const year = 1970 + (index % 30);
  const month = String((index % 12) + 1).padStart(2, "0");
  const day = String((index % 28) + 1).padStart(2, "0");
  return `${year}-${month}-${day}`;
}

async function assertNoNonPerfConflicts(client, settings, users) {
  const result = await client.query(
    `
      SELECT email
      FROM account
      WHERE email = ANY($1)
        AND (role <> 'user' OR email NOT LIKE $2)
      LIMIT 5
    `,
    [users.map((user) => user.email), settings.emailLikePattern],
  );

  if (result.rowCount > 0) {
    throw new Error(
      `Refusing to overwrite non-perf accounts: ${result.rows.map((row) => row.email).join(", ")}`,
    );
  }
}

async function fetchExistingPerfEmails(client, settings) {
  const result = await client.query(
    `
      SELECT email
      FROM account
      WHERE role = 'user'
        AND email LIKE $1
    `,
    [settings.emailLikePattern],
  );

  return new Set(result.rows.map((row) => row.email));
}

async function insertAccountBatch(client, accounts) {
  const values = [];
  const params = [];

  accounts.forEach((account, index) => {
    const base = index * 2;
    values.push(`($${base + 1}, $${base + 2}, 'user', true, NOW(), NOW())`);
    params.push(account.email, account.passwordHash);
  });

  const result = await client.query(
    `
      INSERT INTO account (email, password_hash, role, is_active, created_at, updated_at)
      VALUES ${values.join(", ")}
      RETURNING id, email
    `,
    params,
  );

  const accountByEmail = new Map(result.rows.map((row) => [row.email, row.id]));
  return accounts.map((account) => ({
    ...account,
    accountId: accountByEmail.get(account.email),
  }));
}

async function insertProfileBatch(client, insertedAccounts, sourceUsers) {
  const sourceByEmail = new Map(sourceUsers.map((user) => [user.email, user]));
  const values = [];
  const params = [];

  insertedAccounts.forEach((account, index) => {
    const source = sourceByEmail.get(account.email);
    const base = index * 6;
    values.push(
      `($${base + 1}, $${base + 2}, $${base + 3}, $${base + 4}, $${base + 5}, $${base + 6}, NOW(), NOW())`,
    );
    params.push(
      source.firstName,
      source.lastName,
      source.phone,
      source.bio,
      source.dateOfBirth,
      account.accountId,
    );
  });

  await client.query(
    `
      INSERT INTO user_profile (
        first_name,
        last_name,
        phone,
        bio,
        date_of_birth,
        account_id,
        created_at,
        updated_at
      )
      VALUES ${values.join(", ")}
    `,
    params,
  );
}

async function createSupportAccounts(client, settings, primaryUserEmail) {
  console.log("Creating support admin/partner/employee perf accounts");

  await client.query("BEGIN");
  try {
    const primaryUserAccount = await fetchAccountByEmail(client, primaryUserEmail);
    if (!primaryUserAccount || primaryUserAccount.role !== "user") {
      throw new Error(`Primary perf user account ${primaryUserEmail} is missing or is not a USER account`);
    }

    const admin = await createRoleAccount(
      client,
      settings.adminEmail,
      settings.adminPassword,
      "admin",
      settings.bcryptRounds,
    );
    const partnerAccount = await createRoleAccount(
      client,
      settings.partnerEmail,
      settings.partnerPassword,
      "health_partner",
      settings.bcryptRounds,
    );
    const employeeAccount = await createRoleAccount(
      client,
      settings.employeeEmail,
      settings.employeePassword,
      "employee",
      settings.bcryptRounds,
    );

    const partnerId = await ensurePartnerProfile(client, partnerAccount.id);
    const employeeId = await ensureEmployeeProfile(client, employeeAccount.id, partnerId, settings.employeeEmail);
    const raceSeed = await ensureRaceBookingSeed(client, partnerId, employeeId, settings);
    const chatSeed = await ensureChatSeed(client, primaryUserAccount.id, partnerAccount.id);

    await client.query("COMMIT");
    console.log(
      `Support accounts ready: admin=${admin.email}, partner=${partnerAccount.email}, employee=${employeeAccount.email}`,
    );
    console.log(`Race seed ready: employee=${employeeId}, product=${raceSeed.productId}`);
    console.log(`Chat seed ready: conversation=${chatSeed.conversationId}`);
    return {
      partnerId,
      employeeId,
      chatConversationId: chatSeed.conversationId,
      chatUserId: primaryUserAccount.id,
      chatPartnerAccountId: partnerAccount.id,
      raceProductId: raceSeed.productId,
      raceProductSlug: settings.raceProductSlug,
    };
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  }
}

async function fetchAccountByEmail(client, email) {
  const result = await client.query(
    "SELECT id, email, role FROM account WHERE email = $1",
    [email],
  );
  return result.rows[0] || null;
}

async function createRoleAccount(client, email, password, role, bcryptRounds) {
  const existing = await client.query(
    "SELECT id, email, role FROM account WHERE email = $1",
    [email],
  );
  if (existing.rowCount > 0) {
    const account = existing.rows[0];
    if (account.role !== role) {
      throw new Error(`Support account ${email} already exists with role ${account.role}, expected ${role}`);
    }
    return account;
  }

  const passwordHash = await bcrypt.hash(password, bcryptRounds);
  const inserted = await client.query(
    `
      INSERT INTO account (email, password_hash, role, is_active, created_at, updated_at)
      VALUES ($1, $2, $3::account_role_enum, true, NOW(), NOW())
      RETURNING id, email, role
    `,
    [email, passwordHash, role],
  );
  return inserted.rows[0];
}

async function ensurePartnerProfile(client, accountId) {
  const existing = await client.query(
    "SELECT id FROM health_partner_profile WHERE account_id = $1",
    [accountId],
  );
  if (existing.rowCount > 0) {
    await client.query(
      `
        UPDATE health_partner_profile
        SET
          tax_code = $2,
          legal_name = 'Healytics Performance Partner LLC',
          brand_name = 'Healytics Perf Partner',
          business_type = 'SPA_BEAUTY',
          street_address = 'Performance Test Street',
          phone_number = '0908000000',
          verification_status = 'APPROVED',
          verification_completed_at = COALESCE(verification_completed_at, NOW()),
          cover_image_url = 'https://example.com/perf-cover.jpg',
          logo_image_url = 'https://example.com/perf-logo.jpg',
          gallery = $3::jsonb,
          description = $4,
          updated_at = NOW()
        WHERE id = $1
      `,
      [
        existing.rows[0].id,
        DEFAULT_PARTNER_TAX_CODE,
        JSON.stringify(DEFAULT_PARTNER_GALLERY),
        DEFAULT_PARTNER_DESCRIPTION,
      ],
    );
    return existing.rows[0].id;
  }

  const inserted = await client.query(
    `
      INSERT INTO health_partner_profile (
        tax_code,
        legal_name,
        brand_name,
        business_type,
        street_address,
        phone_number,
        account_id,
        verification_status,
        verification_completed_at,
        cover_image_url,
        logo_image_url,
        gallery,
        description,
        follower_count,
        created_at,
        updated_at
      )
      VALUES (
        $1,
        'Healytics Performance Partner LLC',
        'Healytics Perf Partner',
        'SPA_BEAUTY',
        'Performance Test Street',
        '0908000000',
        $2,
        'APPROVED',
        NOW(),
        'https://example.com/perf-cover.jpg',
        'https://example.com/perf-logo.jpg',
        $3::jsonb,
        $4,
        0,
        NOW(),
        NOW()
      )
      RETURNING id
    `,
    [
      DEFAULT_PARTNER_TAX_CODE,
      accountId,
      JSON.stringify(DEFAULT_PARTNER_GALLERY),
      DEFAULT_PARTNER_DESCRIPTION,
    ],
  );
  return inserted.rows[0].id;
}

async function ensureEmployeeProfile(client, accountId, partnerId, email) {
  const existing = await client.query(
    "SELECT id FROM employees WHERE account_id = $1",
    [accountId],
  );
  if (existing.rowCount > 0) {
    await client.query(
      `
        UPDATE employees
        SET
          partner_id = $2,
          status = 'ACTIVE',
          role = 'THERAPIST',
          schedule = $3::jsonb,
          updated_at = NOW()
        WHERE id = $1
      `,
      [existing.rows[0].id, partnerId, JSON.stringify(perfRaceSchedule())],
    );
    return existing.rows[0].id;
  }

  const inserted = await client.query(
    `
      INSERT INTO employees (
        employee_code,
        first_name,
        last_name,
        full_name,
        email,
        phone,
        job_title,
        role,
        status,
        rating,
        review_count,
        schedule,
        partner_id,
        account_id,
        created_at,
        updated_at
      )
      VALUES (
        $1,
        'Perf',
        'Employee',
        'Perf Employee',
        $2,
        '0908000001',
        'Performance Test Employee',
        'THERAPIST',
        'ACTIVE',
        0,
        0,
        $3::jsonb,
        $4,
        $5,
        NOW(),
        NOW()
      )
      RETURNING id
    `,
    [DEFAULT_EMPLOYEE_CODE, email, JSON.stringify(perfRaceSchedule()), partnerId, accountId],
  );
  return inserted.rows[0].id;
}

async function ensureRaceBookingSeed(client, partnerId, employeeId, settings) {
  const serviceManual = {
    preServiceGuidelines: ["Arrive 10 minutes before the appointment."],
    serviceRules: [
      {
        iconSlug: "timer",
        title: "Performance-only service",
        description: "Dedicated catalog row for booking race-condition load tests.",
      },
    ],
    procedureSteps: [
      {
        stepNumber: 1,
        title: "Booking race validation",
        description: "Used to validate concurrent booking lock behavior.",
      },
    ],
  };

  const existing = await client.query(
    `
      SELECT id
      FROM products
      WHERE partner_id = $1
        AND slug = $2
      LIMIT 1
    `,
    [partnerId, settings.raceProductSlug],
  );

  let productId;
  if (existing.rowCount > 0) {
    productId = existing.rows[0].id;
    await client.query(
      `
        UPDATE products
        SET
          name = $2,
          description = $3,
          type = 'service',
          base_price = $4,
          sale_price = NULL,
          currency = 'VND',
          status = 'active',
          is_visible_online = true,
          service_manual = $5::jsonb,
          vendor_name = 'Healytics Performance',
          deleted_at = NULL,
          updated_at = NOW()
        WHERE id = $1
      `,
      [
        productId,
        settings.raceProductName,
        "Dedicated service product for Healytics performance booking race tests.",
        settings.raceProductPrice,
        JSON.stringify(serviceManual),
      ],
    );
  } else {
    const inserted = await client.query(
      `
        INSERT INTO products (
          partner_id,
          category_id,
          name,
          slug,
          description,
          type,
          base_price,
          sale_price,
          currency,
          status,
          is_visible_online,
          service_manual,
          vendor_name,
          created_at,
          updated_at
        )
        VALUES (
          $1,
          NULL,
          $2,
          $3,
          'Dedicated service product for Healytics performance booking race tests.',
          'service',
          $4,
          NULL,
          'VND',
          'active',
          true,
          $5::jsonb,
          'Healytics Performance',
          NOW(),
          NOW()
        )
        RETURNING id
      `,
      [
        partnerId,
        settings.raceProductName,
        settings.raceProductSlug,
        settings.raceProductPrice,
        JSON.stringify(serviceManual),
      ],
    );
    productId = inserted.rows[0].id;
  }

  await client.query(
    `
      INSERT INTO product_definitions (
        product_id,
        duration_minutes,
        buffer_minutes,
        max_capacity,
        min_lead_time_hours,
        staff_assignment_type
      )
      VALUES ($1, 30, 0, 1, 0, 'specific')
      ON CONFLICT (product_id) DO UPDATE
      SET
        duration_minutes = EXCLUDED.duration_minutes,
        buffer_minutes = EXCLUDED.buffer_minutes,
        max_capacity = EXCLUDED.max_capacity,
        min_lead_time_hours = EXCLUDED.min_lead_time_hours,
        staff_assignment_type = EXCLUDED.staff_assignment_type
    `,
    [productId],
  );

  await client.query(
    `
      INSERT INTO product_employee_eligibility (
        product_id,
        employee_id,
        is_primary
      )
      VALUES ($1, $2, true)
      ON CONFLICT (product_id, employee_id) DO UPDATE
      SET is_primary = true
    `,
    [productId, employeeId],
  );

  return { productId };
}

async function ensureChatSeed(client, userAccountId, partnerAccountId) {
  const inserted = await client.query(
    `
      INSERT INTO partner_conversations (
        user_id,
        partner_account_id,
        booking_id,
        status,
        user_unread_count,
        partner_unread_count,
        deleted_at,
        created_at,
        updated_at
      )
      VALUES ($1, $2, NULL, 'active', 0, 0, NULL, NOW(), NOW())
      ON CONFLICT (user_id, partner_account_id) DO UPDATE
      SET
        status = 'active',
        booking_id = NULL,
        user_unread_count = 0,
        partner_unread_count = 0,
        deleted_at = NULL,
        updated_at = NOW()
      RETURNING id
    `,
    [userAccountId, partnerAccountId],
  );
  const conversationId = inserted.rows[0].id;

  const seedMessage = await client.query(
    `
      SELECT id, created_at
      FROM partner_chat_messages
      WHERE conversation_id = $1
        AND client_message_id = 'perf-chat-seed-message'
      LIMIT 1
    `,
    [conversationId],
  );

  let seedMessageId = seedMessage.rows[0]?.id;
  let seedMessageCreatedAt = seedMessage.rows[0]?.created_at;
  if (!seedMessageId) {
    const message = await client.query(
      `
        INSERT INTO partner_chat_messages (
          conversation_id,
          sender_id,
          content,
          message_type,
          client_message_id,
          created_at
        )
        VALUES ($1, $2, $3, 'text', 'perf-chat-seed-message', NOW())
        RETURNING id, created_at
      `,
      [conversationId, userAccountId, DEFAULT_CHAT_SEED_MESSAGE],
    );
    seedMessageId = message.rows[0].id;
    seedMessageCreatedAt = message.rows[0].created_at;
  }

  await client.query(
    `
      UPDATE partner_conversations
      SET
        last_message_text = $2,
        last_message_at = $3,
        last_message_sender_id = $4,
        user_unread_count = 0,
        partner_unread_count = 0,
        updated_at = NOW()
      WHERE id = $1
    `,
    [conversationId, DEFAULT_CHAT_SEED_MESSAGE, seedMessageCreatedAt, userAccountId],
  );

  return { conversationId, seedMessageId };
}

function perfRaceSchedule() {
  return [
    { day: "Monday", start: "08:00", end: "20:00", isWorking: true },
    { day: "Tuesday", start: "08:00", end: "20:00", isWorking: true },
    { day: "Wednesday", start: "08:00", end: "20:00", isWorking: true },
    { day: "Thursday", start: "08:00", end: "20:00", isWorking: true },
    { day: "Friday", start: "08:00", end: "20:00", isWorking: true },
    { day: "Saturday", start: "08:00", end: "20:00", isWorking: true },
    { day: "Sunday", start: "08:00", end: "20:00", isWorking: true },
  ];
}

async function cleanupPerfAccounts(client, settings) {
  await client.query("BEGIN");
  try {
    await cleanupPerfChatSeed(client, settings);
    await cleanupRaceBookingSeed(client, settings);
    const deleted = await deleteExistingPerfAccounts(client, settings);
    await client.query("COMMIT");
    removeGeneratedFiles(settings);
    console.log(`Deleted ${deleted} perf account(s)`);
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  }
}

async function cleanupPerfChatSeed(client, settings) {
  const conversations = await client.query(
    `
      SELECT DISTINCT c.id
      FROM partner_conversations c
      LEFT JOIN account user_account ON user_account.id = c.user_id
      LEFT JOIN account partner_account ON partner_account.id = c.partner_account_id
      WHERE (user_account.role = 'user' AND user_account.email LIKE $1)
         OR partner_account.email = $2
         OR c.id IN (
           SELECT conversation_id
           FROM partner_chat_messages
           WHERE client_message_id = 'perf-chat-seed-message'
         )
    `,
    [settings.emailLikePattern, settings.partnerEmail],
  );
  const conversationIds = conversations.rows.map((row) => row.id);
  if (conversationIds.length === 0) {
    return 0;
  }

  await client.query(
    `
      DELETE FROM partner_chat_attachments
      WHERE message_id IN (
        SELECT id
        FROM partner_chat_messages
        WHERE conversation_id = ANY($1::uuid[])
      )
    `,
    [conversationIds],
  );
  await client.query("DELETE FROM partner_chat_messages WHERE conversation_id = ANY($1::uuid[])", [
    conversationIds,
  ]);
  const deleted = await client.query("DELETE FROM partner_conversations WHERE id = ANY($1::uuid[])", [
    conversationIds,
  ]);
  console.log(`Deleted ${deleted.rowCount} perf chat conversation seed row(s)`);
  return deleted.rowCount;
}

async function cleanupRaceBookingSeed(client, settings) {
  const products = await client.query(
    `
      SELECT id
      FROM products
      WHERE slug = $1
         OR slug LIKE $2
    `,
    [settings.raceProductSlug, "perf-booking-race-%"],
  );
  const productIds = products.rows.map((row) => row.id);
  if (productIds.length === 0) {
    return 0;
  }

  await client.query("UPDATE checkout_tickets SET product_id = NULL WHERE product_id = ANY($1::uuid[])", [
    productIds,
  ]);
  await client.query("UPDATE bookings SET product_id = NULL WHERE product_id = ANY($1::uuid[])", [productIds]);
  await deleteDirectReferences(client, "products", "id", productIds);
  const deleted = await client.query("DELETE FROM products WHERE id = ANY($1::uuid[])", [productIds]);
  console.log(`Deleted ${deleted.rowCount} perf race product seed row(s)`);
  return deleted.rowCount;
}

async function deleteExistingPerfAccounts(client, settings) {
  const supportEmails = supportAccountEmails(settings);
  const accountRows = await client.query(
    `
      SELECT id
      FROM account
      WHERE (role = 'user' AND email LIKE $1)
         OR email = ANY($2)
    `,
    [settings.emailLikePattern, supportEmails],
  );

  const accountIds = accountRows.rows.map((row) => row.id);
  if (accountIds.length === 0) {
    return 0;
  }

  await deleteDirectAccountReferences(client, accountIds);
  await client.query("DELETE FROM user_profile WHERE account_id = ANY($1::uuid[])", [accountIds]);
  const deleted = await client.query("DELETE FROM account WHERE id = ANY($1::uuid[])", [accountIds]);
  return deleted.rowCount;
}

function supportAccountEmails(settings) {
  return [settings.adminEmail, settings.partnerEmail, settings.employeeEmail];
}

async function deleteDirectAccountReferences(client, accountIds) {
  await deleteDirectReferences(client, "account", "id", accountIds, ["user_profile"]);
}

async function deleteDirectReferences(client, targetTable, targetColumn, ids, excludedTables = []) {
  if (!ids.length) {
    return;
  }
  const references = await client.query(
    `
      SELECT
        tc.table_schema,
        tc.table_name,
        kcu.column_name
      FROM information_schema.table_constraints tc
      JOIN information_schema.key_column_usage kcu
        ON tc.constraint_name = kcu.constraint_name
       AND tc.table_schema = kcu.table_schema
      JOIN information_schema.constraint_column_usage ccu
        ON ccu.constraint_name = tc.constraint_name
       AND ccu.table_schema = tc.table_schema
      WHERE tc.constraint_type = 'FOREIGN KEY'
        AND ccu.table_schema = 'public'
        AND ccu.table_name = $1
        AND ccu.column_name = $2
        AND tc.table_schema = 'public'
        AND tc.table_name <> ALL($3::text[])
    `,
    [targetTable, targetColumn, excludedTables],
  );

  for (const row of references.rows) {
    const tableName = quoteIdentifier(row.table_schema, row.table_name);
    const columnName = quoteIdentifier(row.column_name);
    await client.query(`DELETE FROM ${tableName} WHERE ${columnName} = ANY($1::uuid[])`, [ids]);
  }
}

function quoteIdentifier(...parts) {
  return parts
    .map((part) => `"${String(part).replace(/"/g, '""')}"`)
    .join(".");
}

function writePoolFiles(settings, users, supportSeed = null) {
  const payload = {
    generatedAt: new Date().toISOString(),
    count: users.length,
    emailPrefix: settings.emailPrefix,
    emailDomain: settings.emailDomain,
    users: users.map(({ email, password }) => ({ email, password })),
  };

  fs.writeFileSync(settings.poolFile, `${JSON.stringify(payload, null, 2)}\n`);
  fs.chmodSync(settings.poolFile, 0o600);

  // CSV file for easy inspection / spreadsheet import
  writePoolCsvFile(settings.csvOutputFile, users);

  const first = users[0];
  const envLines = [
    `PERF_USER_POOL_FILE=${settings.poolFile}`,
    `TEST_USER_EMAIL=${first.email}`,
    `TEST_USER_PASSWORD=${first.password}`,
  ];
  if (settings.withSupportAccounts) {
    envLines.push(
      `TEST_ADMIN_EMAIL=${settings.adminEmail}`,
      `TEST_ADMIN_PASSWORD=${settings.adminPassword}`,
      `TEST_PARTNER_EMAIL=${settings.partnerEmail}`,
      `TEST_PARTNER_PASSWORD=${settings.partnerPassword}`,
      `TEST_EMPLOYEE_EMAIL=${settings.employeeEmail}`,
      `TEST_EMPLOYEE_PASSWORD=${settings.employeePassword}`,
    );
  }
  if (supportSeed) {
    envLines.push(
      `PERF_CHAT_CONVERSATION_ID=${supportSeed.chatConversationId}`,
      `PERF_CHAT_USER_ID=${supportSeed.chatUserId}`,
      `PERF_CHAT_PARTNER_ACCOUNT_ID=${supportSeed.chatPartnerAccountId}`,
      `WS_CONVERSATION_ID=${supportSeed.chatConversationId}`,
      `WS_USER_CHAT_RECEIVER_ID=${supportSeed.chatPartnerAccountId}`,
      `WS_PARTNER_CHAT_RECEIVER_ID=${supportSeed.chatUserId}`,
      `PERF_RACE_PARTNER_ID=${supportSeed.partnerId}`,
      `PERF_RACE_EMPLOYEE_ID=${supportSeed.employeeId}`,
      `PERF_RACE_PRODUCT_ID=${supportSeed.raceProductId}`,
      `PERF_RACE_PRODUCT_SLUG=${supportSeed.raceProductSlug}`,
    );
  }
  const envBody = [...envLines, ""].join("\n");
  fs.writeFileSync(settings.envOutputFile, envBody);
  fs.chmodSync(settings.envOutputFile, 0o600);
}

function writePoolCsvFile(csvPath, users) {
  const header = "email,password,first_name,last_name,phone,date_of_birth";
  const rows = users.map((user) =>
    [
      csvEscape(user.email),
      csvEscape(user.password),
      csvEscape(user.firstName),
      csvEscape(user.lastName),
      csvEscape(user.phone),
      csvEscape(user.dateOfBirth),
    ].join(","),
  );

  fs.writeFileSync(csvPath, [header, ...rows, ""].join("\n"));
  fs.chmodSync(csvPath, 0o600);
}

function csvEscape(value) {
  const str = String(value);
  if (str.includes(",") || str.includes('"') || str.includes("\n")) {
    return `"${str.replace(/"/g, '""')}"`;
  }
  return str;
}

function removeGeneratedFiles(settings) {
  for (const filePath of [settings.poolFile, settings.envOutputFile, settings.csvOutputFile]) {
    if (fs.existsSync(filePath)) {
      fs.rmSync(filePath);
    }
  }
}

async function printStatus(client, settings) {
  const result = await client.query(
    `
      SELECT COUNT(*)::int AS count
      FROM account
      WHERE role = 'user'
        AND email LIKE $1
    `,
    [settings.emailLikePattern],
  );
  console.log(`Perf USER accounts: ${result.rows[0].count}`);
  console.log(`Email namespace: ${settings.emailPrefix}*@${settings.emailDomain}`);
  console.log(`Pool file exists: ${fs.existsSync(settings.poolFile) ? "yes" : "no"}`);

  const raceSeed = await client.query(
    `
      SELECT COUNT(*)::int AS count
      FROM products
      WHERE slug = $1
         OR slug LIKE $2
    `,
    [settings.raceProductSlug, "perf-booking-race-%"],
  );
  console.log(`Perf race product seeds: ${raceSeed.rows[0].count}`);

  const chatSeed = await client.query(
    `
      SELECT COUNT(*)::int AS count
      FROM partner_conversations c
      LEFT JOIN account user_account ON user_account.id = c.user_id
      LEFT JOIN account partner_account ON partner_account.id = c.partner_account_id
      WHERE (user_account.role = 'user' AND user_account.email LIKE $1)
         OR partner_account.email = $2
         OR c.id IN (
           SELECT conversation_id
           FROM partner_chat_messages
           WHERE client_message_id = 'perf-chat-seed-message'
         )
    `,
    [settings.emailLikePattern, settings.partnerEmail],
  );
  console.log(`Perf chat conversation seeds: ${chatSeed.rows[0].count}`);
}

function printHelp() {
  console.log(`
Usage:
  node scripts/register_perf_accounts.js create [--count 1200]
  node scripts/register_perf_accounts.js cleanup
  node scripts/register_perf_accounts.js reset [--count 1200]
  node scripts/register_perf_accounts.js status

Options:
  --count <n>             USER accounts to create. Must be greater than 1000.
  --password <value>      Password for all generated accounts. Default: ${DEFAULT_PASSWORD}
  --email-prefix <value>  Email prefix namespace. Default: ${DEFAULT_EMAIL_PREFIX}
  --email-domain <value>  Email domain namespace. Default: ${DEFAULT_EMAIL_DOMAIN}
  --bcrypt-rounds <n>     bcrypt cost, matching backend default. Default: ${DEFAULT_BCRYPT_ROUNDS}
  --pool-file <path>      Locust user-pool JSON output. Default: reports/perf_user_pool.json
  --csv-file <path>       CSV output for inspection. Default: reports/perf_user_pool.csv
  --env-file <path>       Backend env file to load. Default: ../.env
	  --with-support-accounts Create perf admin, partner, and employee accounts for all-module runs.
	                         Also creates a perf race product, product definition,
	                         employee eligibility, a chat conversation seed, and exports
	                         PERF_RACE_*, PERF_CHAT_*, and WS_* chat IDs.
  --race-product-slug <s> Slug for the booking race service seed. Default: ${DEFAULT_RACE_PRODUCT_SLUG}
  --race-product-name <s> Name for the booking race service seed. Default: ${DEFAULT_RACE_PRODUCT_NAME}

Behavior:
  - Existing accounts are SKIPPED (not deleted and recreated).
  - Use 'reset' to delete all perf accounts and start fresh.

Generated accounts are strictly scoped to:
  ${DEFAULT_EMAIL_PREFIX}NNNNNN@${DEFAULT_EMAIL_DOMAIN}
`);
}
