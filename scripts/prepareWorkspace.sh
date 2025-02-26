#!/bin/bash

# Get the directory of the script
script_dir=$(dirname "$0")

# Go to the root directory of the script
workspace_dir=$(realpath "$script_dir"/../..)
echo "workspace dir is ${workspace_dir}"

cd "$workspace_dir"

if [ ! -d ".venv" ]; then
    echo "Could not find virtual env, creating one now"
    python3 -m venv .venv 
    .venv/bin/pip install west
fi

if [ ! -d ".west" ]; then
    echo "Could not find .west folder, initializing workspace now"
    .venv/bin/west init -l bridle-dojo-zephyr-hrenkap
fi

echo "Update workspace using west"
.venv/bin/west update

.venv/bin/pip install -r zephyr/scripts/requirements.txt

.venv/bin/west zephyr-export
.venv/bin/west bridle-export
