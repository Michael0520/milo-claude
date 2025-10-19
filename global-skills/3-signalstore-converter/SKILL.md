---
name: signalstore-converter
description: Convert BehaviorSubject and RxJS state to @ngrx/signals SignalStore with modern patterns
---

# SignalStore Converter

## Auto-activation Triggers
- Sees `BehaviorSubject` needing conversion
- Sees `Subject` + `scan` state management
- Sees old NgRx Store needing modernization
- User says: "convert to SignalStore"

## Reference Implementation
**Always reference**: `libs/switch/*/domain/src/lib/*.store.ts`

## Conversion Patterns

### Pattern 1: BehaviorSubject → SignalStore

**Before (Legacy)**
```typescript
@Injectable()
export class UserService {
  private users$ = new BehaviorSubject<User[]>([]);
  private loading$ = new BehaviorSubject<boolean>(false);

  getUsers() {
    return this.users$.asObservable();
  }

  loadUsers() {
    this.loading$.next(true);
    this.http.get<User[]>('/api/users').subscribe(users => {
      this.users$.next(users);
      this.loading$.next(false);
    });
  }
}
```

**After (Modern)**
```typescript
// 1. Define State Interface
interface UserState {
  users: User[];
  loading: boolean;
  error: string | null;
}

// 2. Define Initial State
const initialState: UserState = {
  users: [],
  loading: false,
  error: null
};

// 3. Create SignalStore
export const UserStore = signalStore(
  { providedIn: 'root' },
  withState(initialState),
  withMethods((store, api = inject(UserApiService)) => ({
    loadUsers: queryMethod({
      store,
      observe: () => api.getUsers(),
      next: (users) => {
        patchState(store, { users });
      },
      error: (error: Error) => {
        patchState(store, { error: error.message });
      }
    })
  }))
);
```

### Pattern 2: Complex State with Computed

**Before**
```typescript
private users$ = new BehaviorSubject<User[]>([]);
private filter$ = new BehaviorSubject<string>('');

filteredUsers$ = combineLatest([this.users$, this.filter$]).pipe(
  map(([users, filter]) =>
    users.filter(u => u.name.includes(filter))
  )
);
```

**After**
```typescript
export const UserStore = signalStore(
  { providedIn: 'root' },
  withState({
    users: [] as User[],
    filter: ''
  }),
  withComputed(({ users, filter }) => ({
    filteredUsers: computed(() =>
      users().filter(u => u.name.includes(filter()))
    )
  })),
  withMethods((store) => ({
    setFilter: (filter: string) => patchState(store, { filter })
  }))
);
```

### Pattern 3: API Calls with Error Handling

**After (Complete Example)**
```typescript
export const DataStore = signalStore(
  { providedIn: 'root' },
  withState(initialState),
  withMethods((store, api = inject(DataApiService)) => ({
    // Query (GET)
    loadData: queryMethod({
      store,
      observe: () => api.getData(),
      next: (data) => {
        patchState(store, {
          data,
          lastUpdated: new Date()
        });
      },
      error: (error: Error) => {
        patchState(store, { error: error.message });
      }
    }),

    // Mutation (POST/PUT/DELETE)
    saveData: mutationMethod({
      store,
      mutate: (payload: Data) => api.saveData(payload),
      next: (savedData) => {
        patchState(store, (state) => ({
          data: [...state.data, savedData]
        }));
      }
    })
  }))
);
```

## SignalStore API Quick Reference

### Core APIs
```typescript
signalStore()          // Create store
withState()            // Define initial state
withComputed()         // Derived state (computed values)
withMethods()          // Actions / mutations
patchState()           // Update state
queryMethod()          // GET-type API calls
mutationMethod()       // POST/PUT/DELETE-type calls
```

### Component Usage
```typescript
@Component({
  providers: [UserStore]  // Or provide in root
})
export class UserListComponent {
  readonly store = inject(UserStore);

  ngOnInit() {
    this.store.loadUsers();
  }

  // Template can use directly
  // {{ store.users() }}
  // {{ store.loading() }}
}
```

## Conversion Checklist

- [ ] ✅ Remove all `BehaviorSubject` / `Subject`
- [ ] ✅ Remove `asObservable()` pattern
- [ ] ✅ Use `withState` to define state
- [ ] ✅ Use `withComputed` instead of `combineLatest` + `map`
- [ ] ✅ Use `queryMethod` / `mutationMethod` for APIs
- [ ] ✅ Use `inject()` instead of constructor injection
- [ ] ✅ Template change from `| async` to `()`

## Common Mistakes

**❌ Mistake 1: Directly mutating state**
```typescript
store.users.push(newUser);  // ❌ Wrong!
```

**✅ Correct: Use patchState**
```typescript
patchState(store, (state) => ({
  users: [...state.users, newUser]
}));
```

**❌ Mistake 2: Mixing Observable and Signal**
```typescript
// ❌ Don't mix like this
store.users$.pipe(...)
```

**✅ Correct: Use Signal only**
```typescript
const users = store.users();  // Signal
effect(() => {
  console.log(store.users());  // Reactive
});
```
