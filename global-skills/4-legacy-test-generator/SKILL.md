---
name: legacy-test-generator
description: Generate compatibility tests ensuring new implementation matches legacy system behavior
---

# Legacy Test Generator

## Auto-activation Triggers
- Called by `mxsecurity-page-migrator` in TDD phase
- User says: "write tests to ensure behavior consistency"
- User says: "generate compatibility tests"

## Testing Strategy

### TDD Red-Green-Refactor

**Red**: Write failing tests (based on legacy behavior)
**Green**: Implement minimal code to pass tests
**Refactor**: Refactor to modern patterns while tests keep passing

## Test Templates

### Template 1: SignalStore Tests

```typescript
import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting, HttpTestingController } from '@angular/common/http/testing';
import { UserStore } from './user.store';

describe('UserStore - Legacy Compatibility', () => {
  let store: InstanceType<typeof UserStore>;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        UserStore,
        provideHttpClient(),
        provideHttpClientTesting()
      ]
    });

    store = TestBed.inject(UserStore);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  describe('Business Rules', () => {
    it('should maintain legacy behavior: users list starts empty', () => {
      expect(store.users()).toEqual([]);
    });

    it('should maintain legacy behavior: loading state during API call', () => {
      expect(store.loading()).toBe(false);

      store.loadUsers();
      expect(store.loading()).toBe(true);

      const req = httpMock.expectOne('/api/v1/users');
      req.flush([{ id: '1', name: 'Test' }]);

      expect(store.loading()).toBe(false);
    });
  });

  describe('API Contracts', () => {
    it('should call correct endpoint with same format', () => {
      store.loadUsers();

      const req = httpMock.expectOne('/api/v1/users');
      expect(req.request.method).toBe('GET');

      req.flush([]);
    });

    it('should handle API response same as legacy', () => {
      const mockResponse = [
        { id: '1', name: 'User 1', email: 'user1@test.com' }
      ];

      store.loadUsers();
      httpMock.expectOne('/api/v1/users').flush(mockResponse);

      expect(store.users()).toEqual(mockResponse);
    });
  });

  describe('Error Handling', () => {
    it('should handle 404 error same as legacy', () => {
      store.loadUsers();

      const req = httpMock.expectOne('/api/v1/users');
      req.flush('Not Found', { status: 404, statusText: 'Not Found' });

      expect(store.error()).toBeTruthy();
      expect(store.users()).toEqual([]);
    });
  });
});
```

### Template 2: Component Tests

```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { UserListComponent } from './user-list.component';
import { UserStore } from '../domain/user.store';

describe('UserListComponent - Legacy Compatibility', () => {
  let component: UserListComponent;
  let fixture: ComponentFixture<UserListComponent>;
  let store: InstanceType<typeof UserStore>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [UserListComponent],
      providers: [UserStore]
    }).compileComponents();

    fixture = TestBed.createComponent(UserListComponent);
    component = fixture.componentInstance;
    store = TestBed.inject(UserStore);
  });

  describe('User Interactions', () => {
    it('should load users on init (legacy behavior)', () => {
      const spy = jest.spyOn(store, 'loadUsers');

      fixture.detectChanges();  // ngOnInit

      expect(spy).toHaveBeenCalled();
    });

    it('should display users same format as legacy', () => {
      patchState(store, {
        users: [{ id: '1', name: 'Test User' }]
      });

      fixture.detectChanges();

      const compiled = fixture.nativeElement;
      expect(compiled.textContent).toContain('Test User');
    });
  });
});
```

### Template 3: Business Rule Tests

```typescript
describe('Business Rules - Legacy Compatibility', () => {
  describe('Authentication Rules', () => {
    it('should lock account after 3 failed attempts (legacy rule)', () => {
      const user = { loginAttempts: 3, status: 'active' };

      const result = checkAccountStatus(user);

      expect(result.locked).toBe(true);
      expect(result.lockDuration).toBe(1800000); // 30 min
    });

    it('should allow admin bypass lock (legacy quirk)', () => {
      const admin = {
        loginAttempts: 5,  // Exceeds limit
        role: 'admin'
      };

      const result = checkAccountStatus(admin);

      // Legacy quirk: admin never gets locked
      expect(result.locked).toBe(false);
    });
  });

  describe('Data Validation', () => {
    it('should trim whitespace from password (legacy quirk)', () => {
      const input = '  password123  ';

      const result = validatePassword(input);

      // Legacy auto-trims
      expect(result.value).toBe('password123');
    });
  });
});
```

## Test Coverage Targets

**Must Test (Critical)**
- ✅ Business rules affecting security/money/data
- ✅ User authentication and authorization flows
- ✅ API contracts and data consistency
- ✅ Legacy quirks and special behaviors

**Should Test (Important)**
- ✅ Main user workflows
- ✅ Common error scenario handling
- ✅ Important state changes

**Optional Tests**
- Edge cases (minimal business impact)
- UI style details
- Framework internal logic

**Target Coverage**
- Domain layer: 95%+
- Features layer: 80%+
- UI layer: 60%+

## Special Considerations

### Preserve Legacy Quirks
If legacy system has "weird but must preserve" behaviors:

```typescript
it('should preserve legacy quirk: case-insensitive email', () => {
  // Legacy system is case-insensitive
  // Unreasonable but must preserve for compatibility
  const user1 = findUserByEmail('TEST@example.com');
  const user2 = findUserByEmail('test@example.com');

  expect(user1?.id).toBe(user2?.id);
});
```

### Test Immutability Rule

**Never modify passing tests**
```typescript
// ❌ Wrong: Modify test to make new code pass
it('should return 3', () => {
  expect(calculate()).toBe(5);  // Changed to 5 to pass
});

// ✅ Correct: Modify code to make test pass
it('should return 3', () => {
  expect(calculate()).toBe(3);  // Test unchanged
});
```

If test fails, it means:
1. Code has problem → Fix code
2. Test written incorrectly → Check legacy behavior, fix test

Never change tests just to make them pass!
