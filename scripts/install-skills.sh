#!/bin/bash

# Install Global Claude Skills
# This script installs all global skills to ~/.claude/skills/

set -e

echo "🎯 Installing Global Claude Skills..."

# Check if ~/.claude/skills directory exists
if [ ! -d "$HOME/.claude/skills" ]; then
    echo "📁 Creating ~/.claude/skills directory..."
    mkdir -p "$HOME/.claude/skills"
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SOURCE="$SCRIPT_DIR/../global-skills"

# Count skills
SKILL_COUNT=$(find "$SKILLS_SOURCE" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')

echo "📦 Found $SKILL_COUNT skills to install..."
echo ""

# Copy each skill
for skill_dir in "$SKILLS_SOURCE"/*; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")

        # Backup existing skill if it exists
        if [ -d "$HOME/.claude/skills/$skill_name" ]; then
            BACKUP_DIR="$HOME/.claude/skills/$skill_name.backup.$(date +%Y%m%d_%H%M%S)"
            echo "💾 Backing up existing $skill_name to $BACKUP_DIR"
            mv "$HOME/.claude/skills/$skill_name" "$BACKUP_DIR"
        fi

        echo "✅ Installing: $skill_name"
        cp -r "$skill_dir" "$HOME/.claude/skills/"
    fi
done

echo ""
echo "🎉 All skills installed successfully!"
echo ""
echo "📍 Location: $HOME/.claude/skills/"
echo ""
echo "Installed skills:"
ls -1 "$HOME/.claude/skills/" | sed 's/^/  - /'
echo ""
echo "🧪 Test installation:"
echo '  Say to Claude: "test skill"'
echo ""
echo "📚 View skills documentation:"
echo "  cat $HOME/.claude/skills/*/SKILL.md"
echo ""
