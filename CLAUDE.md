# CLAUDE.md - Global Development Configuration

## Critical Security Rules

### Forbidden Operations
- `rm -rf` or recursive deletions
- `sudo rm` or elevated file operations
- `chmod 777` or permission modifications
- Database drops without confirmation
- Production deployments without approval
- `curl`/`wget` to untrusted domains
- Package installs without verification

### Safety Requirements
- Use git before destructive operations
- Explicit confirmation for file deletions
- Never commit secrets, API keys, credentials
- Environment variables for sensitive config

## System Time Requirements

### Always Use Current System Time
- Reference current year (2025) in searches for latest information
- Include timestamps in all logging and operations
- Validate data freshness against current time
- Search with time context: "TypeScript 2025 best practices"
- Prioritize current year documentation over outdated versions

## AI Assistant Guidelines

### Critical Instructions
- **NEVER commit automatically** - always ask permission
- Apply RADIO pattern for complex features
- Challenge poor practices respectfully but firmly
- Apply TDD, DDD, Config-driven principles consistently
- Prioritize code quality and security over speed

### Development Flow
1. Requirements Assessment → 2. Architecture Design → 3. TDD Implementation → 4. Incremental Delivery → 5. Optimization

## RADIO Development Pattern

### Core Workflow
- **R**equirements Assessment: Evaluate and prioritize features
- **A**rchitecture Design: Plan domain structure and test specs
- **D**evelopment Implementation: TDD Red-Green-Refactor
- **I**ncremental Delivery: Progressive feature delivery
- **O**ptimization & Feedback: Refine based on results

### Complex Project Strategy
- Break large refactors into small, stable commits
- Each phase must have rollback capability
- Use feature flags for version switching
- Maintain working state at every increment

## Test-Driven Development (Strategic)

### RADIO-DDD-TDD Pattern
Integration of RADIO workflow, DDD architecture, and strategic testing for maximum value with minimal complexity.

### TDD Workflow
1. **Red**: Write failing test for important behavior first
2. **Green**: Write minimal code to pass the test
3. **Refactor**: Improve design while keeping tests green

### Smart Testing Strategy

#### Test by Business Risk and Value
```typescript
// Priority 1: Critical Business Rules (Domain Layer)
describe('AuthDomain', () => {
  it('should enforce business rule: only active users can login', () => {
    // Test core business logic that affects security/money/data
    const user = new User({ status: 'inactive' });
    expect(() => user.authenticate()).toThrow('User not active');
  });
});

// Priority 2: Important User Workflows (Application Layer)
describe('LoginUseCase', () => {
  it('should complete authentication workflow successfully', () => {
    // Test complete business processes
    const result = loginUseCase.execute(validCredentials);
    expect(result.success).toBe(true);
    expect(result.redirectTo).toBe('/dashboard');
  });
});

// Priority 3: Integration Contracts (Infrastructure Layer)
describe('AuthRepository', () => {
  it('should maintain data integrity during user operations', () => {
    // Test critical integration points only
    const user = repository.save(userData);
    expect(user.id).toBeDefined();
    expect(user.hashedPassword).not.toBe(userData.password);
  });
});
```

#### DDD Layer Testing Rules

**Domain Layer** - Focus on Business Rules
- Test all business invariants and domain rules
- Test domain events and aggregate behavior
- Skip getters/setters, focus on business logic
- 100% coverage of business rules (not code lines)

**Application Layer** - Focus on Workflows
- Test complete use case flows
- Test cross-aggregate coordination
- Test important error scenarios
- Skip parameter validation details

**Infrastructure Layer** - Focus on Contracts
- Test external system integration contracts
- Test data mapping correctness
- Test critical error recovery
- Skip framework internal logic

**Presentation Layer** - Focus on User Value
- Test important user interaction flows
- Test critical state changes
- Test key error displays
- Skip UI styling details

### Testing Priorities

#### Critical (Must Test)
- Business rules affecting security, money, or data integrity
- User authentication and authorization flows
- Legacy behavior preservation (for migrations)
- API contracts and data consistency

#### Important (Should Test)
- Main user workflows and happy paths
- Error handling for common scenarios
- Integration with external systems
- Performance-critical operations

#### Optional (Can Skip)
- Edge cases with minimal business impact
- UI styling and animation details
- Non-critical validation messages
- Framework boilerplate code

### Migration-Safe Testing
```typescript
// Behavior Preservation (Critical for migrations)
describe('Legacy Compatibility', () => {
  it('should maintain exact same behavior as legacy system', () => {
    // Side-by-side comparison with original implementation
    const legacyResult = legacySystem.processLogin(credentials);
    const newResult = newSystem.processLogin(credentials);
    expect(newResult).toDeepEqual(legacyResult);
  });
});

// Contract Testing
describe('API Contract', () => {
  it('should maintain same response format', () => {
    // Ensure API contracts remain unchanged
    const response = api.login(credentials);
    expect(response).toMatchSchema(expectedApiSchema);
  });
});
```

### Coverage Philosophy
Focus on **behavior coverage** rather than **code coverage**:
- Test what matters to users and business
- Avoid testing implementation details
- Use triangulation: minimal tests for maximum confidence
- Prioritize test maintainability over exhaustiveness

### Test Immutability Rule
Never modify approved tests to make new code pass - this indicates design problems, not test problems.

## Domain-Driven Design Architecture

### Layer Structure
```
src/
├── domain/           # Pure business logic (NO dependencies)
├── application/      # Use cases and workflows
├── infrastructure/   # External adapters
└── presentation/     # UI components
```

### Dependency Rules
- Domain layer: NO external dependencies
- Application: depends only on domain
- Infrastructure: implements domain interfaces
- Presentation: depends on application only
- All dependencies point inward toward domain

## TypeScript Standards (5.3+)

### Type Safety Requirements
```typescript
// Preferred patterns
interface UserData {
  readonly id: string;
  email: string;
  createdAt: Date;
  preferences?: UserPreferences;
}

// Explicit error handling
type Result<T, E = Error> =
  | { readonly success: true; data: T }
  | { readonly success: false; error: E };

// No any types, interface over type for objects
const fetchUser = async (id: string): Promise<UserData | null> => {
  using resource = new DatabaseConnection();
  return await resource.query('users', { id });
};
```

### Code Quality Rules
- No magic numbers (use named constants)
- No !important in CSS (fix specificity)
- Pure functions preferred
- English only in code/comments
- Explicit error handling

## Git & Monorepo Standards

### Conventional Commits
```bash
<type>(app-name): <description>

# Examples
feat(web-app): add user authentication
fix(api-server): handle CORS preflight
refactor(ui-components): extract Button component
```

### Commit Types
- `feat`: New features | `fix`: Bug fixes | `refactor`: Code restructuring
- `test`: Testing | `docs`: Documentation | `chore`: Maintenance
- `perf`: Performance | `ci`: CI/CD | `build`: Build system

### Branch Strategy (GitHub Flow)
- Main branch: Always deployable, protected
- Feature branches: `feature/app-name/description`
- No direct push to main, PR reviews required

## Visual Documentation Requirements

### Use Mermaid for Complex Content
```mermaid
# Architecture Flow
flowchart TD
    A[User Request] --> B[Auth]
    B --> C[Business Logic]
    C --> D[Database]

# Sequence for Complex Features
sequenceDiagram
    participant U as User
    participant A as API
    U->>A: Request
    A-->>U: Response
```

### When to Use Mermaid
- Complexity > 3 steps
- Multiple actors/systems
- Decision trees with branches
- Data flow through layers
- Time-dependent sequences

## Configuration-Driven Development

### Business Logic Externalization
```typescript
// Business rules in config
const VALIDATION_RULES = {
  email: { required: true, pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/ },
  password: { minLength: 8, requireSpecialChar: true }
} as const;

// Feature flags
const FEATURES = {
  enableNewDashboard: process.env.NODE_ENV === 'development',
  maxFileUploadSize: 10 * 1024 * 1024 // 10MB
} as const;
```

## Tech Stack Preferences (2025)

### Core Technologies
- **Frontend**: React 18+, Next.js 15+, TypeScript 5.3+
- **Styling**: Tailwind CSS 3.4+, CSS Modules
- **State**: Zustand, Redux Toolkit, TanStack Query
- **Backend**: Node.js, tRPC, Prisma ORM
- **Testing**: Vitest, Playwright, React Testing Library
- **Tools**: Biome/ESLint, Prettier, Husky

### File Naming Conventions
- Components: `PascalCase.tsx` (UserProfile.tsx)
- Hooks: `camelCase.ts` (useUserData.ts)
- Utilities: `camelCase.ts` (formatCurrency.ts)
- Types: `PascalCase.types.ts` (User.types.ts)

## Claude Code Integration

### Package Manager Requirement
- **ALWAYS use pnpm, NEVER npm**
- Use `pnpm` for all package operations
- Use `pnpm run` for all script execution

### Common Commands
```bash
pnpm run dev         # Development server
pnpm run build       # Production build
pnpm run test        # Run tests
pnpm run lint        # Code quality check
pnpm run type-check  # TypeScript verification
pnpm install         # Install dependencies
pnpm add <package>   # Add new package
```

### Tool Permissions
- Allowed: `bash:pnpm *`, `bash:git *`, `read:**`, `edit:**`
- Denied: `bash:npm *`, `bash:rm -rf *`, `bash:sudo *`, `bash:chmod 777 *`

### Subagent Usage
- Use `general-purpose` for complex multi-step tasks
- Launch agents in parallel when possible
- Use specialized agents for domain-specific work

---
**Methodology**: RADIO + TDD + DDD + Config-Driven | **Version**: 2025.1.0