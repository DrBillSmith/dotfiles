#!/bin/bash

echo "🚀 Installing your setup with symlinks..."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

# Function to create symlinks safely
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Create target directory if needed
    mkdir -p "$(dirname "$target")"
    
    # Backup existing file/folder if it exists and isn't already a symlink to our file
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "  📋 Backing up existing $target"
        mv "$target" "$target.backup-$(date +%s)"
    elif [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "  ✅ $target already linked correctly"
        return
    elif [ -L "$target" ]; then
        echo "  🔄 Updating symlink $target"
        rm "$target"
    fi
    
    # Create the symlink
    ln -sf "$source" "$target"
    echo "  🔗 Linked $target → $source"
}

# Install yay if needed
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed base-devel git
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
fi

# Install packages
echo "📦 Installing packages..."
if [ -f packages.txt ]; then
    echo "Installing official packages..."
    sudo pacman -S --needed - < packages.txt
fi

if [ -f packages-aur.txt ]; then
    echo "Installing AUR packages..."
    yay -S --needed - < packages-aur.txt
fi

# Install Flatpak apps
if [ -f flatpak.txt ] && [ -s flatpak.txt ]; then
    if ! command -v flatpak &> /dev/null; then
        sudo pacman -S flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
    echo "Installing Flatpak apps..."
    while read app; do
        [ -n "$app" ] && [ "${app:0:1}" != "#" ] && flatpak install -y flathub "$app"
    done < flatpak.txt
fi

# Install Python packages
if [ -f python-packages.txt ] && [ -s python-packages.txt ]; then
    echo "Installing Python packages..."
    pip install --user -r python-packages.txt
fi

# Create symlinks for dotfiles
echo "📝 Creating symlinks for dotfiles..."

# Link home directory files
if [ -d home ]; then
    for file in home/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            create_symlink "$DOTFILES_DIR/$file" "$HOME/.$filename"
        fi
    done
fi

# Link .config directory contents
if [ -d config ]; then
    for item in config/*; do
        if [ -e "$item" ]; then
            itemname=$(basename "$item")
            create_symlink "$DOTFILES_DIR/$item" "$HOME/.config/$itemname"
        fi
    done
fi

# Link .local directory contents
if [ -d local ]; then
    for item in local/*; do
        if [ -e "$item" ]; then
            itemname=$(basename "$item")
            create_symlink "$DOTFILES_DIR/$item" "$HOME/.local/$itemname"
        fi
    done
fi

# Install themes
echo "🎨 Installing themes..."
if [ -d themes/.themes ]; then
    mkdir -p "$HOME/.themes"
    cp -r themes/.themes/* "$HOME/.themes/"
fi

if [ -d themes/.icons ]; then
    mkdir -p "$HOME/.icons"
    cp -r themes/.icons/* "$HOME/.icons/"
fi

if [ -d themes/fonts ]; then
    mkdir -p "$HOME/.local/share/fonts"
    cp -r themes/fonts/* "$HOME/.local/share/fonts/"
    fc-cache -fv
fi

# Install scripts (copy these since they might need to be executable)
echo "🔧 Installing scripts..."
if [ -d scripts ]; then
    for script_dir in scripts/*; do
        if [ -d "$script_dir" ]; then
            dir_name=$(basename "$script_dir")
            target_dir="$HOME/$dir_name"
            mkdir -p "$target_dir"
            cp -r "$script_dir"/* "$target_dir/"
            chmod +x "$target_dir"/*.sh 2>/dev/null || true
        fi
    done
fi

echo "✅ Installation complete!"
echo ""
echo "🔗 Your dotfiles are now symlinked:"
echo "   Edit ~/.vimrc → edits $DOTFILES_DIR/home/vimrc"
echo "   Edit ~/.config/nvim/init.vim → edits $DOTFILES_DIR/config/nvim/init.vim"
echo ""
echo "💡 To save changes to git:"
echo "   cd $DOTFILES_DIR"
echo "   git add ."
echo "   git commit -m 'Updated configs'"
echo ""
echo "You may need to:"
echo "  - Log out and back in"
echo "  - Restart your DE/WM"
echo "  - Check theme settings"
