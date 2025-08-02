#!/bin/bash

echo "Disabling OBS clipping environment..."

# Stop the auto-restart service
systemctl --user stop obs-restart.service

# Deactivate virtual environment (if active)
if [[ "$VIRTUAL_ENV" != "" ]]; then
    deactivate
    echo "✓ Virtual environment deactivated"
fi

echo "✓ OBS auto-restart service stopped"
echo "Clipping environment disabled"
