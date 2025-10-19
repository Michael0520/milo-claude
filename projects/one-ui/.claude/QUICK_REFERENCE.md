# Quick Reference

## Most Used Commands

**Migrate legacy page**
```
"migrate firmware page"
```

**Create new CRUD page**
```
/new-crud firmware
```

**Implement empty component**
```
"implement firmware.component.ts"
```

**Add tests**
```
"add tests for firmware domain"
```

**Check module boundaries**
```
"check module boundaries"
```

**View templates**
```
/templates
```

## Skills

### Global Skills (All projects)

| Skill | Trigger | Function |
|-------|---------|----------|
| **mxsecurity-page-migrator** | "migrate {page}" | Complete 6-step migration |
| **legacy-behavior-analyzer** | Auto | Analyze legacy code |
| **signalstore-converter** | Auto | BehaviorSubject→Signal |
| **legacy-test-generator** | Auto | Generate compatibility tests |
| **config-extractor** | Magic numbers detected | Extract to config |
| **ddd-boundary-validator** | "check boundaries" | Module boundary validation |

### Project Skills (OneUI)

| Skill | Trigger | Function |
|-------|---------|----------|
| **component-implementer** | "implement {component}" | Implement unfinished component |
| **template-suggester** | "create page" | Suggest templates |
| **test-coverage-builder** | "add tests" | Batch generate tests |

## Slash Commands

| Command | Function | Example |
|---------|----------|---------|
| `/new-crud {name}` | Create CRUD page | `/new-crud firmware` |
| `/templates` | View all templates | `/templates` |

## File Locations

### Global Config
```
~/.claude/
├── CLAUDE.md          # Global standards
└── skills/            # Global skills
    ├── 1-mxsecurity-page-migrator/
    ├── 2-legacy-behavior-analyzer/
    ├── 3-signalstore-converter/
    ├── 4-legacy-test-generator/
    ├── 5-config-extractor/
    └── 6-ddd-boundary-validator/
```

### Project Config
```
one-ui/.claude/
├── skills/            # Project skills
│   ├── component-implementer/
│   ├── template-suggester/
│   └── test-coverage-builder/
├── commands/          # Slash commands
│   ├── new-crud.md
│   └── templates.md
└── templates/         # Code templates
    ├── crud-table/
    └── form-dialog/
```

### Documentation
```
~/.claude/CLAUDE.md              # Global standards
one-ui/CLAUDE.md                 # OneUI project rules
libs/mxsecurity/CLAUDE.md        # MXSecurity migration guide
```

## Scenario Mapping

| I want to... | How to do it | Tool |
|--------------|--------------|------|
| **Migrate legacy page** | "migrate firmware page" | mxsecurity-page-migrator |
| **Create new page** | `/new-crud firmware` | template + command |
| **Implement empty component** | "implement firmware.component.ts" | component-implementer |
| **Convert BehaviorSubject** | Auto-triggered | signalstore-converter |
| **Extract hardcoded values** | Auto-triggered | config-extractor |
| **Add tests** | "add tests for firmware" | test-coverage-builder |
| **Check architecture** | "check module boundaries" | ddd-boundary-validator |
| **Create dialog** | Copy template manually | .claude/templates/form-dialog/ |
| **View templates** | `/templates` | slash command |

## Testing Commands

```bash
# Single library test
pnpm nx test mxsecurity-firmware-domain

# Test coverage
pnpm nx test mxsecurity-firmware-domain --coverage

# Watch mode
pnpm nx test mxsecurity-firmware-domain --watch

# All tests
pnpm nx run-many -t test
```

## Lint Commands

```bash
# Single library lint
pnpm nx lint mxsecurity-firmware-domain

# Auto-fix
pnpm nx lint mxsecurity-firmware-domain --fix

# All lint
pnpm nx run-many -t lint --fix
```

## Migration Commands

```bash
# View progress
pnpm migrate:status

# View migratable pages
pnpm migrate:list

# Migrate page (generate skeleton)
pnpm migrate:page firmware

# Sync status
python3 libs/mxsecurity/tools/sync-migrated-status.py --domain firmware
```

## Dev Commands

```bash
# Start dev server
pnpm nx serve mxsecurity-web

# Build
pnpm nx build mxsecurity-web

# Generate library
./scripts/nx-generate-lib.sh --scope mxsecurity --domain-name my-feature --type all
```

## Template Usage

### CRUD Table
```bash
# Method 1: Slash command
/new-crud firmware

# Method 2: Manual copy
cp .claude/templates/crud-table/component.ts.template \
   libs/mxsecurity/{domain}/features/src/lib/{entity}/{entity}.component.ts

# Replace variables
{{EntityName}}  → Firmware
{{entity-name}} → firmware
{{domain-name}} → management
```

### Form Dialog
```bash
# Manual copy
cp .claude/templates/form-dialog/component.ts.template \
   libs/mxsecurity/{domain}/features/src/lib/{entity}-dialog/{entity}-dialog.component.ts
```

## Common Errors

### Module boundary violation
```bash
Error: A project tagged with "scope:mxsecurity" can only depend on...

Solution: "check module boundaries"
```

### Low test coverage
```bash
Current: 5.9%
Target: 95%

Solution: "add tests for {module} domain"
```

### Project not found
```bash
Error: Cannot find project 'mxsecurity-firmware-domain'

Solution: Use correct format
✅ mxsecurity-firmware-domain
❌ mxsecurity/firmware/domain
```

## Hot Keys

```bash
# Start development
pnpm nx serve mxsecurity-web

# Test + Lint
pnpm nx run-many -t test lint --fix

# View migration progress
pnpm migrate:status

# Create new page (to Claude)
"/new-crud device-group"

# Migrate page (to Claude)
"migrate firmware page"
```
