#!/bin/bash
cd "$(dirname "$0")"

echo "💾 Saving dotfiles changes..."

# Show what changed
echo "Changed files:"
git status --porcelain

# Add all changes
git add .

# Commit with timestamp if no message provided
if [ -z "$1" ]; then
    git commit -m "Updated configs - $(date)"
else
    git commit -m "$1"
fi

echo "✅ Changes saved!"
echo "💡 Push to remote with: git push"
