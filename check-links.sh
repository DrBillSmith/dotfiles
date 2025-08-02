#!/bin/bash
cd "$(dirname "$0")"

echo "🔗 Checking your symlinks..."
echo ""

# Check home directory links
echo "📁 Home directory:"
for file in home/*; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        target="$HOME/.$filename"
        if [ -L "$target" ]; then
            echo "  ✅ .$filename → $(readlink "$target")"
        else
            echo "  ❌ .$filename (not linked)"
        fi
    fi
done

echo ""
echo "📁 .config directory:"
for item in config/*; do
    if [ -e "$item" ]; then
        itemname=$(basename "$item")
        target="$HOME/.config/$itemname"
        if [ -L "$target" ]; then
            echo "  ✅ $itemname → $(readlink "$target")"
        else
            echo "  ❌ $itemname (not linked)"
        fi
    fi
done
