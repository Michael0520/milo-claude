# One-UI Project Template

Angular 20 + DDD Architecture + Signal-based State Management project template for Claude Code.

## Overview

This template provides a complete Claude Code setup for Angular 20 projects following DDD architecture principles.

### What's Included

- **3 Project Skills** - Component implementation, templates, testing
- **2 Commands** - Quick CRUD and dialog generation
- **2 Templates** - CRUD table and form dialog scaffolding
- **5 Documentation Files** - Style guide, workflows, comparisons, inventory, quick reference

## Structure

```
.claude/
├── skills/
│   ├── component-implementer/      # Implement components from legacy code
│   ├── template-suggester/         # Suggest project templates
│   └── test-coverage-builder/      # Build comprehensive test suite
│
├── commands/
│   ├── new-crud.md                 # Create CRUD page command
│   └── templates.md                # List templates command
│
├── templates/
│   ├── crud-table/                 # CRUD table template
│   │   ├── component.ts.template
│   │   ├── component.html.template
│   │   └── README.md
│   └── form-dialog/                # Form dialog template
│       ├── component.ts.template
│       ├── component.html.template
│       └── README.md
│
├── MY_STYLE.md                     # Core philosophy: Config = Spec = Test
├── QUICK_REFERENCE.md              # Essential commands and patterns
├── INVENTORY.md                    # Complete skill catalog
├── WORKFLOW.md                     # 4 main workflows
└── COMPARISON.md                   # Before/After examples
```

## Installation

From your one-ui project root:

```bash
# Option 1: Use installation script
/path/to/milo-claude/scripts/install-project.sh one-ui

# Option 2: Manual installation
cp -r /path/to/milo-claude/projects/one-ui/.claude .
cp /path/to/milo-claude/projects/one-ui/CLAUDE.md .
```

## Project Skills

### 1. component-implementer

**Purpose**: Implement unfinished components by extracting logic from legacy code comments

**Auto-triggers**:
- Sees `TODO: Implement component logic`
- "implement {component-name}"
- File has large legacy code comments but empty implementation

**What it does**:
1. Reads LEGACY CODE block in comments
2. Extracts: ViewChild, services, state, lifecycle, methods
3. Converts to Angular 20 patterns (inject(), signal(), viewChild())
4. Implements with TDD approach
5. Removes TODO after completion

**Usage**:
```
You: "implement this component"

Claude:
→ Reads legacy code comments
→ Plans modern rewrite
→ Implements with Angular 20 patterns
→ Provides tests
```

---

### 2. template-suggester

**Purpose**: Suggest project templates when creating new components

**Auto-triggers**:
- "create new page"
- "add component"
- "how to create table/form"
- Component file is empty or has basic structure

**What it does**:
1. Identifies what you need (CRUD Table or Form Dialog)
2. Suggests appropriate command (/new-crud or /new-dialog)
3. Explains what the template includes
4. Helps you use the template

**Usage**:
```
You: "create firmware management page"

Claude:
→ template-suggester activates
→ Suggests: /new-crud firmware
→ Explains features included
→ Asks if you want help using it
```

---

### 3. test-coverage-builder

**Purpose**: Build comprehensive test suite to achieve 95% coverage target

**Auto-triggers**:
- Missing `.spec.ts` files
- "add tests", "write tests"
- "improve test coverage"
- `nx test` shows low coverage

**What it does**:
1. Finds files missing tests
2. Generates appropriate test templates
3. Targets: Domain 95%+, Features 80%+, UI 60%+
4. Supports batch generation

**Current Status**:
- Total files: 604
- Test files: 36
- Coverage: 5.9%
- Target: 95%

**Usage**:
```
You: "add tests for user module"

Claude:
→ Finds missing test files
→ Generates Service, Store, Component test templates
→ Provides coverage report commands
```

---

## Commands

### /new-crud {entity-name}

Create complete CRUD page with common-table.

**Usage**:
```bash
/new-crud firmware
/new-crud device-group
/new-crud user-profile
```

**Interactive prompts**:
1. Domain module name (e.g., `management`, `system`)
2. Columns needed (e.g., name, version, status)
3. Features: Selectable, Editable, Create/Delete, Search

**Generates**:
- `{entity-name}.component.ts` - Component with common-table
- `{entity-name}.component.html` - Template

**Includes**:
- ✅ common-table with sorting & pagination
- ✅ Row selection (checkbox)
- ✅ Edit button
- ✅ Add / Delete / Refresh buttons
- ✅ Loading state
- ✅ CRUD API integration
- ✅ Delete confirmation dialog

**Next steps provided**:
1. Create Domain Layer (model + API service)
2. Create Dialog (if Create/Edit needed)
3. Add i18n keys
4. Add routes
5. Test

---

### /templates

List all available templates and usage examples.

**Shows**:
- Available templates
- Usage examples
- Real project references
- Quick tips

---

## Templates

### CRUD Table Template

**Location**: `.claude/templates/crud-table/`

**Use when**:
- Need to display data in list/table format
- Need CRUD operations (Create, Read, Update, Delete)
- Need search/sort/pagination

**Features**:
- common-table component integration
- Signal-based state management
- OnPush change detection
- Material UI components
- API service integration

**Generated files**:
- `component.ts.template` - TypeScript component
- `component.html.template` - HTML template

---

### Form Dialog Template

**Location**: `.claude/templates/form-dialog/`

**Use when**:
- Need create/edit form
- Dialog presentation
- Form validation

**Features**:
- Reactive Form with validation
- Create/Edit mode support
- Material form fields
- Submit/Cancel buttons
- Error handling

**Generated files**:
- `component.ts.template` - Dialog component
- `component.html.template` - Dialog template

---

## Documentation

### MY_STYLE.md - Development Philosophy

**Core Trinity**: Config = Spec = Test

Explains:
- Config-Driven Development
- Domain-Driven Design (DDD)
- Test-Driven Development (TDD)
- How they work together

### QUICK_REFERENCE.md - Essential Commands

Quick lookup for:
- Migration commands
- Testing patterns
- DDD structure
- Common operations

### INVENTORY.md - Complete Catalog

Lists:
- All 9 skills (6 global + 3 project)
- Trigger conditions
- Usage scenarios
- Skill relationships

### WORKFLOW.md - 4 Main Workflows

Detailed workflows:
1. Migration Workflow (6 phases)
2. Daily Development (template-driven)
3. Testing Workflow (TDD cycle)
4. New Feature (plan → implement → test)

### COMPARISON.md - Before/After Examples

Shows transformations:
- Angular 16 → Angular 20
- BehaviorSubject → signal()
- @ViewChild → viewChild()
- NgModule → Standalone
- RxJS → Signals

---

## Usage Examples

### Create New CRUD Page

```
You: "create firmware management page"

Claude: Suggests /new-crud firmware

You: "/new-crud firmware"

Claude: Asks domain, columns, features
→ Generates component.ts + component.html
→ Provides next steps checklist
```

### Implement Component from Legacy

```typescript
// File with TODO and legacy code comments
// TODO: Implement component logic
// ================================================================================
// LEGACY CODE
// ================================================================================
```

```
You: "implement this component"

Claude:
→ component-implementer activates
→ Extracts legacy logic
→ Converts to Angular 20
→ Implements modern patterns
```

### Add Tests for Module

```
You: "add tests for firmware module"

Claude:
→ test-coverage-builder activates
→ Finds missing tests
→ Generates test templates (Service, Store, Component)
→ Targets 95% coverage
```

---

## DDD Architecture

This template enforces DDD layer separation:

```
Domain Layer (type:domain-logic)
├── Business logic and state management
├── Services that interact with APIs
├── NgRx store, actions, effects
└── Data models and interfaces

Features Layer (type:feature)
├── Smart components that connect to state
├── Page-level components
└── Feature-specific routing

UI Layer (type:ui)
├── Presentational/dumb components
├── Reusable UI components
├── Receive data via @Input()
└── Emit events via @Output()

Shell Layer (type:shell)
├── Application routing configuration
├── Layout components
└── Route guards and resolvers
```

### Module Boundary Rules

Each scope can only depend on itself and shared:
- `scope:mxsecurity` → `['scope:mxsecurity', 'scope:shared']`

Type dependency hierarchy:
- `type:app` → `['type:feature', 'type:shell', 'type:domain-logic', 'type:util', 'type:ui']`
- `type:feature` → `['type:feature', 'type:util', 'type:ui', 'type:domain-logic']`
- `type:ui` → `['type:ui', 'type:util', 'type:domain-logic']`
- `type:domain-logic` → `['type:util', 'type:domain-logic']`

---

## Best Practices

### 1. Use Templates for Common Patterns

Don't write from scratch:
```
✅ /new-crud firmware
❌ Manually create CRUD component
```

### 2. Follow DDD Boundaries

Keep layers separated:
```
✅ Domain has no dependencies on Features/UI
✅ UI components are dumb, receive data via @Input
❌ UI importing from Features
❌ Domain importing from UI
```

### 3. Maintain High Test Coverage

Target coverage:
- Domain: 95%+
- Features: 80%+
- UI: 60%+

### 4. Use Signal-Based State

Modern patterns:
```typescript
✅ protected readonly data = signal<Entity[]>([]);
✅ protected readonly loading = signal(false);
❌ private data$ = new BehaviorSubject<Entity[]>([]);
```

### 5. Config-Driven Development

Extract hardcoded values:
```typescript
✅ AUTH_CONFIG.maxLoginAttempts
❌ if (attempts > 3)
```

---

## Reference Examples

Real implementations in the project:

| Page | Location | Description |
|------|----------|-------------|
| User Account | `libs/mxsecurity/system/features/src/lib/user-account/` | CRUD table with tabs |
| License | `libs/mxsecurity/license/features/src/lib/license/` | Table with custom columns |
| Report | `libs/mxsecurity/report/features/src/lib/` | Complex table with filters |

---

## Troubleshooting

### Commands Not Working

Check installation:
```bash
ls .claude/commands/
# Should show: new-crud.md, templates.md
```

### Skills Not Activating

Verify skills installation:
```bash
ls .claude/skills/
# Should show: component-implementer, template-suggester, test-coverage-builder
```

### Templates Not Found

Check templates directory:
```bash
ls .claude/templates/
# Should show: crud-table, form-dialog
```

---

## Support

For issues or questions:
- Check main [milo-claude README](../../README.md)
- Review [Usage Guide](../../docs/USAGE_GUIDE.md)
- Check individual documentation files in `.claude/`

---

**Template Version**: 1.0.0
**Compatible With**: Angular 19+, Nx Workspace
**Architecture**: DDD (Domain-Driven Design)
**State Management**: @ngrx/signals (SignalStore)
