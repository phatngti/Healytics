---
description: Code formatting, linting, and quality checks
---

# Lint and Format Workflow

Use this workflow to maintain code quality and consistent formatting.

---

## 1. Run Linter with Auto-Fix

// turbo
```bash
npm run lint
```

This runs ESLint with `--fix` flag to automatically fix issues.

---

## 2. Format Code with Prettier

// turbo
```bash
npm run format
```

This formats all `.ts` files in `src/` and `test/`.

---

## 3. Check for Issues Without Fixing

### ESLint Check Only

```bash
npx eslint "{src,apps,libs,test}/**/*.ts"
```

### Prettier Check Only

```bash
npx prettier --check "src/**/*.ts" "test/**/*.ts"
```

---

## 4. Common Lint Errors and Fixes

### Unused Variables

```typescript
// Error: 'foo' is defined but never used
const foo = 1;

// Fix: Remove or prefix with underscore
const _foo = 1; // Ignored by linter
```

### Missing Return Types

```typescript
// Error: Missing return type
function getData() { ... }

// Fix: Add explicit return type
function getData(): Promise<Data[]> { ... }
```

### Any Type Usage

```typescript
// Error: Unexpected any
const data: any = {};

// Fix: Define proper type
interface MyData { name: string; }
const data: MyData = { name: 'test' };
```

---

## 5. Pre-Commit Hook (Recommended)

Add to `package.json` to run lint before commits:

```json
{
  "husky": {
    "hooks": {
      "pre-commit": "npm run lint && npm run format"
    }
  }
}
```

---

## 6. IDE Integration

### VS Code Settings

Add to `.vscode/settings.json`:

```json
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```

---

## 7. Full Quality Check

Run all checks in sequence:

// turbo
```bash
npm run lint && npm run format && npm run build && npm run test
```
