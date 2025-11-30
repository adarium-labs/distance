#!/bin/bash

# format_code.sh
# Script to format Ada code in different projects of the repository

# Exit immediately if a command exits with a non-zero status
set -e

# Get the absolute path of the repository root directory
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Aclida Code Formatter ==="
echo "Repository root: $REPO_ROOT"

# Format code in the root project
echo -e "\n=== Formatting root project ==="
cd "$REPO_ROOT"
alr exec -- gnatformat -P distance.gpr

# Format code in the tests directory
echo -e "\n=== Formatting tests project ==="
cd "$REPO_ROOT/tests"
alr exec -- gnatformat -P distance_tests.gpr

echo -e "\n=== Code formatting complete ==="
