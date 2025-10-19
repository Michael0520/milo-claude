# Tool Inventory

## File Structure

```
~/.claude/                                    # Global config
├── CLAUDE.md                                 # Global standards
└── skills/                                   # Global skills
    ├── 1-mxsecurity-page-migrator/
    ├── 2-legacy-behavior-analyzer/
    ├── 3-signalstore-converter/
    ├── 4-legacy-test-generator/
    ├── 5-config-extractor/
    ├── 6-ddd-boundary-validator/
    └── test-skill/

one-ui/                                       # Project root
├── CLAUDE.md                                 # OneUI rules
└── .claude/                                  # Project config
    ├── skills/                               # Project skills
    │   ├── component-implementer/
    │   ├── template-suggester/
    │   └── test-coverage-builder/
    ├── commands/                             # Slash commands
    │   ├── new-crud.md
    │   └── templates.md
    └── templates/                            # Code templates
        ├── crud-table/
        │   ├── component.ts.template
        │   ├── component.html.template
        │   └── README.md
        └── form-dialog/
            ├── component.ts.template
            └── component.html.template

libs/mxsecurity/
└── CLAUDE.md                                 # MXSecurity migration guide
```

## Global Config

### ~/.claude/CLAUDE.md
- Git commit standards (no emoji, no Claude signature)
- Security rules (forbidden operations)
- RADIO development mode
- TDD, DDD, Config-driven principles
- TypeScript 5.3+ standards

**Scope**: All projects

## Global Skills (MXSecurity)

### 1. mxsecurity-page-migrator
**Trigger**: "migrate {page-name}"
**Function**: 6-step migration workflow
- Generate skeleton
- Analyze legacy code
- TDD implementation
- Config-driven refactoring
- Playwright verification
- Update status

### 2. legacy-behavior-analyzer
**Trigger**: Called by page-migrator, "analyze legacy code"
**Function**: 5-phase analysis
- Extract business rules
- Identify API contracts
- Locate hardcoded values

### 3. signalstore-converter
**Trigger**: BehaviorSubject detected, "convert to SignalStore"
**Function**: Modernize state management
```typescript
// Before: BehaviorSubject
private users$ = new BehaviorSubject<User[]>([]);

// After: SignalStore
export const UserStore = signalStore(
  { providedIn: 'root' },
  withState({ users: [] as User[] })
);
```

### 4. legacy-test-generator
**Trigger**: Called by page-migrator, "write tests"
**Function**: Generate compatibility tests
- TDD Red-Green-Refactor
- Legacy behavior preservation

### 5. config-extractor
**Trigger**: Magic numbers detected, "extract hardcoded"
**Function**: Config-driven development
```typescript
// Before: Magic numbers
if (attempts > 3) { lockAccount(1800000); }

// After: Config
export const AUTH_CONFIG = {
  maxLoginAttempts: 3,
  accountLockDuration: 30 * 60 * 1000
} as const;
```

### 6. ddd-boundary-validator
**Trigger**: "check module boundaries", lint errors
**Function**: Validate DDD architecture
- Check scope dependencies
- Check type layers
- Prevent circular dependencies

### 7. test-skill
**Trigger**: "test skill"
**Function**: Verify skills installation

## Project Config

### one-ui/CLAUDE.md
- Nx workspace commands
- Library generation scripts
- Module boundary rules (scope/type constraints)
- DDD layer structure
- Technology stack (Angular 19, NgRx, FormOXA)

**Scope**: one-ui project

### libs/mxsecurity/CLAUDE.md
- Migration workflow
- TDD implementation steps
- Config-driven refactoring principles
- Playwright verification
- Key command: `pnpm migrate:page {page-name}`

**Scope**: MXSecurity migration

## Project Skills

### 1. component-implementer
**Trigger**: `TODO: Implement component logic` found, "implement {component-name}"
**Function**: Implement unfinished components
- Analyze legacy code comments
- Modernize with Signals, inject()
- TDD implementation
- Remove TODO

**Solves**: 64 unimplemented components

### 2. template-suggester
**Trigger**: "create new page", "how to create table"
**Function**: Suggest project templates
- Identify needs (CRUD table / Form dialog)
- Suggest slash commands

### 3. test-coverage-builder
**Trigger**: Missing tests detected, "add tests", "improve coverage"
**Function**: Generate test suites
- Test templates (Service/Store/Component/UI)
- Batch generation
- Coverage targets: Domain 95%+, Features 80%+, UI 60%+

**Solves**: 5.9% → 95% coverage target

## Slash Commands

### /new-crud {entity-name}
**Function**: Create complete CRUD list page
- common-table integration
- Add/Edit/Delete operations
- Selection & Edit buttons
- API integration
- Signal-based state

**Example**: `/new-crud firmware`

### /templates
**Function**: List all available templates
- Template list
- Usage instructions
- Example locations

## Templates

### crud-table/
**Files**:
- `component.ts.template` - TypeScript component
- `component.html.template` - HTML template
- `README.md` - Usage guide

**Features**: Complete CRUD list page with common-table

**Variables**:
- `{{EntityName}}` → PascalCase
- `{{entity-name}}` → kebab-case
- `{{domain-name}}` → module name

### form-dialog/
**Files**:
- `component.ts.template`
- `component.html.template`

**Features**: Form dialog with Create/Edit mode

## Scenario Mapping

| Scenario | Tool | Command |
|----------|------|---------|
| **Migrate entire page** | Global: mxsecurity-page-migrator | "migrate firmware page" |
| **Create new CRUD page** | Command: /new-crud | `/new-crud firmware` |
| **Implement unfinished component** | Project: component-implementer | "implement firmware.component.ts" |
| **Add tests** | Project: test-coverage-builder | "add tests for firmware domain" |
| **Convert BehaviorSubject** | Global: signalstore-converter | Auto-triggered |
| **Extract hardcoded values** | Global: config-extractor | Auto-prompted when detected |
| **Check module boundaries** | Global: ddd-boundary-validator | "check module boundaries" |
| **View templates** | Command: /templates | `/templates` |

## Statistics

### Global Skills
- Total: 7
- Purpose: MXSecurity migration
- Scope: All projects

### Project Skills
- Total: 3
- Purpose: OneUI rapid development
- Scope: one-ui project

### Commands
- Total: 2
- Type: Quick creation tools

### Templates
- Total: 2 sets
- Type: CRUD table, Form dialog
- Files: 7

### CLAUDE.md
- Total: 3
- Levels: Global → Project → Module

## Workflows

### 1. Migrate Legacy Page
```
"migrate firmware page"
→ mxsecurity-page-migrator starts
→ Generate skeleton → Analyze → TDD → Refactor → Verify
```

### 2. Create New Page
```
/new-crud firmware
→ Answer questions (domain, columns)
→ Generate files
→ Manually add Domain layer
```

### 3. Implement Empty Component
```
"implement firmware.component.ts"
→ component-implementer starts
→ Read legacy code comments
→ Modernize implementation
```

### 4. Add Tests
```
"add tests for firmware domain"
→ test-coverage-builder starts
→ Generate test files
→ Run verification
```

## Related Documentation

| Document | Location | Description |
|----------|----------|-------------|
| Global Standards | `~/.claude/CLAUDE.md` | Global development standards |
| Project Rules | `one-ui/CLAUDE.md` | OneUI project rules |
| Migration Guide | `libs/mxsecurity/CLAUDE.md` | Migration workflow |
| CRUD Template | `.claude/templates/crud-table/README.md` | Template usage |
| Migration Guide | `libs/mxsecurity/docs/MIGRATION_GUIDE.md` | Detailed migration guide |
