#!/bin/bash

# Count active PipeWire connections
connections=$(pw-link -l 2>/dev/null | wc -l)

if [ "$connections" -gt 0 ]; then
    echo "$connections"
else
    echo "0"
fi
