---
name: test-skill
description: Test if Claude Code skills are loaded and working correctly
---

# Skills Test Tool

## Auto-activation Triggers
- User says: "test skill"
- User says: "verify skills"
- User says: "are skills working"

## Test Response

When activated, reply with:

```
✅ Skills loaded successfully!

Your Claude Code skills directory is working correctly.

Installed MXSecurity Skills:
1. mxsecurity-page-migrator - Page migration workflow
2. legacy-behavior-analyzer - Legacy code analysis
3. signalstore-converter - State conversion
4. legacy-test-generator - Test generation
5. config-extractor - Config extraction
6. ddd-boundary-validator - Boundary validation

Skills location: ~/.claude/skills/

You can now start using these skills!
Try: "migrate login page"
```

## Additional Info

If user asks how to use skills, provide:

### How Skills Activate

Skills activate automatically, no manual invocation needed:

- Say "migrate {page-name} page" → Starts full migration
- Say "analyze legacy code" → Starts legacy analysis
- See BehaviorSubject → Auto-suggests conversion
- Say "write tests" → Provides test templates
- Detect magic numbers → Suggests config extraction
- Lint errors → Provides boundary validation

### View Installed Skills

```bash
ls -la ~/.claude/skills/
```

### Disable Specific Skill

To temporarily disable a skill:

```bash
# Rename (add .disabled suffix)
mv ~/.claude/skills/test-skill ~/.claude/skills/test-skill.disabled
```

### Update Skill

Edit SKILL.md directly:

```bash
# Use your preferred editor
code ~/.claude/skills/1-mxsecurity-page-migrator/SKILL.md
```

Changes take effect immediately, no restart needed.
