#!/bin/bash

# Check if EasyEffects is running and count active effects
if pgrep -x "easyeffects" > /dev/null; then
    # Try to get number of active effects (this is approximate)
    effects=$(ps aux | grep easyeffects | grep -v grep | wc -l)
    if [ "$effects" -gt 0 ]; then
        echo "ON"
    else
        echo "ON"
    fi
else
    echo "OFF"
fi
