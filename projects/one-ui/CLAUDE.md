# MXSecurity Migration to OneUI

## Project Context

### Legacy Project
- **Source**: Legacy MXSecurity project (separate repository)
- **Target**: OneUI monorepo at `/Users/luoziming/moxa/moxa-project/one-ui/`
- **Goal**: 100% feature parity migration, zero innovation
- **Principle**: MIGRATE, DON'T INNOVATE

### Migration Architecture
```
Legacy MXSecurity → OneUI Monorepo
├── apps/mxsecurity-web/          # Main application
└── libs/mxsecurity/              # Feature libraries
    ├── user-management/
    ├── dashboard/
    ├── security-policies/
    └── audit-logging/
```

## File Structure Translation

### Source → Target Mapping
```
LEGACY STRUCTURE                     → ONEUI STRUCTURE
src/components/auth/                 → libs/mxsecurity/user-management/ui/
src/services/auth.service.ts         → libs/mxsecurity/user-management/domain/
src/pages/Dashboard/                 → libs/mxsecurity/dashboard/features/
src/pages/UserManagement/            → libs/mxsecurity/user-management/features/
src/guards/auth.guard.ts             → apps/mxsecurity-web/src/app/guards/
src/interceptors/                    → apps/mxsecurity-web/src/app/interceptors/
src/shared/components/               → libs/mxsecurity/shared/ui/ or @one-ui/shared/ui
```

### Naming Convention Translation
```
LEGACY                               → ONEUI
LoginComponent                       → OneUiLoginBoxPageComponent
AuthService                          → AuthService (domain layer)
auth.guard.ts                        → auth.guard.ts (same, but in app)
user-management.module.ts            → shell/user-management.routes.ts
```

## OneUI Integration Points

### Architecture References
- **Authentication Pattern**: Copy from `apps/switch-web/src/app/guards/auth.guard.ts`
- **Module Structure**: Follow `libs/switch/login-page/` pattern
- **Routing**: Reference `apps/switch-web/src/app/app.routes.ts`
- **Shared Components**: Reuse `@one-ui/shared/ui`

### Module Boundary Rules
```
scope:mxsecurity → ['scope:mxsecurity', 'scope:shared']

libs/mxsecurity/user-management/
├── domain/      → ['type:util', 'type:domain-logic']
├── features/    → ['type:ui', 'type:domain-logic', 'type:util']
├── ui/         → ['type:util', 'type:domain-logic']
└── shell/      → ['type:feature', 'type:util', 'type:domain-logic']
```

## FormOXA UI Component Migration

### Component Translation Guide
```typescript
// LEGACY Angular Material → ONEUI FormOXA

// OLD: Angular Material Button
<button mat-raised-button color="primary">Login</button>

// NEW: FormOXA Button
<mx-button variant="primary" size="medium">Login</mx-button>

// OLD: Angular Material Form Field
<mat-form-field>
  <input matInput placeholder="Username" />
  <mat-error>Required field</mat-error>
</mat-form-field>

// NEW: FormOXA Input
<mx-input
  placeholder="Username"
  [error]="hasError"
  errorText="Required field">
</mx-input>

// OLD: Angular Material Select
<mat-select placeholder="Role">
  <mat-option value="admin">Admin</mat-option>
</mat-select>

// NEW: FormOXA Select
<mx-select
  placeholder="Role"
  [options]="roleOptions"
  [(value)]="selectedRole">
</mx-select>
```

### FormOXA Component Reference
```typescript
// Import FormOXA components
import {
  MxButtonComponent,
  MxInputComponent,
  MxSelectComponent,
  MxCheckboxComponent,
  MxRadioComponent,
  MxSwitchComponent,
  MxTabsComponent,
  MxCardComponent,
  MxDialogComponent
} from '@moxa/formoxa';

// Usage in standalone component
@Component({
  selector: 'one-ui-login-page',
  standalone: true,
  imports: [
    MxButtonComponent,
    MxInputComponent,
    MxCardComponent
  ],
  template: `...`
})
```

### UI Migration Checklist
- Replace all `mat-*` with `mx-*` components
- Update color schemes to FormOXA design tokens
- Replace Material icons with FormOXA icons
- Update spacing using FormOXA CSS custom properties
- Test responsive behavior with FormOXA breakpoints

## Transloco i18n Implementation

### Setup and Configuration
```typescript
// In app.config.ts or main.ts
import { provideTransloco } from '@jsverse/transloco';

export const appConfig: ApplicationConfig = {
  providers: [
    provideTransloco({
      config: {
        availableLangs: ['en', 'zh-TW'],
        defaultLang: 'en',
        fallbackLang: 'en',
        prodMode: !isDevMode()
      },
      loader: TranslocoHttpLoader
    })
  ]
};
```

### Translation File Structure
```
src/assets/i18n/
├── en.json                    # English translations
├── zh-TW.json                 # Traditional Chinese
└── [scope]/                   # Scoped translations (optional)
    ├── en.json
    └── zh-TW.json
```

### Translation Usage Patterns
```typescript
// Component with Transloco
@Component({
  selector: 'one-ui-login-page',
  standalone: true,
  imports: [TranslocoDirective],
  template: `
    <div *transloco="let t">
      <h1>{{ t('auth.login.title') }}</h1>
      <mx-button>{{ t('auth.login.submit') }}</mx-button>

      <!-- With parameters -->
      <p>{{ t('auth.welcome', { name: username }) }}</p>

      <!-- Pluralization -->
      <span>{{ t('auth.errors', { count: errorCount }) }}</span>
    </div>
  `
})
export class LoginPageComponent {}

// Service usage
export class AuthService {
  constructor(private transloco: TranslocoService) {}

  getErrorMessage(code: string): string {
    return this.transloco.translate(`auth.errors.${code}`);
  }
}
```

### Translation JSON Structure
```json
// en.json
{
  "auth": {
    "login": {
      "title": "Sign In",
      "username": "Username",
      "password": "Password",
      "submit": "Login",
      "forgotPassword": "Forgot Password?"
    },
    "errors": {
      "required": "This field is required",
      "invalidCredentials": "Invalid username or password",
      "sessionExpired": "Your session has expired"
    },
    "welcome": "Welcome back, {{name}}!"
  }
}

// zh-TW.json
{
  "auth": {
    "login": {
      "title": "登入",
      "username": "使用者名稱",
      "password": "密碼",
      "submit": "登入",
      "forgotPassword": "忘記密碼？"
    },
    "errors": {
      "required": "此欄位為必填",
      "invalidCredentials": "使用者名稱或密碼無效",
      "sessionExpired": "您的會話已過期"
    },
    "welcome": "歡迎回來，{{name}}！"
  }
}
```

## Project-Specific Commands

### Development
```bash
# Start MXSecurity app
nx serve mxsecurity-web

# Build with production config
nx build mxsecurity-web --configuration=production

# Run tests
nx test mxsecurity-web
nx test mxsecurity/user-management/domain
nx e2e mxsecurity-web-e2e
```

### Library Generation for MXSecurity
```bash
# Generate complete feature library
./scripts/nx-generate-lib.sh --scope mxsecurity --domain-name user-management --type all

# Generate specific library types
./scripts/nx-generate-lib.sh --scope mxsecurity --domain-name dashboard --type domain
./scripts/nx-generate-lib.sh --scope mxsecurity --domain-name security-policies --type features
./scripts/nx-generate-lib.sh --scope mxsecurity --domain-name audit-logging --type ui
```

### Quality Assurance
```bash
# Lint MXSecurity scope
./scripts/lint-changed-files.sh scope:mxsecurity

# Format code
pnpm nx format:write --uncommitted --parallel --skip-nx-cache

# Test with coverage
nx test mxsecurity-web --configuration=ci --code-coverage
```

## API Integration

### Development Configuration
```typescript
// apps/mxsecurity-web/src/environments/environment.ts
export const environment = {
  production: false,
  apiUrl: 'https://192.168.127.1:443/api',
  authEndpoint: '/v1/auth/login',
  systemInfoEndpoint: '/v1/system/info',
  wsUrl: 'wss://192.168.127.1:443/ws'
};
```

### Proxy Configuration
```json
// apps/mxsecurity-web/proxy.conf.json
{
  "/api/*": {
    "target": "https://192.168.127.1:443",
    "secure": false,
    "changeOrigin": true,
    "logLevel": "debug"
  }
}
```

### HTTP Interceptor Pattern
```typescript
// apps/mxsecurity-web/src/app/interceptors/auth.interceptor.ts
@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    const token = this.authService.getToken();
    if (token) {
      req = req.clone({
        setHeaders: {
          Authorization: `Bearer ${token}`
        }
      });
    }
    return next.handle(req);
  }
}
```

## Testing Strategy

### Unit Testing Pattern
```typescript
// Domain service test
describe('AuthService', () => {
  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [AuthService]
    });
  });

  it('should authenticate user with valid credentials', fakeAsync(() => {
    // Arrange
    const credentials = { username: 'admin', password: 'password' };

    // Act
    service.login(credentials).subscribe(result => {
      // Assert
      expect(result.success).toBe(true);
    });

    tick();
  }));
});
```

### E2E Testing with Playwright
```typescript
// apps/mxsecurity-web-e2e/src/login.spec.ts
import { test, expect } from '@playwright/test';

test('should login successfully with valid credentials', async ({ page }) => {
  await page.goto('/login');

  await page.fill('[data-cy=username]', 'admin');
  await page.fill('[data-cy=password]', 'password');
  await page.click('[data-cy=login-button]');

  await expect(page).toHaveURL('/dashboard');
});
```

## Migration Workflow Hook

### Trigger Keywords
- `搬遷`, `migration`, `migrate`

### Auto-generated Checklist
Creates `migration-checklist-[timestamp].md` with:

```markdown
Phase 1: Legacy Analysis
  Study original implementation structure
  Document exact behaviors and features
  Define migration scope (no new features)

Phase 2: Architecture Setup
  Choose correct location (apps vs libs)
  Follow existing patterns (e.g., switch-web)
  Standard component structure (HTML/SCSS/TS)

Phase 3: Implementation
  Complete TypeScript interfaces
  Use FormOXA design system
  Implement i18n with Transloco
  Exact behavior replication

Phase 4: Quality Assurance
  Side-by-side comparison
  Test all scenarios
  Code standards (English only, no any types)
```

## Critical Migration Rules

### Code Standards
- **TypeScript**: Strict mode, no `any` types
- **Components**: Standalone with OnPush change detection
- **Naming**: `one-ui-` prefix for all components
- **Architecture**: Follow DDD layers strictly
- **Testing**: Maintain 100% test coverage for domain layer

### File Creation Rules
- **NEVER** create files unless absolutely necessary
- **ALWAYS** prefer editing existing files
- **NEVER** create documentation unless explicitly requested
- **FOLLOW** existing patterns from switch-web app

### Migration Principles
1. **MIGRATE, DON'T INNOVATE** - Copy exact functionality
2. **Side-by-side comparison** - Test against original
3. **Incremental delivery** - One feature at a time
4. **Zero regression** - Maintain all existing behaviors