#!/bin/bash

# Install Project-Specific Claude Configuration
# This script installs project-specific skills, commands, and documentation

set -e

# Check if project name is provided
if [ -z "$1" ]; then
    echo "❌ Error: Project name required"
    echo ""
    echo "Usage: $0 <project-name> [target-directory]"
    echo ""
    echo "Available projects:"
    ls -1 "$(dirname "$0")/../projects/" | sed 's/^/  - /'
    echo ""
    exit 1
fi

PROJECT_NAME="$1"
TARGET_DIR="${2:-.}"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_SOURCE="$SCRIPT_DIR/../projects/$PROJECT_NAME"

# Check if project exists
if [ ! -d "$PROJECT_SOURCE" ]; then
    echo "❌ Error: Project '$PROJECT_NAME' not found"
    echo ""
    echo "Available projects:"
    ls -1 "$SCRIPT_DIR/../projects/" | sed 's/^/  - /'
    echo ""
    exit 1
fi

# Convert to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo "🚀 Installing $PROJECT_NAME configuration..."
echo "📍 Target: $TARGET_DIR"
echo ""

# Check if .claude directory already exists
if [ -d "$TARGET_DIR/.claude" ]; then
    BACKUP_DIR="$TARGET_DIR/.claude.backup.$(date +%Y%m%d_%H%M%S)"
    echo "💾 Backing up existing .claude to $BACKUP_DIR"
    mv "$TARGET_DIR/.claude" "$BACKUP_DIR"
fi

# Copy .claude directory
if [ -d "$PROJECT_SOURCE/.claude" ]; then
    echo "📋 Installing .claude directory..."
    cp -r "$PROJECT_SOURCE/.claude" "$TARGET_DIR/"
    echo "   ✅ Skills installed"
    echo "   ✅ Commands installed"
    echo "   ✅ Templates installed"
    echo "   ✅ Documentation installed"
else
    echo "⚠️  Warning: No .claude directory found in project template"
fi

# Copy CLAUDE.md if exists
if [ -f "$PROJECT_SOURCE/CLAUDE.md" ]; then
    # Backup existing CLAUDE.md
    if [ -f "$TARGET_DIR/CLAUDE.md" ]; then
        BACKUP_FILE="$TARGET_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
        echo "💾 Backing up existing CLAUDE.md to $BACKUP_FILE"
        cp "$TARGET_DIR/CLAUDE.md" "$BACKUP_FILE"
    fi

    echo "📄 Installing project CLAUDE.md..."
    cp "$PROJECT_SOURCE/CLAUDE.md" "$TARGET_DIR/"
fi

echo ""
echo "✅ $PROJECT_NAME configuration installed successfully!"
echo ""
echo "📂 Installed components:"
echo "  - Project Skills: $TARGET_DIR/.claude/skills/"
echo "  - Commands: $TARGET_DIR/.claude/commands/"
echo "  - Templates: $TARGET_DIR/.claude/templates/"
echo "  - Documentation: $TARGET_DIR/.claude/*.md"
echo ""
echo "🎯 Available Commands:"
if [ -d "$TARGET_DIR/.claude/commands" ]; then
    find "$TARGET_DIR/.claude/commands" -name "*.md" -exec basename {} .md \; | sed 's/^/  \//'
fi
echo ""
echo "📚 Documentation Files:"
if [ -d "$TARGET_DIR/.claude" ]; then
    find "$TARGET_DIR/.claude" -maxdepth 1 -name "*.md" -exec basename {} \; | sed 's/^/  - /'
fi
echo ""
echo "🚀 Quick Start:"
echo '  1. Say: "/templates" to see available templates'
echo '  2. Say: "create new page" to get template suggestions'
echo '  3. Say: "migrate [page-name] page" to start migration'
echo ""
