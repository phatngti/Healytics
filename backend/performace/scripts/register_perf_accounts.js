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
const DEFAULT_ENV_FILE = path.join(BACKEND_ROOT, ".env");
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

  loadEnv(options.envFile || DEFAULT_ENV_FILE);

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

function loadEnv(envFile) {
  if (envFile && fs.existsSync(envFile)) {
    dotenv.config({ path: envFile, quiet: true });
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

  if (settings.withSupportAccounts) {
    await createSupportAccounts(client, settings);
  }

  // Write pool files for ALL users (existing + new) so test runners have the full list
  writePoolFiles(settings, users);
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

async function createSupportAccounts(client, settings) {
  console.log("Creating support admin/partner/employee perf accounts");

  await client.query("BEGIN");
  try {
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
    await ensureEmployeeProfile(client, employeeAccount.id, partnerId, settings.employeeEmail);

    await client.query("COMMIT");
    console.log(
      `Support accounts ready: admin=${admin.email}, partner=${partnerAccount.email}, employee=${employeeAccount.email}`,
    );
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  }
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
        '[]'::jsonb,
        'Dedicated partner profile for Healytics performance testing.',
        0,
        NOW(),
        NOW()
      )
      RETURNING id
    `,
    [DEFAULT_PARTNER_TAX_CODE, accountId],
  );
  return inserted.rows[0].id;
}

async function ensureEmployeeProfile(client, accountId, partnerId, email) {
  const existing = await client.query(
    "SELECT id FROM employees WHERE account_id = $1",
    [accountId],
  );
  if (existing.rowCount > 0) {
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
        'RECEPTIONIST',
        'ACTIVE',
        0,
        0,
        $3,
        $4,
        NOW(),
        NOW()
      )
      RETURNING id
    `,
    [DEFAULT_EMPLOYEE_CODE, email, partnerId, accountId],
  );
  return inserted.rows[0].id;
}

async function cleanupPerfAccounts(client, settings) {
  await client.query("BEGIN");
  try {
    const deleted = await deleteExistingPerfAccounts(client, settings);
    await client.query("COMMIT");
    removeGeneratedFiles(settings);
    console.log(`Deleted ${deleted} perf USER account(s)`);
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  }
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
        AND ccu.table_name = 'account'
        AND ccu.column_name = 'id'
        AND tc.table_schema = 'public'
        AND tc.table_name <> 'user_profile'
    `,
  );

  for (const row of references.rows) {
    const tableName = quoteIdentifier(row.table_schema, row.table_name);
    const columnName = quoteIdentifier(row.column_name);
    await client.query(`DELETE FROM ${tableName} WHERE ${columnName} = ANY($1::uuid[])`, [accountIds]);
  }
}

function quoteIdentifier(...parts) {
  return parts
    .map((part) => `"${String(part).replace(/"/g, '""')}"`)
    .join(".");
}

function writePoolFiles(settings, users) {
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

Behavior:
  - Existing accounts are SKIPPED (not deleted and recreated).
  - Use 'reset' to delete all perf accounts and start fresh.

Generated accounts are strictly scoped to:
  ${DEFAULT_EMAIL_PREFIX}NNNNNN@${DEFAULT_EMAIL_DOMAIN}
`);
}
