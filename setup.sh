#!/bin/bash

# Check if config exists
if [ -f ./config.json ]; then
    echo 'Config exists, starting NodeBB...'
    ./nodebb build
    ./nodebb start
else
    echo 'First run, setting up NodeBB...'
    ./nodebb setup
    ./nodebb build
    ./nodebb start
fi

# Keep container running
tail -f /dev/null
