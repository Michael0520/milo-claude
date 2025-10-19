---
name: config-extractor
description: Extract hardcoded values and business rules to configuration files for Config-Driven Development
---

# Config Extractor

## Auto-activation Triggers
- Detects magic numbers (numeric constants)
- Detects hardcoded strings or conditions
- User says: "extract hardcoded values"
- User says: "make this config-driven"

## Reference Patterns
**Reference**: `libs/switch/*/domain/src/lib/config/`

## Extraction Strategy

### Identify Candidates

**Should Extract**
```typescript
// ❌ Magic Numbers
if (attempts > 3) { ... }
setTimeout(callback, 5000);
if (fileSize > 10485760) { ... }  // 10MB

// ❌ Hardcoded Strings
if (role === 'admin') { ... }
if (status === 'pending') { ... }

// ❌ Repeated Conditional Logic
if (user.role === 'admin' || user.role === 'superadmin') { ... }
```

**No Need to Extract**
```typescript
// ✅ Obvious Constants
const EMPTY_ARRAY = [];
const ZERO = 0;
const TRUE = true;

// ✅ Algorithm Constants
const RADIX = 10;
const BINARY = 2;
```

## Extraction Patterns

### Pattern 1: Business Constants

**Before**
```typescript
export class AuthService {
  login(credentials: Credentials) {
    if (this.attempts > 3) {
      this.lockAccount(1800000);  // 30 minutes
    }
  }
}
```

**After**
```typescript
// domain/config/auth.config.ts
export const AUTH_CONFIG = {
  maxLoginAttempts: 3,
  accountLockDuration: 30 * 60 * 1000,  // 30 minutes
  sessionTimeout: 60 * 60 * 1000,       // 1 hour
  passwordMinLength: 8,
  passwordRequireSpecialChar: true
} as const;

export type AuthConfig = typeof AUTH_CONFIG;

// auth.service.ts
import { AUTH_CONFIG } from './config/auth.config';

export class AuthService {
  login(credentials: Credentials) {
    if (this.attempts > AUTH_CONFIG.maxLoginAttempts) {
      this.lockAccount(AUTH_CONFIG.accountLockDuration);
    }
  }
}
```

### Pattern 2: Permission Mapping

**Before**
```typescript
canAccess(user: User, resource: string): boolean {
  if (user.role === 'admin') {
    return true;
  }
  if (user.role === 'operator' && resource !== 'system') {
    return true;
  }
  if (user.role === 'viewer' && (resource === 'system' || resource === 'management')) {
    return false;
  }
  return false;
}
```

**After**
```typescript
// domain/config/permissions.config.ts
export enum RoleName {
  Admin = 'admin',
  Operator = 'operator',
  Viewer = 'viewer'
}

export enum Resource {
  System = 'system',
  Management = 'management',
  Monitoring = 'monitoring'
}

// Resources each role cannot access
export const ROLE_RESTRICTIONS = {
  [RoleName.Admin]: [],  // No restrictions
  [RoleName.Operator]: [Resource.System],
  [RoleName.Viewer]: [Resource.System, Resource.Management]
} as const;

// permissions.service.ts
import { ROLE_RESTRICTIONS } from './config/permissions.config';

canAccess(user: User, resource: Resource): boolean {
  const restrictions = ROLE_RESTRICTIONS[user.role as RoleName] ?? [];
  return !restrictions.includes(resource);
}
```

### Pattern 3: Validation Rules

**Before**
```typescript
validateEmail(email: string): ValidationResult {
  if (!email) return { valid: false, error: 'Required' };
  if (email.length > 255) return { valid: false, error: 'Too long' };
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
    return { valid: false, error: 'Invalid format' };
  }
  return { valid: true };
}
```

**After**
```typescript
// domain/config/validation.config.ts
export const VALIDATION_RULES = {
  email: {
    required: true,
    maxLength: 255,
    pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    messages: {
      required: 'Email is required',
      maxLength: 'Email must be less than 255 characters',
      pattern: 'Invalid email format'
    }
  },
  password: {
    required: true,
    minLength: 8,
    maxLength: 128,
    requireUpperCase: true,
    requireLowerCase: true,
    requireNumber: true,
    requireSpecialChar: true
  }
} as const;

// validation.service.ts
import { VALIDATION_RULES } from './config/validation.config';

validateEmail(email: string): ValidationResult {
  const rules = VALIDATION_RULES.email;

  if (rules.required && !email) {
    return { valid: false, error: rules.messages.required };
  }
  if (email.length > rules.maxLength) {
    return { valid: false, error: rules.messages.maxLength };
  }
  if (!rules.pattern.test(email)) {
    return { valid: false, error: rules.messages.pattern };
  }
  return { valid: true };
}
```

### Pattern 4: Feature Flags

**Before**
```typescript
showNewDashboard(): boolean {
  return environment.production === false;
}

getMaxUploadSize(): number {
  return 10 * 1024 * 1024;  // 10MB
}
```

**After**
```typescript
// domain/config/features.config.ts
export const FEATURES = {
  enableNewDashboard: !environment.production,
  enableAdvancedFilters: true,
  enableExport: true,

  limits: {
    maxUploadSizeMB: 10,
    maxFileCount: 100,
    maxBatchSize: 1000
  },

  ui: {
    itemsPerPage: 20,
    defaultTimeout: 30000,  // 30 seconds
    retryAttempts: 3
  }
} as const;

// Calculate derived values
export const UPLOAD_LIMITS = {
  maxUploadSize: FEATURES.limits.maxUploadSizeMB * 1024 * 1024,
  maxFileCount: FEATURES.limits.maxFileCount
} as const;
```

## Config File Organization

### Directory Structure
```
domain/
└── config/
    ├── index.ts              # Unified exports
    ├── auth.config.ts        # Authentication
    ├── permissions.config.ts # Permission rules
    ├── validation.config.ts  # Validation rules
    ├── features.config.ts    # Feature flags
    └── api.config.ts         # API endpoints
```

### index.ts Unified Exports
```typescript
export * from './auth.config';
export * from './permissions.config';
export * from './validation.config';
export * from './features.config';
export * from './api.config';
```

## Extraction Checklist

- [ ] ✅ All magic numbers extracted
- [ ] ✅ All role/permission logic configured
- [ ] ✅ Validation rules centralized in config
- [ ] ✅ API endpoints defined in config
- [ ] ✅ Use `as const` for type safety
- [ ] ✅ Provide clear comments
- [ ] ✅ Config files have unit tests

## Important Notes

**Use `as const` for Type Safety**
```typescript
export const CONFIG = {
  status: 'active'
} as const;

// TypeScript infers: { readonly status: 'active' }
// Not: { status: string }
```

**Provide Defaults and Override Mechanism**
```typescript
export const getConfig = (overrides?: Partial<Config>): Config => ({
  ...DEFAULT_CONFIG,
  ...overrides
});
```
