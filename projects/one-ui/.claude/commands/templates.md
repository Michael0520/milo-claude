---
description: List all available code templates and commands
---

# MXSecurity Code Templates

## Quick Commands

### 1. CRUD Table Page

Create complete list page using `common-table`

```bash
/new-crud {entity-name}
```

**Examples**:
```bash
/new-crud firmware        # Create firmware list page
/new-crud device-group    # Create device-group list page
```

**Includes**:
- ✅ common-table with sorting & pagination
- ✅ Row selection (checkbox)
- ✅ Edit button
- ✅ Add / Delete / Refresh buttons
- ✅ Loading state
- ✅ CRUD API integration
- ✅ Delete confirmation dialog

**Template location**: `.claude/templates/crud-table/`

---

### 2. Form Dialog

Create form dialog (Create/Edit)

```bash
/new-dialog {name}
```

**Examples**:
```bash
/new-dialog upload-firmware    # Create upload dialog
/new-dialog edit-user          # Create user edit dialog
```

**Includes**:
- ✅ Reactive Form with validation
- ✅ Create/Edit mode support
- ✅ Material form fields
- ✅ Submit/Cancel buttons
- ✅ Form validation & error messages

**Template location**: `.claude/templates/form-dialog/`

---

## Template Directory Structure

```
.claude/templates/
├── crud-table/           # CRUD list page
│   ├── component.ts.template
│   ├── component.html.template
│   └── README.md
└── form-dialog/          # Form dialog
    ├── component.ts.template
    ├── component.html.template
    └── README.md
```

---

## Usage Example

### Complete workflow: Create Firmware Management Page

```bash
# 1. Create CRUD list page
/new-crud firmware
→ Domain: management
→ Columns: name, version, buildTime, modelSeries

# 2. Create upload dialog
/new-dialog upload-firmware

# 3. Create Domain Layer (manual)
# - firmware.model.ts
# - firmware-api.service.ts

# 4. Add Routes & i18n
```

---

## Reference Examples

Real examples in the project:

| Page | Location | Description |
|------|----------|-------------|
| User Account | `libs/mxsecurity/system/features/src/lib/user-account/` | CRUD table with tabs |
| License | `libs/mxsecurity/license/features/src/lib/license/` | Table with custom columns |
| Report | `libs/mxsecurity/report/features/src/lib/` | Complex table with filters |

---

## Tips

1. **Use common-table** - All list pages should use this reusable component
2. **Keep Domain/Features separated** - API Service in domain, UI Component in features
3. **Signal-based State** - Use `signal()` for component state management
4. **i18n Keys** - Remember to add translation keys
5. **Testing** - Write tests after using templates

---

## Customize Templates

To customize templates, edit these files:

```bash
# CRUD Table Template
code .claude/templates/crud-table/component.ts.template

# Form Dialog Template
code .claude/templates/form-dialog/component.ts.template
```

---

## Need Help?

Check template README files:
- `.claude/templates/crud-table/README.md`
- `.claude/templates/form-dialog/README.md`
