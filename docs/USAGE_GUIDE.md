# Claude Skills Usage Guide

Complete guide to using the Milo Claude Skills system effectively.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Common Scenarios](#common-scenarios)
3. [Daily Workflow](#daily-workflow)
4. [Advanced Techniques](#advanced-techniques)
5. [Best Practices](#best-practices)
6. [Troubleshooting](#troubleshooting)

---

## Getting Started

### First Time Setup

After installation, test your setup:

```
You: "test skill"

Claude: ✅ Skills loaded successfully!
```

This confirms all skills are installed and working.

### Understanding Auto-Activation

Skills activate automatically based on keywords. You don't need to manually invoke them - just describe what you want:

**DON'T** say: "Use mxsecurity-page-migrator to migrate login page"
**DO** say: "migrate login page"

---

## Common Scenarios

### Scenario 1: Page Migration (Most Frequent)

**When**: You need to migrate Angular 16 code to Angular 20

**What to say**:
```
migrate [page-name] page
```

**Example**:
```
You: "migrate report page"

Claude:
1. Reads legacy code from libs/mxsecurity/report/
2. Analyzes business rules, API contracts, state
3. Generates compatibility tests
4. Converts BehaviorSubject → signal()
5. Validates DDD boundaries
6. Provides complete migration plan with todo list
```

**What you get**:
- Complete 6-phase migration plan
- Compatibility tests ensuring behavior matches
- New Signal-based implementation
- DDD architecture validation
- Todo list to track progress

**Time saved**: 10-16 hours → 3-4 hours (3-4x faster)

---

### Scenario 2: Creating New Features

**When**: Building a new CRUD page or feature

**What to say**:
```
create [feature-name] page
```

**Example**:
```
You: "create firmware management page"

Claude:
→ template-suggester activates
→ Suggests: "/new-crud firmware"
→ Asks: domain, columns, features needed

You: "/new-crud firmware"

Claude:
→ Generates component.ts + component.html
→ Uses common-table template
→ Provides next steps (API service, dialog, i18n, routes)
```

**What you get**:
- Complete CRUD component with common-table
- Add/Edit/Delete functionality
- Loading states and error handling
- Next steps checklist
- Ready to use in 5-10 minutes

---

### Scenario 3: Implementing Unfinished Components

**When**: You have a component with legacy code in comments

**What to say**:
```
implement this component
```

**Example**:
```typescript
// TODO: Implement component logic
// ================================================================================
// LEGACY CODE - Reference Implementation
// ================================================================================
// [Old Angular 16 code here]
// ================================================================================

export class NewComponent {
  // Empty
}
```

```
You: "implement this component"

Claude:
→ component-implementer activates
→ Reads LEGACY CODE comments
→ Analyzes old patterns
→ Converts to Angular 20
→ Removes TODO when complete
```

**What you get**:
- Modern Angular 20 implementation
- Signal-based state
- OnPush change detection
- Clean, maintainable code

---

### Scenario 4: Improving Code Quality

**When**: Code has magic numbers or hardcoded values

**What to say**:
```
can you improve this code?
```
or
```
extract hardcoded values
```

**Example**:
```typescript
// Before
if (user.loginAttempts > 3) {
  this.lockAccount(1800000);  // 30 minutes
}
```

```
You: "this code has magic numbers, can you improve it?"

Claude:
→ config-extractor activates
→ Detects: 3, 1800000
→ Suggests config structure
→ Refactors code
```

```typescript
// After
// auth.config.ts
export const AUTH_CONFIG = {
  maxLoginAttempts: 3,
  accountLockDuration: 30 * 60 * 1000
} as const;

// Code
if (user.loginAttempts > AUTH_CONFIG.maxLoginAttempts) {
  this.lockAccount(AUTH_CONFIG.accountLockDuration);
}
```

---

### Scenario 5: Adding Tests

**When**: Test coverage is low

**What to say**:
```
add tests for [module-name]
```

**Example**:
```
You: "add tests for user service"

Claude:
→ test-coverage-builder activates
→ Finds missing test files
→ Generates test templates
→ Targets 95% coverage
```

**What you get**:
- Service test templates (HttpTestingController)
- Store test templates (SignalStore)
- Component test templates (TestBed)
- Coverage targets: Domain 95%+, Features 80%+

---

### Scenario 6: Module Boundary Issues

**When**: ESLint shows boundary violations

**What to say**:
```
check module boundaries
```
or
```
why is this lint error happening?
```

**Example**:
```bash
Error: A project tagged with "scope:mxsecurity" can only depend on 
libs tagged with "scope:mxsecurity" or "scope:shared"
```

```
You: "check module boundaries"

Claude:
→ ddd-boundary-validator activates
→ Explains DDD rules
→ Finds violation location
→ Provides 3 fix options
```

---

## Daily Workflow

### Morning Routine

```bash
# 1. Check status
git status
git log -3

# 2. Plan your day
You: "Today I need to migrate report page and add device management"

Claude: Creates todo list with phases
```

### During Development

```bash
# Ask anything naturally
You: "how to implement this feature?"
You: "why is this lint error happening?"
You: "can you extract these hardcoded values?"

# Skills activate automatically
```

### Before Finishing

```bash
# 1. Check tests
You: "run tests and check coverage"

# 2. Validate boundaries
You: "check module boundaries"

# 3. Clean up code
You: "extract any hardcoded values I missed"

# 4. Commit
You: "create a commit for these changes"
```

---

## Advanced Techniques

### Chaining Multiple Skills

Execute multiple tasks in sequence:

```
You: "migrate login page, then add tests, and check boundaries"

Claude:
1. Migrates page (mxsecurity-page-migrator)
2. Adds tests (test-coverage-builder)
3. Validates boundaries (ddd-boundary-validator)
```

### Referencing Project Examples

Ask for real examples:

```
You: "show me a real example from the project"

Claude: Points to:
- libs/mxsecurity/system/features/src/lib/user-account/
- libs/mxsecurity/license/features/src/lib/license/
```

### Customizing Templates

Create similar but customized pages:

```
You: "create a CRUD page like user-account but for devices"

Claude:
→ Reads user-account implementation
→ Adapts for devices
→ Maintains same patterns
```

### Phased Execution

For complex tasks, execute in phases:

```
// Phase 1
You: "analyze legacy login page behavior"

// Phase 2 (after reviewing)
You: "convert login page to signals"

// Phase 3
You: "add tests for login page"
```

---

## Best Practices

### 1. Trust Auto-Activation

❌ Don't: "Use skill X to do Y"
✅ Do: "I want to do Y"

Skills activate automatically based on context.

### 2. Follow Todo Lists

When Claude creates a todo list, follow it step by step. It's designed for optimal workflow.

### 3. Verify Each Phase

Don't wait until the end to test:
- Run tests after implementation
- Check lint after refactoring
- Validate boundaries frequently

### 4. Use Natural Language

❌ Don't: "/execute-migration --target=login --mode=full"
✅ Do: "migrate login page"

### 5. Ask for Clarification

When unsure:
```
"why did you use signal() instead of BehaviorSubject?"
"explain the DDD architecture for this page"
```

### 6. Reference Documentation

Check documentation anytime:
```
"show me MY_STYLE.md"
"show me QUICK_REFERENCE.md"
```

---

## Troubleshooting

### Skills Not Activating

**Problem**: You say "migrate page" but nothing happens

**Solutions**:
1. Test system: "test skill"
2. Check installation: `ls ~/.claude/skills/`
3. Verify frontmatter in SKILL.md files

### Wrong Skill Activates

**Problem**: Different skill than expected activates

**Solutions**:
1. Be more specific in your request
2. Check skill descriptions for keyword overlap
3. Temporarily disable conflicting skills

### Can't Find Files

**Problem**: Claude can't find the files you're referring to

**Solutions**:
1. Use full paths: `libs/mxsecurity/report/`
2. Show file first: "read this file" then ask
3. Use glob patterns: `libs/mxsecurity/*/features/`

### Tests Failing After Migration

**Problem**: New implementation doesn't match legacy behavior

**Solutions**:
1. Check compatibility tests
2. Review behavior specification document
3. Compare with legacy code comments
4. Ask: "why is this test failing?"

---

## Quick Reference

### Most Common Commands

```
# Migration
"migrate [page] page"

# Creation
"create [feature] page"
"/new-crud [entity-name]"
"/new-dialog [name]"

# Testing
"add tests for [module]"
"run tests and check coverage"

# Quality
"can you improve this code?"
"extract hardcoded values"
"check module boundaries"

# Templates
"/templates"

# Documentation
"show me MY_STYLE.md"
"show me WORKFLOW.md"
```

### Skill Activation Keywords

| Skill | Keywords |
|-------|----------|
| mxsecurity-page-migrator | "migrate", "convert to Angular 20" |
| template-suggester | "create new", "how to create" |
| component-implementer | "implement", sees TODO |
| config-extractor | "improve code", detects magic numbers |
| test-coverage-builder | "add tests", "write tests" |
| ddd-boundary-validator | "check boundaries", lint errors |

---

## Real-World Example: Complete Day

### 9:00 AM - New Feature
```
You: "I need to create a firmware upgrade page"
→ 5 minutes: Template suggested, page generated
```

### 10:00 AM - Domain Layer
```
You: "create firmware API service and model"
→ 15 minutes: Service + model + tests generated
```

### 11:00 AM - Dialog
```
You: "/new-dialog upload-firmware"
→ 10 minutes: Form dialog with validation
```

### 2:00 PM - Migration
```
You: "migrate old firmware page to new implementation"
→ 2 hours: Complete migration with tests
```

### 4:00 PM - Quality Check
```
You: "extract hardcoded values and check boundaries"
→ 30 minutes: Config extracted, boundaries validated
```

### Result: Full feature in one day ✅

---

For more information:
- [Skills Reference](SKILLS_REFERENCE.md) - Detailed skill documentation
- [Setup Guide](SETUP.md) - Installation and configuration
- [Main README](../README.md) - Overview and quick start

