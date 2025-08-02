#!/bin/bash

echo "Enabling OBS clipping environment..."

# Activate the Python virtual environment
source ~/obs-clipping-env/bin/activate

# Start the auto-restart service
systemctl --user start obs-restart.service

# Check if service started successfully
if systemctl --user is-active --quiet obs-restart.service; then
    echo "✓ Auto-restart service started"
else
    echo "⚠ Warning: Auto-restart service failed to start"
fi

echo "✓ OBS clipping environment enabled"
echo "Your clip keybind should now work, and replay buffer will auto-restart every 20 minutes"
