---
description: Quickly create complete CRUD page using common-table
---

# Usage

```bash
/new-crud {entity-name}
```

**Examples**:
```bash
/new-crud firmware
/new-crud device-group
/new-crud user-profile
```

---

# Task

Create a complete CRUD page component using MXSecurity's `common-table` component.

## Steps

### 1. Gather Information

**Required** (already provided):
- Entity name: `{entity-name}`

**Ask user**:
- Domain module name (e.g., `system`, `management`, `device-deployment`)
- What columns are needed? (e.g., name, status, version, createdAt)
- What features are required?
  - [ ] Selectable (checkbox)
  - [ ] Editable (edit button)
  - [ ] Create/Delete operations
  - [ ] Search functionality

### 2. Read Templates

Read template files from:
- `.claude/templates/crud-table/component.ts.template`
- `.claude/templates/crud-table/component.html.template`

### 3. Replace Variables

Replace template variables with actual values:

| Variable | Conversion | Example |
|----------|-----------|---------|
| `{{EntityName}}` | PascalCase | `firmware` → `Firmware` |
| `{{entity-name}}` | kebab-case | User input |
| `{{domain-name}}` | kebab-case | User response |

**PascalCase conversion examples**:
- `firmware` → `Firmware`
- `device-group` → `DeviceGroup`
- `user-profile` → `UserProfile`

### 4. Adjust TableColumns

Generate tableColumns based on user-provided fields:

```typescript
protected readonly tableColumns: TableColumn[] = [
  { key: SELECT_COLUMN_KEY },
  { key: EDIT_COLUMN_KEY },
  { key: 'name', header: 'pages.{{domain-name}}.{{entity-name}}.name' },
  { key: 'status', header: 'pages.{{domain-name}}.{{entity-name}}.status' },
  // ... add more columns based on user input
];
```

### 5. Generate Files

Write the replaced content to:

```
libs/mxsecurity/{{domain-name}}/features/src/lib/{{entity-name}}/{{entity-name}}.component.ts
libs/mxsecurity/{{domain-name}}/features/src/lib/{{entity-name}}/{{entity-name}}.component.html
```

### 6. Provide Next Steps

Tell user what's still needed:

**Domain Layer (Required)**:
```typescript
// libs/mxsecurity/{{domain-name}}/domain/src/lib/{{entity-name}}.model.ts
export interface {{EntityName}} {
  id: string;
  name: string;
  // ... other fields
}

// libs/mxsecurity/{{domain-name}}/domain/src/lib/{{entity-name}}-api.service.ts
@Injectable({ providedIn: 'root' })
export class {{EntityName}}ApiService {
  getAll(): Observable<{{EntityName}}[]> { ... }
  create(data: Partial<{{EntityName}}>): Observable<{{EntityName}}> { ... }
  update(id: string, data: Partial<{{EntityName}}>): Observable<{{EntityName}}> { ... }
  delete(ids: string[]): Observable<void> { ... }
}
```

**Dialog Component (Optional)**:
```bash
/new-dialog {{entity-name}}-dialog
```

**i18n Keys**:
```json
{
  "menu.{{entity-name}}": "{{EntityName}}",
  "pages.{{domain-name}}.{{entity-name}}.name": "Name",
  "pages.{{domain-name}}.{{entity-name}}.status": "Status"
}
```

**Routes**:
```typescript
// libs/mxsecurity/{{domain-name}}/shell/src/lib/routes.ts
{
  path: '{{entity-name}}',
  loadComponent: () =>
    import('@one-ui/mxsecurity/{{domain-name}}/features').then(
      (m) => m.{{EntityName}}Component
    )
}
```

## Output Format

After completion, report to user:

```markdown
✅ CRUD page created: `{{entity-name}}`

📦 Generated files:
- libs/mxsecurity/{{domain-name}}/features/src/lib/{{entity-name}}/{{entity-name}}.component.ts
- libs/mxsecurity/{{domain-name}}/features/src/lib/{{entity-name}}/{{entity-name}}.component.html

📋 Next steps (Required):

1. **Create Domain Layer**:
   ```bash
   # Model
   libs/mxsecurity/{{domain-name}}/domain/src/lib/{{entity-name}}.model.ts

   # API Service
   libs/mxsecurity/{{domain-name}}/domain/src/lib/{{entity-name}}-api.service.ts
   ```

2. **Create Dialog** (if Create/Edit needed):
   ```bash
   /new-dialog {{entity-name}}-dialog
   ```

3. **Add i18n Keys**:
   ```json
   "menu.{{entity-name}}": "{{EntityName}}",
   "pages.{{domain-name}}.{{entity-name}}.name": "Name"
   ```

4. **Add Routes**:
   ```typescript
   { path: '{{entity-name}}', loadComponent: ... }
   ```

5. **Test**:
   ```bash
   pnpm nx serve mxsecurity-web
   ```

🎯 Reference example:
- libs/mxsecurity/system/features/src/lib/user-account/
```

---

# Notes

- Ask user for information concisely and clearly
- Generated code must follow project coding style
- Provide clear next step guidance
- If user doesn't provide domain-name, ask once
- If user doesn't specify columns, use defaults: `name`, `status`, `createdAt`
