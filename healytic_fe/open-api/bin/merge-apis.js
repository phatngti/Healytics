#!/usr/bin/env node

/**
 * Merge ai_apis.json into both user_apis.json and admin_apis.json.
 *
 * Usage:
 *   node bin/merge-apis.js
 */

const fs = require('fs');
const path = require('path');

const BASE_DIR = path.resolve(__dirname, '..');

const SOURCE_FILE = 'ai_apis.json';
const TARGET_FILES = ['user_apis.json', 'admin_apis.json'];

function mergeInto(sourceArg, targetArg) {
    const sourcePath = path.resolve(BASE_DIR, sourceArg);
    const targetPath = path.resolve(BASE_DIR, targetArg);

    if (!fs.existsSync(sourcePath)) {
        console.error(`Source file not found: ${sourcePath}`);
        process.exit(1);
    }
    if (!fs.existsSync(targetPath)) {
        console.error(`Target file not found: ${targetPath}`);
        process.exit(1);
    }

    const source = JSON.parse(fs.readFileSync(sourcePath, 'utf8'));
    const target = JSON.parse(fs.readFileSync(targetPath, 'utf8'));

    let addedPaths = 0;
    let skippedPaths = 0;
    let addedSchemas = 0;
    let skippedSchemas = 0;

    // --- Merge paths ---
    if (!target.paths) target.paths = {};
    for (const [pathKey, methods] of Object.entries(source.paths || {})) {
        if (!target.paths[pathKey]) {
            target.paths[pathKey] = methods;
            console.log('  + path:', pathKey);
            addedPaths++;
        } else {
            console.log('  ~ skipped path (duplicate):', pathKey);
            skippedPaths++;
        }
    }

    // --- Merge schemas ---
    if (!target.components) target.components = {};
    if (!target.components.schemas) target.components.schemas = {};
    for (const [name, schema] of Object.entries((source.components && source.components.schemas) || {})) {
        if (!target.components.schemas[name]) {
            target.components.schemas[name] = schema;
            console.log('  + schema:', name);
            addedSchemas++;
        } else {
            console.log('  ~ skipped schema (duplicate):', name);
            skippedSchemas++;
        }
    }

    // --- Strip unwanted schemas (e.g. FastAPI's ValidationError) ---
    const UNWANTED_SCHEMAS = ['ValidationError', 'HTTPValidationError'];
    for (const name of UNWANTED_SCHEMAS) {
        if (target.components.schemas[name]) {
            delete target.components.schemas[name];
            console.log('  ✕ removed schema:', name);
        }
    }

    // Remove response entries that reference the deleted schemas
    const unwantedRefs = new Set(
        UNWANTED_SCHEMAS.map(s => `#/components/schemas/${s}`)
    );
    for (const [pathKey, methods] of Object.entries(target.paths || {})) {
        for (const [method, operation] of Object.entries(methods)) {
            if (!operation.responses) continue;
            for (const [statusCode, response] of Object.entries(operation.responses)) {
                const ref = response?.content?.['application/json']?.schema?.$ref;
                if (ref && unwantedRefs.has(ref)) {
                    delete operation.responses[statusCode];
                    console.log(`  ✕ removed ${statusCode} response from ${method.toUpperCase()} ${pathKey}`);
                }
            }
        }
    }

    // --- Write result ---
    fs.writeFileSync(targetPath, JSON.stringify(target, null, 2) + '\n');

    console.log('');
    console.log(`Merge complete: ${sourceArg} → ${targetArg}`);
    console.log(`  Paths:   ${addedPaths} added, ${skippedPaths} skipped`);
    console.log(`  Schemas: ${addedSchemas} added, ${skippedSchemas} skipped`);
}

function main() {
    for (const targetFile of TARGET_FILES) {
        console.log(`\n========================================`);
        console.log(`Merging ${SOURCE_FILE} → ${targetFile}`);
        console.log(`========================================`);
        mergeInto(SOURCE_FILE, targetFile);
    }
}

main();
