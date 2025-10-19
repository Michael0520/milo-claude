# Global Claude Skills

These skills are available across all projects and provide core development workflows.

## Available Skills

### 1. mxsecurity-page-migrator
**Purpose**: Orchestrates complete Angular 16 → Angular 20 migration workflow

**Auto-triggers**:
- "migrate {page-name} page"
- "convert to Angular 20"

**What it does**:
- 6-phase migration workflow
- Calls analyzer, converter, test-generator, validator
- Tracks progress with todo list
- Final validation checklist

### 2. legacy-behavior-analyzer
**Purpose**: Extracts business rules from Angular 16 legacy code

**Auto-triggers**:
- Called by mxsecurity-page-migrator
- "analyze legacy code"

**What it does**:
- 5 analysis phases: API → State → Lifecycle → UI → Business Rules
- Outputs behavior specification document
- Used for migration planning

### 3. signalstore-converter
**Purpose**: Converts BehaviorSubject/RxJS to Angular 20 SignalStore

**Auto-triggers**:
- Called by mxsecurity-page-migrator
- "convert to signals"
- Detects BehaviorSubject patterns

**What it does**:
- BehaviorSubject → signal()
- RxJS Observables → toSignal()
- @ViewChild → viewChild()
- Modern Angular 20 patterns

### 4. legacy-test-generator
**Purpose**: Generates compatibility tests ensuring new implementation matches legacy behavior

**Auto-triggers**:
- Called by mxsecurity-page-migrator
- "generate tests"
- "write compatibility tests"

**What it does**:
- 3 test templates: SignalStore, Component, Business Rules
- Ensures legacy behavior preservation
- Coverage targets: Domain 95%+, Features 80%+, UI 60%+

### 5. config-extractor
**Purpose**: Extracts hardcoded values to configuration files

**Auto-triggers**:
- Detects magic numbers
- Detects hardcoded strings
- "extract hardcoded values"
- "make config-driven"

**What it does**:
- 4 extraction patterns: Constants, Permissions, Validation, Features
- Transforms magic numbers → config files
- Config-driven development support

### 6. ddd-boundary-validator
**Purpose**: Validates DDD layer dependencies and module boundaries

**Auto-triggers**:
- Called by mxsecurity-page-migrator
- "check module boundaries"
- "validate DDD architecture"
- Lint execution finds boundary errors

**What it does**:
- Module boundary rules enforcement
- Type dependency hierarchy validation
- ESLint integration for auto-fix
- Provides fix suggestions

### 7. test-skill
**Purpose**: Tests if Claude Code skills are loaded correctly

**Auto-triggers**:
- "test skill"
- "verify skills"
- "are skills working"

**What it does**:
- Confirms skills system is working
- Lists all installed skills
- Provides usage guidance

---

## Installation

Copy all skills to your global Claude directory:

```bash
# From milo-claude repo root
cp -r global-skills/* ~/.claude/skills/
```

Or use the installation script:

```bash
./scripts/install-skills.sh
```

---

## Usage Examples

### Migrate a Page
```
You: "migrate login page"

Claude:
→ mxsecurity-page-migrator activates
→ Calls legacy-behavior-analyzer
→ Calls legacy-test-generator
→ Calls signalstore-converter
→ Calls ddd-boundary-validator
→ Provides complete migration plan
```

### Extract Config
```
You: "This code has magic numbers, can you improve it?"

Claude:
→ config-extractor activates
→ Detects hardcoded values
→ Suggests config file structure
→ Refactors code
```

### Validate Architecture
```
You: "Why is ESLint showing boundary violations?"

Claude:
→ ddd-boundary-validator activates
→ Explains module boundary rules
→ Shows violation locations
→ Provides fix options
```

---

## How Skills Work

### Auto-Activation
Skills activate automatically based on:
- **Keywords**: Specific phrases in your messages
- **Code Patterns**: Detected patterns in files (magic numbers, BehaviorSubject, etc.)
- **Skill Orchestration**: One skill calling another

You don't need to manually invoke skills - just describe what you want to do.

### Token Efficiency
- Each skill uses only ~30-50 tokens until loaded
- Frontmatter (name + description) is scanned for relevance
- Full content loads only when Claude determines skill is needed
- This keeps context usage minimal

### Skill Chaining
Skills can call other skills automatically:

```
mxsecurity-page-migrator
  ├── → legacy-behavior-analyzer
  ├── → legacy-test-generator
  ├── → signalstore-converter
  └── → ddd-boundary-validator
```

---

## Customization

Each skill is a directory containing `SKILL.md`:

```
1-mxsecurity-page-migrator/
└── SKILL.md              # Skill instructions
```

To customize:
1. Edit the `SKILL.md` file
2. Changes take effect immediately (no restart needed)

To disable temporarily:
```bash
mv ~/.claude/skills/test-skill ~/.claude/skills/test-skill.disabled
```

---

## Best Practices

1. **Trust Auto-Activation**: Don't try to manually invoke skills
2. **Use Natural Language**: Just describe what you want
3. **Follow Todo Lists**: When Claude creates todos, follow them
4. **Verify Each Phase**: Test after each major step
5. **Reference Examples**: Ask Claude to show real project examples

---

## Troubleshooting

### Skills Not Activating?

1. Check installation:
   ```bash
   ls -la ~/.claude/skills/
   ```

2. Test the system:
   ```
   test skill
   ```

3. Check frontmatter format:
   ```yaml
   ---
   name: skill-name
   description: Brief description
   ---
   ```

### Skills Conflicting?

If multiple skills activate when you don't want them to:
1. Make descriptions more specific
2. Adjust auto-trigger keywords
3. Temporarily disable unnecessary skills

---

## Support

For issues or questions:
- Check `docs/USAGE_GUIDE.md` for detailed examples
- Check `docs/SKILLS_REFERENCE.md` for complete reference
- Review individual SKILL.md files for specific skill documentation
