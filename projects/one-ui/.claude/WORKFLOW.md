# Migration Workflow

## Goals

- Migration: Angular 16 → Angular 20
- Architecture: NgModules → Standalone + DDD
- State: BehaviorSubject → SignalStore
- Testing: 0% → 95% coverage

## Workflow 1: Migrate Legacy Page

### Step 1: Start Migration
```bash
"migrate firmware page"
```

Triggers: `mxsecurity-page-migrator` (Global Skill)

### Step 2: Generate Skeleton (Auto)
```bash
pnpm migrate:page firmware
```

Generated files include migration tracking header:
```typescript
// ================================================================================
// MIGRATION TRACKING
// ================================================================================
// Legacy Path: /path/to/legacy/file
// New Path: libs/mxsecurity/firmware/...
// Domain: firmware
// Priority: P1
// Migration Date: 2025-10-19
// ================================================================================
```

### Step 3: Analyze Legacy Code (Auto)
Triggers: `legacy-behavior-analyzer`

Analyzes:
1. Business rules
2. API endpoints and data structures
3. State management patterns
4. User interaction flows
5. Hardcoded values and magic numbers

### Step 4: TDD Implementation
Triggers: `legacy-test-generator`

**Red-Green-Refactor**:
1. **Red**: Write tests (based on legacy behavior)
2. **Green**: Minimal code to pass tests
3. **Refactor**: Modernize implementation

Skills assist:
- `component-implementer` - Implement components
- `signalstore-converter` - Convert state management
- `test-coverage-builder` - Add tests

### Step 5: Config-Driven Refactor
Triggers: `config-extractor`

```typescript
// Before: Magic numbers
if (attempts > 3) { ... }

// After: Config-driven
export const FIRMWARE_CONFIG = {
  maxUploadAttempts: 3,
  allowedFileTypes: ['.bin', '.fw'],
  maxFileSize: 10 * 1024 * 1024  // 10MB
} as const;
```

### Step 6: Playwright Verification
Use Playwright MCP to verify UI consistency

### Step 7: Validation Checklist
- [ ] All tests pass
- [ ] ESLint no errors
- [ ] TypeScript no errors
- [ ] Test coverage ≥ 95% (domain)
- [ ] UI matches legacy
- [ ] No module boundary violations
- [ ] All TODO comments removed

**Run validation**:
```bash
pnpm nx test mxsecurity-firmware-domain --coverage
pnpm nx lint mxsecurity-firmware-domain
pnpm migrate:status
```

## Workflow 2: Create New Page

### Step 1: Execute Command
```bash
/new-crud firmware
```

Or: "create firmware CRUD page"

Triggers: `template-suggester`

### Step 2: Answer Questions
1. Domain module name? (e.g., `management`)
2. Main fields? (e.g., `name, version, modelSeries, buildTime`)
3. Features needed?
   - Selectable (checkbox)
   - Editable (edit button)
   - Create/Delete operations

### Step 3: Auto-generate Files
Generated with:
- common-table integration
- Add/Edit/Delete buttons
- Selection & Edit
- API service integration
- Loading states
- Signal-based state

### Step 4: Add Domain Layer
Create:
```typescript
// 1. Model
export interface Firmware {
  id: string;
  name: string;
  version: string;
}

// 2. API Service
@Injectable({ providedIn: 'root' })
export class FirmwareApiService {
  private readonly http = inject(HttpClient);

  getAll(): Observable<Firmware[]> {
    return this.http.get<Firmware[]>('/api/v1/firmware');
  }
}
```

### Step 5: Create Dialog (Optional)
```bash
/new-dialog firmware-dialog
```

Or: "create firmware edit dialog"

### Step 6: Add Tests
```bash
"add tests for firmware domain"
```

Triggers: `test-coverage-builder`

## Workflow 3: Implement Unfinished Component

### Usage
```bash
"implement firmware.component.ts"
```

Triggers: `component-implementer` (Project Skill)

**Process**:
1. Read legacy code comments in file
2. Analyze business logic
3. Plan modernization
4. Implement TypeScript component
5. Update HTML template
6. Remove TODO comments

## Workflow 4: Add Tests

### Usage
```bash
"add tests for firmware domain"
# or
"improve firmware test coverage"
```

Triggers: `test-coverage-builder`

**Generated tests**:
1. Service tests (HTTP testing)
2. Component tests (with mocking)

**Verify**:
```bash
pnpm nx test mxsecurity-firmware-domain --coverage
```

## Daily Routine

### Morning
```bash
pnpm migrate:status
cat libs/mxsecurity/docs/TODO.md
pnpm nx serve mxsecurity-web
```

### During Work
```bash
# Migrate page
"migrate firmware page"

# Create new page
/new-crud device-group

# Add tests
"add tests for firmware domain"

# Check boundaries
"check module boundaries"
```

### Before End of Day
```bash
pnpm nx run-many -t test
pnpm nx run-many -t lint --fix
pnpm migrate:status
```

## Common Issues

### Module Boundary Violation
```bash
Error: A project tagged with "scope:mxsecurity" can only depend on...

Solution: "check module boundaries"
```

### Low Test Coverage
```bash
Current: 5.9%
Target: 95%

Solution: "add tests for {module} domain"
```

### Large Files
```bash
File > 500 lines

Solution: "split dashboard.component.ts"
```

### Unknown common-table Usage
```bash
# View template
/templates

# Use template
/new-crud my-entity

# View example
cat libs/mxsecurity/system/features/src/lib/user-account/user-account.component.html
```

## Progress Tracking

### View Status
```bash
pnpm migrate:status
```

Output:
```
MXSecurity Migration Status
============================
Total Pages: 20
Completed: 8 (40%)
In Progress: 3 (15%)
Not Started: 9 (45%)

Next Priority:
- firmware (P0)
- device-group (P0)
- logging (P0)
```

### View Files
```bash
ls -la ~/.claude/skills/
ls -la .claude/skills/
ls -la .claude/commands/
ls -la .claude/templates/
```

### View Inventory
```bash
cat .claude/INVENTORY.md
```

## Best Practices

### DO
- Use `/new-crud` to create pages quickly
- Let skills auto-trigger
- Write tests first (TDD)
- Extract hardcoded values to config
- Keep legacy code as comments

### DON'T
- Skip tests
- Violate module boundaries
- Mix Observable and Signal
- Modify passing tests
- Commit unverified code
