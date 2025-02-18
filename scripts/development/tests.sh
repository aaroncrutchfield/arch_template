#!/bin/bash

# Create coverage directory if it doesn't exist
mkdir -p coverage

# Run tests with coverage for all packages
very_good test --coverage --recursive

# Find all lcov.info files and merge them
LCOV_FILES=""
for file in $(find . -name "lcov.info"); do
  LCOV_FILES="$LCOV_FILES --add-tracefile $file"
done

# Merge all coverage reports
lcov $LCOV_FILES -o coverage/merged_lcov.info

# Generate and open HTML coverage report
genhtml coverage/merged_lcov.info -o coverage/
open coverage/index.html