---
name: test-coverage-builder
description: Build comprehensive test suite for MXSecurity modules to achieve 95% coverage target
---

# Test Coverage Builder

## Auto-activation Triggers
- Missing `.spec.ts` files
- User says: "add tests", "write tests"
- User says: "improve test coverage"
- `nx test` shows low coverage

## Current Status

**MXSecurity Test Metrics**:
- Total files: 604
- Test files: 36
- Coverage: **5.9%**
- Target: **95%**

## Build Strategy

### Priority Levels

**Priority 1: Domain Layer (95%+ target)**
```bash
libs/mxsecurity/{module}/domain/src/lib/
├── *.service.ts        → *.service.spec.ts
├── *.store.ts          → *.store.spec.ts
├── models/*.ts         → models/*.spec.ts (optional)
└── config/*.ts         → config/*.spec.ts (optional)
```

**Priority 2: Features Layer (80%+ target)**
```bash
libs/mxsecurity/{module}/features/src/lib/
├── *.component.ts      → *.component.spec.ts
└── dialogs/*.ts        → dialogs/*.spec.ts
```

**Priority 3: UI Layer (60%+ target)**
```bash
libs/mxsecurity/{module}/ui/src/lib/
└── *.component.ts      → *.component.spec.ts
```

## Test Templates

### Template 1: Service Tests (Domain)

```typescript
// {module}.service.spec.ts
import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting, HttpTestingController } from '@angular/common/http/testing';
import { EntityService } from './entity.service';

describe('EntityService', () => {
  let service: EntityService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        EntityService,
        provideHttpClient(),
        provideHttpClientTesting()
      ]
    });

    service = TestBed.inject(EntityService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  describe('API Contracts', () => {
    it('should fetch entities from correct endpoint', () => {
      const mockData = [{ id: '1', name: 'Test' }];

      service.getEntities().subscribe(data => {
        expect(data).toEqual(mockData);
      });

      const req = httpMock.expectOne('/api/v1/entities');
      expect(req.request.method).toBe('GET');
      req.flush(mockData);
    });

    it('should create entity with POST', () => {
      const newEntity = { name: 'New Entity' };

      service.createEntity(newEntity).subscribe();

      const req = httpMock.expectOne('/api/v1/entities');
      expect(req.request.method).toBe('POST');
      expect(req.request.body).toEqual(newEntity);
      req.flush({ id: '1', ...newEntity });
    });
  });

  describe('Error Handling', () => {
    it('should handle 404 error', () => {
      service.getEntities().subscribe({
        next: () => fail('should have failed'),
        error: (error) => {
          expect(error.status).toBe(404);
        }
      });

      const req = httpMock.expectOne('/api/v1/entities');
      req.flush('Not Found', { status: 404, statusText: 'Not Found' });
    });
  });
});
```

### Template 2: SignalStore Tests

```typescript
// {module}.store.spec.ts
import { TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting, HttpTestingController } from '@angular/common/http/testing';
import { EntityStore } from './entity.store';
import { patchState } from '@ngrx/signals';

describe('EntityStore', () => {
  let store: InstanceType<typeof EntityStore>;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      providers: [
        EntityStore,
        provideHttpClient(),
        provideHttpClientTesting()
      ]
    });

    store = TestBed.inject(EntityStore);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify();
  });

  describe('Initial State', () => {
    it('should start with empty entities', () => {
      expect(store.entities()).toEqual([]);
    });

    it('should start with loading false', () => {
      expect(store.loading()).toBe(false);
    });

    it('should start with no error', () => {
      expect(store.error()).toBeNull();
    });
  });

  describe('Business Logic', () => {
    it('should set loading state during API call', () => {
      expect(store.loading()).toBe(false);

      store.loadEntities();
      expect(store.loading()).toBe(true);

      const req = httpMock.expectOne('/api/v1/entities');
      req.flush([{ id: '1', name: 'Test' }]);

      expect(store.loading()).toBe(false);
    });

    it('should update entities after successful load', () => {
      const mockData = [{ id: '1', name: 'Test' }];

      store.loadEntities();
      httpMock.expectOne('/api/v1/entities').flush(mockData);

      expect(store.entities()).toEqual(mockData);
    });

    it('should handle error correctly', () => {
      store.loadEntities();

      const req = httpMock.expectOne('/api/v1/entities');
      req.flush('Error', { status: 500, statusText: 'Server Error' });

      expect(store.error()).toBeTruthy();
      expect(store.entities()).toEqual([]);
    });
  });

  describe('Computed Values', () => {
    it('should compute hasEntities correctly', () => {
      expect(store.hasEntities()).toBe(false);

      patchState(store, { entities: [{ id: '1', name: 'Test' }] });

      expect(store.hasEntities()).toBe(true);
    });
  });
});
```

### Template 3: Component Tests (Features)

```typescript
// {module}.component.spec.ts
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';
import { EntityComponent } from './entity.component';
import { EntityStore } from '../domain/entity.store';
import { patchState } from '@ngrx/signals';

describe('EntityComponent', () => {
  let component: EntityComponent;
  let fixture: ComponentFixture<EntityComponent>;
  let store: InstanceType<typeof EntityStore>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        EntityComponent,
        NoopAnimationsModule
      ],
      providers: [
        EntityStore,
        provideHttpClient(),
        provideHttpClientTesting()
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(EntityComponent);
    component = fixture.componentInstance;
    store = TestBed.inject(EntityStore);
  });

  describe('Component Initialization', () => {
    it('should create', () => {
      expect(component).toBeTruthy();
    });

    it('should load entities on init', () => {
      const spy = jest.spyOn(store, 'loadEntities');

      fixture.detectChanges(); // triggers ngOnInit

      expect(spy).toHaveBeenCalled();
    });
  });

  describe('User Interactions', () => {
    it('should handle delete button click', () => {
      const spy = jest.spyOn(store, 'deleteEntity');
      const mockEntity = { id: '1', name: 'Test' };

      component.handleDelete(mockEntity);

      expect(spy).toHaveBeenCalledWith('1');
    });

    it('should open dialog on add button click', () => {
      // Test dialog opening logic
    });
  });

  describe('Template Rendering', () => {
    it('should display loading spinner when loading', () => {
      patchState(store, { loading: true });
      fixture.detectChanges();

      const spinner = fixture.nativeElement.querySelector('mat-spinner');
      expect(spinner).toBeTruthy();
    });

    it('should display entities when loaded', () => {
      patchState(store, {
        entities: [
          { id: '1', name: 'Entity 1' },
          { id: '2', name: 'Entity 2' }
        ]
      });
      fixture.detectChanges();

      const rows = fixture.nativeElement.querySelectorAll('mat-row');
      expect(rows.length).toBe(2);
    });

    it('should display error message when error occurs', () => {
      patchState(store, { error: 'Failed to load' });
      fixture.detectChanges();

      const error = fixture.nativeElement.querySelector('.error-message');
      expect(error?.textContent).toContain('Failed to load');
    });
  });
});
```

### Template 4: UI Component Tests

```typescript
// ui-component.spec.ts
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { EntityCardComponent } from './entity-card.component';

describe('EntityCardComponent (UI)', () => {
  let component: EntityCardComponent;
  let fixture: ComponentFixture<EntityCardComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [EntityCardComponent]
    }).compileComponents();

    fixture = TestBed.createComponent(EntityCardComponent);
    component = fixture.componentInstance;
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });

  it('should display entity data', () => {
    component.entity = { id: '1', name: 'Test Entity' };
    fixture.detectChanges();

    const name = fixture.nativeElement.querySelector('.entity-name');
    expect(name.textContent).toContain('Test Entity');
  });

  it('should emit click event', () => {
    const spy = jest.fn();
    component.entityClick.subscribe(spy);
    component.entity = { id: '1', name: 'Test' };

    component.onClick();

    expect(spy).toHaveBeenCalledWith({ id: '1', name: 'Test' });
  });
});
```

## Batch Test Generation

### Generate Tests for Entire Module

```bash
# Find files missing tests
find libs/mxsecurity/{module}/domain -name "*.ts" ! -name "*.spec.ts" ! -name "index.ts"

# Generate spec for each file using test templates above
```

### Run Tests

```bash
# Single file test
pnpm nx test mxsecurity-{module}-domain --testFile=entity.service.spec.ts

# Full library test
pnpm nx test mxsecurity-{module}-domain

# Coverage report
pnpm nx test mxsecurity-{module}-domain --coverage

# Watch mode
pnpm nx test mxsecurity-{module}-domain --watch
```

## Coverage Targets

### Domain Layer (95%+)

**Must Test**:
- ✅ All API service methods
- ✅ All Store state changes
- ✅ All business logic methods
- ✅ Error handling paths
- ✅ Data transformation logic

**Optional**:
- Models (simple interfaces)
- Config files (pure objects)

### Features Layer (80%+)

**Must Test**:
- ✅ Component initialization
- ✅ User event handlers
- ✅ Store integration
- ✅ Dialog open/close logic
- ✅ Form validation

**Optional**:
- Template rendering details
- CSS class bindings

### UI Layer (60%+)

**Must Test**:
- ✅ Input data rendering
- ✅ Output event emission
- ✅ Component creation

**Optional**:
- Styling details
- Animation states

## Test Checklist

Each test file should include:

- [ ] ✅ TestBed setup with all dependencies
- [ ] ✅ beforeEach initialization
- [ ] ✅ afterEach cleanup (for HttpTestingController)
- [ ] ✅ describe blocks for logical grouping
- [ ] ✅ Clear test descriptions (it should...)
- [ ] ✅ AAA pattern (Arrange, Act, Assert)
- [ ] ✅ Mock external dependencies
- [ ] ✅ Test both success and error paths

## Quick Commands

```bash
# View coverage report
pnpm nx test mxsecurity-{module}-domain --coverage --coverageReporters=html
open coverage/libs/mxsecurity/{module}/domain/index.html

# Run only failed tests
pnpm nx test mxsecurity-{module}-domain --onlyFailures

# Update snapshots
pnpm nx test mxsecurity-{module}-domain --updateSnapshot
```
