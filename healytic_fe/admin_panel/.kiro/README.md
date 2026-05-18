# Kiro Configuration — Healytics Admin Panel

This directory configures Kiro AI to work consistently with the project's
architecture, conventions, and workflows. It mirrors the `.agent/` directory
in a Kiro-native layout.

## Layout

```
.kiro/
├── README.md                          # This file
├── steering/                          # Always-on, file-matched, and manual rules
│   ├── core-architecture.md           # always_on: Clean Architecture
│   ├── engineering-excellence.md      # always_on: quality + testing standards
│   ├── ui-design-system.md            # always_on: theming + responsive
│   ├── dart-conventions.md            # fileMatch: *.dart
│   ├── riverpod-patterns.md           # fileMatch: **/*.provider.dart
│   ├── data-layer.md                  # manual (#data-layer)
│   ├── form-autofill.md               # manual (#form-autofill)
│   ├── no-hardcoded-strings.md        # manual (#no-hardcoded-strings)
│   ├── routing.md                     # manual (#routing)
│   └── workflows/                     # Manual step-by-step recipes
│       ├── add-autofill.md
│       ├── api-integration.md
│       ├── code-generation.md
│       ├── create-component.md
│       ├── create-entity.md
│       ├── create-feature.md
│       ├── create-provider.md
│       ├── create-quill-data.md
│       ├── create-screen.md
│       ├── design-mobile-page.md
│       ├── refactor-hardcodes.md
│       ├── run-tests.md
│       └── theme-check.md
└── skills/                            # Specialized expertise on demand
    ├── clean-arch-review/SKILL.md
    ├── flutter-testing/SKILL.md
    ├── form-autofill/SKILL.md
    ├── freezed-models/SKILL.md
    ├── hardcode-review/SKILL.md
    ├── quill-data/SKILL.md
    ├── riverpod-mastery/SKILL.md
    └── ui-review/SKILL.md
```

## Inclusion Modes

Steering files use front-matter to control when they load:

| Mode | When it loads | Used for |
|---|---|---|
| (default / no front-matter) | Every interaction | Core architecture, quality, design system |
| `inclusion: fileMatch` | When matching files are in context | Language-specific rules (Dart, Riverpod) |
| `inclusion: manual` | When user references with `#name` | Workflows + opt-in topics (data-layer, routing, autofill, hardcoded strings) |

## Skills

Skills live under `.kiro/skills/<name>/SKILL.md` and are activated by Kiro
when the task matches the skill's `description`. Each skill provides deep,
actionable expertise — review checklists, patterns, code templates.

## Workflows

Workflows are manual steering files under `steering/workflows/`. Reference
one in chat with `#<workflow-name>` to load step-by-step instructions for
a specific task (e.g., `#create-feature`, `#add-autofill`).

## Source

These files were translated from `.agent/` (the previous AI configuration
folder) into Kiro's native format. The two directories are kept in sync —
when updating one, mirror the change in the other.
