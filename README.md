# Milo Claude - Complete Claude Code Configuration

A comprehensive Claude Code setup featuring Global Skills, Project Templates, and Config-Driven + DDD + TDD methodology.

## 🎯 What's This?

This repository provides a complete development environment for Claude Code, including:

- **7 Global Skills** - Auto-activating workflows for migration, testing, and architecture
- **Project Templates** - Ready-to-use configurations for specific project types
- **Installation Scripts** - One-command setup on any machine
- **Complete Documentation** - Usage guides, references, and best practices

## ✨ Features

### Global Skills (Cross-Project)

| Skill | Purpose | Auto-Triggers |
|-------|---------|---------------|
| **mxsecurity-page-migrator** | Complete Angular 16→20 migration workflow | "migrate {page}" |
| **legacy-behavior-analyzer** | Extract business rules from legacy code | Called by migrator |
| **signalstore-converter** | Convert RxJS to SignalStore | "convert to signals" |
| **legacy-test-generator** | Generate compatibility tests | "generate tests" |
| **config-extractor** | Extract hardcoded values to config | Detects magic numbers |
| **ddd-boundary-validator** | Validate module boundaries | "check boundaries" |
| **test-skill** | Test skills system | "test skill" |

### Project Templates

#### One-UI (Angular 20 + DDD)
- 3 Project-Specific Skills (component-implementer, template-suggester, test-coverage-builder)
- 2 Quick Commands (/new-crud, /templates)
- CRUD Table & Form Dialog templates
- Complete documentation (MY_STYLE, WORKFLOW, COMPARISON, etc.)

## 🚀 Quick Start

### Complete Installation (Recommended)

Install everything on a new machine:

```bash
# Clone the repository
git clone https://github.com/Michael0520/milo-claude.git
cd milo-claude

# Install global configuration
./scripts/install-global.sh

# Install global skills
./scripts/install-skills.sh

# Install project template (from your project directory)
cd /path/to/your/one-ui-project
/path/to/milo-claude/scripts/install-project.sh one-ui
```

### Partial Installation

Install only what you need:

```bash
# Global configuration only
./scripts/install-global.sh

# Global skills only
./scripts/install-skills.sh

# Project template only
cd /path/to/your/project
/path/to/milo-claude/scripts/install-project.sh one-ui
```

### Manual Installation

If you prefer manual setup:

```bash
# Global configuration
cp CLAUDE.md ~/.claude/CLAUDE.md

# Global skills
cp -r global-skills/* ~/.claude/skills/

# Project template
cp -r projects/one-ui/.claude /path/to/your/project/
cp projects/one-ui/CLAUDE.md /path/to/your/project/
```

## 📁 Repository Structure

```
milo-claude/
├── README.md                    # This file
├── CLAUDE.md                    # Global configuration
├── .gitignore
│
├── global-skills/               # Global Skills (7 skills)
│   ├── README.md
│   ├── 1-mxsecurity-page-migrator/
│   ├── 2-legacy-behavior-analyzer/
│   ├── 3-signalstore-converter/
│   ├── 4-legacy-test-generator/
│   ├── 5-config-extractor/
│   ├── 6-ddd-boundary-validator/
│   └── test-skill/
│
├── projects/                    # Project Templates
│   └── one-ui/
│       ├── README.md
│       ├── CLAUDE.md
│       └── .claude/
│           ├── skills/          # Project skills
│           ├── commands/        # Slash commands
│           ├── templates/       # Code templates
│           └── *.md             # Documentation
│
├── scripts/                     # Installation Scripts
│   ├── install-global.sh
│   ├── install-skills.sh
│   └── install-project.sh
│
└── docs/                        # Complete Documentation
    ├── USAGE_GUIDE.md
    ├── SKILLS_REFERENCE.md
    └── SETUP.md
```

## 🎓 Usage Examples

### Migrate a Page (Most Common)

```
You: "migrate login page"

Claude:
→ Automatically activates mxsecurity-page-migrator
→ Analyzes legacy code
→ Generates tests
→ Converts to signals
→ Validates architecture
→ Provides complete migration plan
```

### Create New Feature

```
You: "create firmware management page"

Claude:
→ template-suggester activates
→ Suggests: /new-crud firmware
→ Generates: component + template + tests
→ Provides: next steps checklist
```

### Improve Code Quality

```
You: "This code has magic numbers, can you improve it?"

Claude:
→ config-extractor activates
→ Detects hardcoded values
→ Suggests config structure
→ Refactors code
```

### Add Tests

```
You: "add tests for user service"

Claude:
→ test-coverage-builder activates
→ Generates test templates
→ Targets 95% coverage
```

## 💡 Core Philosophy

**The Trinity: Config = Spec = Test**

1. **Config-Driven Development**
   - Business rules → configuration files
   - No magic numbers or hardcoded values
   - Easy to modify without code changes

2. **Domain-Driven Design (DDD)**
   - Clear layer separation: Domain/Features/UI/Shell
   - Strict module boundaries enforced
   - Each layer has specific responsibilities

3. **Test-Driven Development (TDD)**
   - Red-Green-Refactor cycle
   - Legacy behavior preservation tests
   - Coverage targets: Domain 95%+, Features 80%+, UI 60%+

**Result**: Testing is easy because DDD separates concerns, and config makes specs clear.

## 🔧 Customization

### Add New Global Skill

1. Create skill directory in `global-skills/`
2. Add `SKILL.md` with frontmatter:
   ```yaml
   ---
   name: my-skill
   description: Brief description (≤2 sentences)
   ---
   ```
3. Run installation script to update `~/.claude/skills/`

### Add New Project Template

1. Create project directory in `projects/`
2. Add `.claude/` directory with skills, commands, templates
3. Add project-specific `CLAUDE.md`
4. Update installation script if needed

### Modify Existing Skills

Skills are just markdown files - edit them directly:

```bash
# Edit global skill
code ~/.claude/skills/1-mxsecurity-page-migrator/SKILL.md

# Edit project skill
code /path/to/project/.claude/skills/template-suggester/SKILL.md
```

Changes take effect immediately (no restart needed).

## 📚 Documentation

- **[Usage Guide](docs/USAGE_GUIDE.md)** - Complete usage examples and scenarios
- **[Skills Reference](docs/SKILLS_REFERENCE.md)** - Detailed skill documentation
- **[Setup Guide](docs/SETUP.md)** - Advanced setup and troubleshooting
- **[Global Skills README](global-skills/README.md)** - Global skills documentation
- **[One-UI README](projects/one-ui/README.md)** - One-UI project template documentation

## 🔍 Verification

Test that everything is installed correctly:

```bash
# Check global configuration
cat ~/.claude/CLAUDE.md

# Check global skills
ls ~/.claude/skills/

# Test skills system
# In Claude Code, say: "test skill"

# Check project configuration
ls .claude/skills/
ls .claude/commands/
```

## 🛠️ Troubleshooting

### Skills Not Activating?

1. Verify installation:
   ```bash
   ls -la ~/.claude/skills/
   ```

2. Test the system:
   ```
   Say to Claude: "test skill"
   ```

3. Check skill format:
   ```bash
   head -5 ~/.claude/skills/test-skill/SKILL.md
   ```

### Installation Issues?

- Make sure scripts are executable: `chmod +x scripts/*.sh`
- Check file permissions: `ls -la ~/.claude/`
- Review backup files if something went wrong

### Need to Reset?

Backups are created automatically with timestamps:
```bash
# Restore from backup
mv ~/.claude/CLAUDE.md.backup.20251019_123456 ~/.claude/CLAUDE.md
```

## 📊 What You Get

After complete installation:

- ✅ 7 Global Skills (auto-activating workflows)
- ✅ Project-specific skills, commands, templates
- ✅ Config-Driven + DDD + TDD methodology
- ✅ Complete documentation and guides
- ✅ Installation scripts for easy setup
- ✅ Backup system for safe updates

## 🎯 Key Benefits

1. **Consistency** - Same setup across all machines
2. **Speed** - 3-4x faster development with auto-activation
3. **Quality** - Built-in TDD + DDD + Config-Driven patterns
4. **Reusability** - Project templates for common patterns
5. **Maintainability** - Clear architecture and boundaries

---

**Version**: 2.0.0 | **Methodology**: Config-Driven + DDD + TDD

---

## 🚀 Quick Start Recap

```bash
# 1. Clone
git clone https://github.com/Michael0520/milo-claude.git
cd milo-claude

# 2. Install Global
./scripts/install-global.sh
./scripts/install-skills.sh

# 3. Install Project (from your project directory)
cd /path/to/your/project
/path/to/milo-claude/scripts/install-project.sh one-ui

# 4. Test
# Say to Claude: "test skill"

# 5. Start using
# Say to Claude: "migrate login page"
# Or: "/templates"
# Or: "create new page"
```

That's it! You're ready to go. 🎉
