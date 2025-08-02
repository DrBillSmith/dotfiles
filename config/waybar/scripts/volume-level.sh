#!/bin/bash

# Get volume percentage
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes' && echo true || echo false)

if [ "$muted" = "true" ]; then
    echo "MUTED"
else
    echo "$volume"
fi
