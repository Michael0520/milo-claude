---
name: component-implementer
description: Implement unfinished MXSecurity components by extracting logic from legacy code comments
---

# Component Implementer

## Auto-activation Triggers
- Sees `TODO: Implement component logic`
- User says: "implement {component-name}"
- User says: "complete {component-name} component"
- File has large legacy code comments but empty implementation

## Implementation Workflow

### Step 1: Analyze Legacy Code Comments

**Read file** and find Legacy Code block:

```typescript
// ================================================================================
// LEGACY CODE - Reference Implementation
// ================================================================================
// [Complete legacy implementation here]
// ================================================================================
```

**Extract Key Information**:
1. ✅ Component's @ViewChild and template references
2. ✅ Injected services
3. ✅ Component state (properties)
4. ✅ Lifecycle hooks (ngOnInit, ngAfterViewInit, ngOnDestroy)
5. ✅ Methods and business logic
6. ✅ Event handlers
7. ✅ API calls

### Step 2: Plan Modern Rewrite

**Conversion Table**:

| Legacy Pattern | Modern Angular 20 Pattern |
|----------------|--------------------------|
| `constructor()` injection | `inject()` function |
| `BehaviorSubject` / `Subject` | Signals + `toSignal()` |
| `@ViewChild(MatPaginator)` | `viewChild()` signal |
| `ngOnInit()` API calls | `rxMethod()` or `effect()` |
| `combineLatest()` + `map()` | `computed()` |
| Manual subscriptions | `toSignal()` + auto cleanup |
| `MatTableDataSource` | Signal-based data |

### Step 3: TDD Implementation

**Write tests first**:

```typescript
// {component-name}.component.spec.ts
describe('ComponentImplementer: {ComponentName}', () => {
  describe('Legacy Behavior Compatibility', () => {
    it('should initialize with empty state', () => {
      expect(component.data()).toEqual([]);
    });

    it('should load data on init', () => {
      const spy = jest.spyOn(service, 'getData');
      component.ngOnInit();
      expect(spy).toHaveBeenCalled();
    });
  });

  describe('User Interactions', () => {
    it('should handle selection changes', () => {
      // Based on legacy implementation
    });
  });
});
```

**Implementation Steps**:

1. **Define Signals**:
```typescript
// State signals
protected readonly data = signal<EntityType[]>([]);
protected readonly loading = signal(false);
protected readonly error = signal<string | null>(null);
protected readonly selectedItems = signal<EntityType[]>([]);
```

2. **Inject Services**:
```typescript
private readonly service = inject(EntityService);
private readonly snackBar = inject(SnackBarService);
private readonly dialog = inject(MatDialog);
```

3. **ViewChild to viewChild()**:
```typescript
// Legacy
@ViewChild(MatPaginator) paginator: MatPaginator;

// Modern
protected readonly paginator = viewChild(MatPaginator);
```

4. **Implement Lifecycle**:
```typescript
ngOnInit() {
  this.loadData();
}

private loadData() {
  this.loading.set(true);
  this.service.getData()
    .pipe(takeUntilDestroyed(this.destroyRef))
    .subscribe({
      next: (data) => {
        this.data.set(data);
        this.loading.set(false);
      },
      error: (err) => {
        this.error.set(err.message);
        this.loading.set(false);
      }
    });
}
```

5. **Implement Methods**:
```typescript
// Extract business logic from legacy code
protected handleDelete(item: EntityType) {
  const dialogRef = this.dialog.open(ConfirmDialog);

  dialogRef.afterClosed()
    .pipe(takeUntilDestroyed(this.destroyRef))
    .subscribe((confirmed) => {
      if (confirmed) {
        this.deleteItem(item);
      }
    });
}
```

### Step 4: Update Template

**Extract from legacy HTML comments**:

```html
<!-- Legacy template in comments -->
<!-- <mat-table [dataSource]="dataSource"> ... </mat-table> -->

<!-- Modern implementation -->
<mat-table [dataSource]="data()">
  <ng-container matColumnDef="name">
    <mat-header-cell *matHeaderCellDef>Name</mat-header-cell>
    <mat-cell *matCellDef="let item">{{ item.name }}</mat-cell>
  </ng-container>
</mat-table>
```

### Step 5: Remove TODO Comments

**After completion**:
1. ✅ Remove `// TODO: Implement component logic`
2. ✅ Keep legacy code comments for reference
3. ✅ Update Migration Tracking header
4. ✅ Run tests to ensure they pass
5. ✅ Run lint to ensure no errors

## Implementation Checklist

Complete a component by verifying:

- [ ] ✅ All legacy state converted to Signals
- [ ] ✅ All subscriptions use `takeUntilDestroyed()`
- [ ] ✅ All @ViewChild changed to `viewChild()`
- [ ] ✅ Use `inject()` instead of constructor injection
- [ ] ✅ OnPush change detection
- [ ] ✅ Test coverage ≥ 80%
- [ ] ✅ No ESLint errors
- [ ] ✅ No TypeScript errors
- [ ] ✅ Template uses Signal syntax `()`

## Common Component Patterns

### Pattern 1: Table with CRUD

```typescript
export class EntityListComponent implements OnInit {
  private readonly service = inject(EntityService);
  private readonly destroyRef = inject(DestroyRef);

  // State
  protected readonly entities = signal<Entity[]>([]);
  protected readonly loading = signal(false);
  protected readonly selection = signal<Entity[]>([]);

  // ViewChild
  protected readonly paginator = viewChild(MatPaginator);
  protected readonly sort = viewChild(MatSort);

  // Computed
  protected readonly hasSelection = computed(() =>
    this.selection().length > 0
  );

  ngOnInit() {
    this.loadEntities();
  }

  protected loadEntities() {
    this.loading.set(true);
    this.service.getAll()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (data) => {
          this.entities.set(data);
          this.loading.set(false);
        }
      });
  }

  protected handleDelete() {
    const selected = this.selection();
    // Delete logic
  }
}
```

### Pattern 2: Form Dialog

```typescript
export class EntityDialogComponent {
  private readonly fb = inject(FormBuilder);
  private readonly dialogRef = inject(MatDialogRef);

  protected readonly form = this.fb.group({
    name: ['', Validators.required],
    description: ['']
  });

  protected readonly isValid = toSignal(
    this.form.statusChanges.pipe(
      map(() => this.form.valid)
    )
  );

  protected submit() {
    if (this.form.valid) {
      this.dialogRef.close(this.form.value);
    }
  }
}
```

### Pattern 3: Tab Container

```typescript
export class EntityTabsComponent implements OnInit {
  protected readonly selectedTab = signal(0);

  protected readonly tabs = [
    { label: 'Overview', component: OverviewComponent },
    { label: 'Details', component: DetailsComponent }
  ];

  protected onTabChange(index: number) {
    this.selectedTab.set(index);
  }
}
```

## Important Notes

**Keep Legacy Code Comments**
```typescript
// ✅ Correct: Keep legacy code as reference
// ================================================================================
// LEGACY CODE - Reference Implementation
// ================================================================================
// [Complete legacy code]
// ================================================================================

// Modern implementation
export class ModernComponent { ... }
```

**Don't Mix Observable and Signal**
```typescript
// ❌ Wrong: Mixed usage
data$: Observable<Data[]>;
loading = signal(false);

// ✅ Correct: All Signals
data = toSignal(this.service.getData());
loading = signal(false);
```

**Auto-cleanup Subscriptions**
```typescript
// ✅ Use takeUntilDestroyed
private readonly destroyRef = inject(DestroyRef);

ngOnInit() {
  this.service.getData()
    .pipe(takeUntilDestroyed(this.destroyRef))
    .subscribe(...);
}
```
