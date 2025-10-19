# Development Style

## Core Philosophy: Config = Spec = Test

Business rules as configuration enable TDD, DDD layer separation makes testing easy.

```
Config (Business Rules)
  ↓
= Spec (Specification)
  ↓
→ Test (Testable)
  ↓
→ Quality
```

### Why This Works

**1. Config IS Spec**
```typescript
// Config describes business rules
export const AUTH_CONFIG = {
  maxLoginAttempts: 3,
  accountLockDuration: 30 * 60,
  passwordMinLength: 8
} as const;
```

**2. Spec Enables TDD**
```typescript
// Test directly from spec
describe('Auth Business Rules', () => {
  it('should lock account after 3 failed attempts', () => {
    expect(attempts).toBe(AUTH_CONFIG.maxLoginAttempts);
  });
});
```

**3. DDD Makes Testing Easy**
```
Domain Layer (Config + Business Logic)
├── No external dependencies → Easy to test
├── Pure functions → Predictable
└── Config-driven → Clear specs

Features Layer
├── Only coordinates Domain → Easy to mock
└── UI separated → Easy to test

UI Layer
└── Presentational only → Easy to test
```

## Three-Pillar Architecture

### Config-Driven
Externalize business rules, not just magic numbers:

```typescript
// ❌ Hidden spec
if (attempts > 3) { lockAccount(1800000); }

// ✅ Spec as config
export const AUTH_SPEC = {
  maxLoginAttempts: 3,
  accountLockDuration: 30 * 60 * 1000
} as const;

if (attempts > AUTH_SPEC.maxLoginAttempts) {
  lockAccount(AUTH_SPEC.accountLockDuration);
}
```

### TDD
Write tests from config specs:

```typescript
// Red: Test from spec
it('should reject files larger than max size', () => {
  const largeFile = createFile(UPLOAD_SPEC.maxFileSize + 1);
  expect(validator.validate(largeFile)).toBe(false);
});

// Green: Implement
validate(file: File): boolean {
  return file.size <= UPLOAD_SPEC.maxFileSize;
}
```

### DDD
Layer separation enables independent testing:

```typescript
// Domain Layer - No dependencies, pure functions
export class AuthDomain {
  static validatePassword(password: string): ValidationResult {
    if (password.length < AUTH_CONFIG.passwordMinLength) {
      return { valid: false, error: 'Too short' };
    }
    return { valid: true };
  }
}

// Features Layer - Coordinates domain only
export class LoginComponent {
  private authDomain = inject(AuthDomain);
  login() {
    const result = this.authDomain.validatePassword(this.password);
  }
}

// UI Layer - Presentational only
export class PasswordInputComponent {
  @Input() error?: string;
}
```

## Complete Workflow

```
Requirements
  ↓
Config (Spec)
  ↓
Test (Red)
  ↓
Domain Implementation (Green)
  ↓
Features Layer (DDD)
  ↓
UI Layer (DDD)
  ↓
All Tests Pass
```

## Development Principles

**Config First**
1. Write Config (define spec)
2. Write Tests from Config (TDD Red)
3. Implement Domain (TDD Green)
4. Implement Features (DDD)
5. Implement UI (DDD)

**Test Coverage**
- Domain Layer: 95%+
- Features Layer: 80%+
- UI Layer: 60%+

**Layer Rules**
- Domain: No external dependencies
- Features: Depends on Domain only
- UI: Input/Output only
- Module boundaries: ESLint enforced

## Other Preferences

**Simplicity > Complexity**
- Complete in ≤3 steps
- Natural language triggers
- Template assembly over from-scratch

**Automation > Manual**
- Automate if done 3+ times
- Skills auto-trigger
- Commands execute quickly

**Practical > Perfect**
- Done > Perfect
- Use templates, optimize later
- MIGRATE, DON'T INNOVATE

## Documentation Style

Prefer: Tables > Text | Before/After > Explanation | Lists > Paragraphs | Examples > Theory | Diagrams > Plain text
