---
name: mxsecurity-page-migrator
description: Complete migration workflow from Angular 16 to Angular 20 with DDD architecture and SignalStore
---

# MXSecurity Page Migrator

## Auto-activation Triggers
- User says: "migrate {page-name} page"
- User says: "migrate {page-name}"
- User says: "start migrating {page-name}"

## Migration Workflow

### Step 1: Generate Project Skeleton
```bash
pnpm migrate:page {page-name}
```

Verify generated structure:
```
libs/mxsecurity/{page-name}/
├── domain/
├── features/
├── ui/
└── shell/
```

### Step 2: Analyze Legacy Business Logic
**Auto-activate `legacy-behavior-analyzer` skill**

Read legacy project:
```bash
~/moxa/f2e-networking/apps/mxsecurity-web/src/app/pages/{page-name}/
```

Document:
- [ ] API endpoints and data structures
- [ ] Business validation rules
- [ ] State management patterns
- [ ] User interaction flows
- [ ] Permission control logic

### Step 3: Reference Modern Architecture Patterns
Review Switch App corresponding features:
```bash
libs/switch/{similar-feature}/
```

Focus on:
- **SignalStore usage**: `domain/*.store.ts`
- **Component structure**: `features/*.component.ts`
- **Config patterns**: `domain/config/*.ts`
- **API Service**: `domain/*.api.ts`

### Step 4: TDD Implementation
**Auto-activate `legacy-test-generator` skill**

Red-Green-Refactor cycle:

**Red (Write failing tests)**
```typescript
describe('Legacy Compatibility: {PageName}', () => {
  it('should maintain exact legacy behavior', () => {
    // Test based on legacy code
  });
});
```

**Green (Implement features)**
- **Auto-activate `signalstore-converter` skill** to create state
- **Auto-activate `config-extractor` skill** to extract hardcoded values

**Refactor (Optimize)**
- Ensure DDD architecture compliance
- Extract magic numbers to config
- Improve code readability

### Step 5: Validation & Testing
**Auto-activate `ddd-boundary-validator` skill**

Run validation commands:
```bash
# Lint checks
pnpm nx lint mxsecurity-{page-name}-domain
pnpm nx lint mxsecurity-{page-name}-features
pnpm nx lint mxsecurity-{page-name}-ui

# Tests
pnpm nx test mxsecurity-{page-name}-domain --coverage

# Build
pnpm nx build mxsecurity-web
```

### Step 6: Migration Completion Checklist

- [ ] ✅ All DDD layer files created
- [ ] ✅ Legacy behavior verified with tests
- [ ] ✅ Test coverage ≥ 95%
- [ ] ✅ No ESLint errors
- [ ] ✅ No TypeScript errors
- [ ] ✅ Build successful
- [ ] ✅ No module boundary violations
- [ ] ✅ All hardcoded values extracted to config

## Critical Rules (Strictly Follow)

**❌ Forbidden**
- Using `BehaviorSubject` (use SignalStore instead)
- Using `any` type
- Violating module boundary rules
- Constructor injection (use `inject()` instead)
- Modifying passing tests to make new code pass

**✅ Required**
- Use `@ngrx/signals` SignalStore
- Use `inject()` function
- Use `OnPush` change detection
- Use Standalone components
- Keep necessary business logic comments
- Remove obvious code comments

## References
- MXSecurity CLAUDE.md: `libs/mxsecurity/CLAUDE.md`
- Legacy App: `~/moxa/f2e-networking`
- Modern Patterns: `libs/switch/*`
- Global Settings: `~/.claude/CLAUDE.md`
