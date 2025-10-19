---
name: template-suggester
description: Suggest project templates when creating new components to simplify common patterns
---

# Template Suggester

## Auto-activation Triggers
- Finds `TODO: Implement component logic`
- User says: "create new page", "add component"
- User says: "how to create table", "how to create form"
- Component file is empty or has only basic structure

## Suggestion Workflow

### Step 1: Identify Needs

**Determine which template is needed**:

1. **CRUD Table** - If needs:
   - List display (table/list)
   - Search/filter/pagination
   - Create/Edit/Delete operations
   - Keywords: list, table, management, admin

2. **Form Dialog** - If needs:
   - Create/Edit form
   - Dialog format
   - Form validation
   - Keywords: create, edit, upload, dialog, form

### Step 2: Prompt User

**Concise suggestion format**:

```markdown
💡 Suggest using project template!

What you need is **{identified type}**, you can use:

/new-crud {entity-name}        # CRUD list page
/new-dialog {dialog-name}      # Form dialog
/templates                     # View all templates

These templates include:
- ✅ common-table integration
- ✅ Signal-based state
- ✅ API service integration
- ✅ OnPush change detection
- ✅ Material UI components

Would you like me to help you use the template?
```

### Step 3: Assist Usage

**If user agrees**:

1. Execute corresponding slash command
2. Ask necessary information (entity name, domain, columns)
3. Generate files
4. Prompt next steps (Domain layer, i18n, routes)

**If user declines**:

Provide manual reference locations:
- Template location: `.claude/templates/`
- Actual examples: `libs/mxsecurity/system/features/src/lib/user-account/`

## Template List

### 1. CRUD Table

**When to use**:
- Need to display data in list format
- Need CRUD operations
- Need search/sort/pagination

**Command**: `/new-crud {entity-name}`

**Includes**:
- common-table component
- Add/Edit/Delete buttons
- Selection & Edit functionality
- API integration
- Loading states

### 2. Form Dialog

**When to use**:
- Need create/edit form
- Dialog presentation
- Form validation

**Command**: `/new-dialog {name}`

**Includes**:
- Reactive Form
- Material form fields
- Validation & error handling
- Create/Edit mode

## Important Notes

**Keep it concise**
- Don't be verbose, directly suggest the most suitable template
- Provide clear slash command
- Explain what features the template includes

**Respect user choice**
- If user wants to write manually, don't insist
- Provide template location for reference

**Provide actual examples**
- Point to existing implementations in the project
- Let users learn by reference
