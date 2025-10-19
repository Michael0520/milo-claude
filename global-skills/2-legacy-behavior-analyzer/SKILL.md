---
name: legacy-behavior-analyzer
description: Extract business rules, API contracts, and hardcoded logic from Angular 16 legacy code
---

# Legacy Behavior Analyzer

## Auto-activation Triggers
- Called by `mxsecurity-page-migrator`
- User says: "analyze legacy code for {file}"
- User says: "how does this work in the old system?"

## Analysis Workflow

### Phase 1: Locate Files
```bash
# Search for main page files
~/moxa/f2e-networking/apps/mxsecurity-web/src/app/pages/{page-name}/
```

Common file patterns:
- `{page-name}.component.ts` - Main logic
- `{page-name}.service.ts` - API calls
- `{page-name}.module.ts` - Module configuration
- `{page-name}.html` - Template

### Phase 2: Extract Business Rules

**Focus Areas**

1. **Form Validation**
```typescript
// Identify all validation rules
Validators.required
Validators.minLength(X)
Validators.maxLength(X)
Validators.pattern(...)
Custom validators
```

2. **Permission Checks**
```typescript
// Role and permission logic
if (user.role === 'admin') { ... }
if (hasPermission('write')) { ... }
```

3. **Business Calculations**
```typescript
// Data transformation and calculations
calculateTotal()
transformData()
validateBusinessRule()
```

4. **State Transitions**
```typescript
// State machine logic
status: 'pending' -> 'active' -> 'completed'
```

### Phase 3: Document API Contracts

**API Call Inventory**

For each API, document:

```typescript
// GET /api/v1/users
Request: { id: string }
Response: {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'operator' | 'viewer';
}
Error handling: 404, 401, 500
```

### Phase 4: Identify Hardcoded Values

**Extraction Candidates**

```typescript
// ❌ Hardcoded (needs extraction)
if (attempts > 3) { ... }           // Magic number
if (role === 'admin') { ... }       // Conditional logic
const timeout = 5000;               // Constants

// ✅ Should extract to config
export const AUTH_CONFIG = {
  maxAttempts: 3,
  timeout: 5000
} as const;
```

### Phase 5: Generate Analysis Report

**Output Format**

```markdown
# {PageName} Legacy Analysis Report

## 1. Business Rules
- Rule 1: Description...
- Rule 2: Description...

## 2. API Endpoints
| Method | Path | Purpose | Request | Response |
|--------|------|---------|---------|----------|
| GET    | /api/users | Get user list | - | User[] |

## 3. State Management
- Uses BehaviorSubject: `users$`, `loading$`
- State fields: `{ users: [], loading: false, error: null }`

## 4. Extract to Config
- MAX_LOGIN_ATTEMPTS = 3
- SESSION_TIMEOUT = 1800000
- ROLE_PERMISSIONS = { ... }

## 5. Test Case Suggestions
- [ ] Test account lock after 3 failed login attempts
- [ ] Test different role permissions
- [ ] Test session timeout

## 6. Migration Considerations
- ⚠️ Uses deprecated API (needs update)
- ⚠️ Complex nested subscriptions (needs refactor)
```

## Key Principles

**Document business logic only, ignore implementation details**
- ✅ Document: "Lock account for 30 minutes after 3 failed login attempts"
- ❌ Don't document: "Uses setTimeout for delay implementation"

**Preserve necessary quirks**
If legacy system has special behaviors (even if unreasonable), document them:
```typescript
// Legacy quirk: Password field auto-trims whitespace
// Must preserve this behavior for compatibility
```
