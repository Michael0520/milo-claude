#!/bin/bash

# Install Global Claude Configuration
# This script installs the global CLAUDE.md configuration

set -e

echo "🚀 Installing Global Claude Configuration..."

# Check if ~/.claude directory exists
if [ ! -d "$HOME/.claude" ]; then
    echo "📁 Creating ~/.claude directory..."
    mkdir -p "$HOME/.claude"
fi

# Backup existing CLAUDE.md if it exists
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
    BACKUP_FILE="$HOME/.claude/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
    echo "💾 Backing up existing CLAUDE.md to $BACKUP_FILE"
    cp "$HOME/.claude/CLAUDE.md" "$BACKUP_FILE"
fi

# Copy CLAUDE.md
echo "📋 Installing CLAUDE.md..."
cp "$(dirname "$0")/../CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo ""
echo "✅ Global configuration installed successfully!"
echo ""
echo "📍 Location: $HOME/.claude/CLAUDE.md"
echo ""
echo "Next steps:"
echo "  1. Install global skills: ./scripts/install-skills.sh"
echo "  2. For project-specific config: ./scripts/install-project.sh one-ui"
echo ""
