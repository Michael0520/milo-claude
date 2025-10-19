---
name: ddd-boundary-validator
description: Validate DDD layer dependencies ensuring no circular dependencies and module boundary violations
---

# DDD Boundary Validator

## Auto-activation Triggers
- Called by `mxsecurity-page-migrator` in validation phase
- User says: "check module boundaries"
- User says: "validate DDD architecture"
- Lint execution finds boundary errors

## Module Boundary Rules

### MXSecurity Scope Rules

**Each scope can only depend on itself and shared**
```typescript
// ✅ Correct
import { ... } from '@one-ui/mxsecurity/auth/domain';
import { ... } from '@one-ui/shared/ui';

// ❌ Wrong
import { ... } from '@one-ui/switch/login/domain';  // Cross-scope!
```

### Type Dependency Hierarchy

```
type:app → type:shell, type:feature, type:domain-logic, type:ui, type:util
type:shell → type:feature, type:domain-logic, type:util
type:feature → type:feature, type:domain-logic, type:ui, type:util
type:ui → type:ui, type:domain-logic, type:util
type:domain-logic → type:util, type:domain-logic
type:util → type:util, type:domain-logic
```

### Domain Layer Rules

**Domain is core, no dependencies on outer layers**

```typescript
// ✅ Domain can import
import { ... } from '@one-ui/shared/domain';
import { ... } from '@one-ui/mxsecurity/other/domain';

// ❌ Domain forbidden imports
import { ... } from '@one-ui/mxsecurity/auth/features';  // ❌ features
import { ... } from '@one-ui/mxsecurity/auth/ui';        // ❌ ui
import { ... } from '@one-ui/mxsecurity/auth/shell';     // ❌ shell
```

### Features Layer Rules

**Features coordinate Domain and UI**

```typescript
// ✅ Features can import
import { ... } from '@one-ui/mxsecurity/auth/domain';
import { ... } from '@one-ui/mxsecurity/auth/ui';
import { ... } from '@one-ui/shared/ui';
import { ... } from '@one-ui/shared/util';

// ❌ Features forbidden imports
import { ... } from '@one-ui/mxsecurity/login/features';  // ❌ other features
import { ... } from '@one-ui/mxsecurity/auth/shell';      // ❌ shell
```

### UI Layer Rules

**UI only for presentation, can use Domain types**

```typescript
// ✅ UI can import
import { User } from '@one-ui/mxsecurity/auth/domain';  // types only
import { ... } from '@one-ui/shared/ui';

// ❌ UI forbidden imports
import { UserStore } from '@one-ui/mxsecurity/auth/domain';  // ❌ no store
import { ... } from '@one-ui/mxsecurity/auth/features';      // ❌ features
```

### Shell Layer Rules

**Shell handles routing, can import Features**

```typescript
// ✅ Shell can import
import { ... } from '@one-ui/mxsecurity/auth/features';
import { ... } from '@one-ui/mxsecurity/auth/domain';

// ❌ Shell forbidden imports
import { ... } from '@one-ui/mxsecurity/auth/ui';  // ❌ no direct UI
```

## Validation Workflow

### Step 1: Run ESLint
```bash
pnpm nx lint mxsecurity-{page-name}-domain
pnpm nx lint mxsecurity-{page-name}-features
pnpm nx lint mxsecurity-{page-name}-ui
pnpm nx lint mxsecurity-{page-name}-shell
```

### Step 2: Analyze Errors

**Common Error Types**

```bash
# Error 1: Cross-scope dependency
A project tagged with "scope:mxsecurity" can only depend on libs tagged with "scope:mxsecurity" or "scope:shared"
→ Solution: Move shared code to shared library

# Error 2: Circular dependency
Circular dependency detected:
  mxsecurity-auth-features → mxsecurity-login-features → mxsecurity-auth-features
→ Solution: Extract shared logic to domain or create new shared library

# Error 3: Layer dependency violation
A project tagged with "type:domain-logic" can only depend on "type:util" or "type:domain-logic"
→ Solution: Remove domain dependencies on features/ui
```

### Step 3: Fix Suggestions

**Scenario 1: Domain depends on Features**
```typescript
// ❌ Problem
// domain/auth.store.ts
import { LoginComponent } from '@one-ui/mxsecurity/auth/features';

// ✅ Solution: Reverse dependency
// features/login.component.ts
import { AuthStore } from '@one-ui/mxsecurity/auth/domain';
```

**Scenario 2: Features depend on each other**
```typescript
// ❌ Problem
// features/login.component.ts
import { DashboardService } from '@one-ui/mxsecurity/dashboard/features';

// ✅ Solution 1: Extract to domain
// domain/shared.service.ts
export class SharedService { ... }

// ✅ Solution 2: Use event communication
// Don't depend directly, communicate via event bus or store
```

**Scenario 3: UI uses Store**
```typescript
// ❌ Problem
// ui/user-card.component.ts
import { UserStore } from '@one-ui/mxsecurity/auth/domain';

export class UserCardComponent {
  store = inject(UserStore);  // ❌ UI shouldn't use store
}

// ✅ Solution: Receive data via @Input
// ui/user-card.component.ts
export class UserCardComponent {
  @Input() user!: User;  // ✅ Only receive data
  @Output() userClick = new EventEmitter<User>();
}

// features/user-list.component.ts
export class UserListComponent {
  store = inject(UserStore);  // ✅ Feature uses store
}
```

## Validation Checklist

- [ ] ✅ Domain has no dependencies on features/ui/shell
- [ ] ✅ Features has no dependencies on other features
- [ ] ✅ UI has no dependencies on features/shell
- [ ] ✅ No circular dependencies
- [ ] ✅ No cross-scope dependencies (except shared)
- [ ] ✅ Import paths use @one-ui/* aliases
- [ ] ✅ All ESLint rules pass

## Quick Fix Commands

```bash
# Auto-fix fixable errors
pnpm nx run-many -t lint --fix

# Check specific project
pnpm nx lint mxsecurity-auth-domain --fix

# Check all mxsecurity projects
pnpm nx run-many -t lint -p "tag:scope:mxsecurity" --fix
```

## Dependency Graph Check

```bash
# Generate dependency graph
pnpm nx graph

# Check specific project dependencies
pnpm nx show project mxsecurity-auth-domain --graph
```

## Important Notes

**Type-only imports are allowed**
```typescript
// ✅ UI can import domain types
import type { User } from '@one-ui/mxsecurity/auth/domain';

// ❌ But cannot import implementations
import { UserStore } from '@one-ui/mxsecurity/auth/domain';  // ❌
```

**Shared libraries exception**
```typescript
// ✅ Any layer can use shared
import { ... } from '@one-ui/shared/ui';
import { ... } from '@one-ui/shared/util';
import { ... } from '@one-ui/shared/domain';
```
