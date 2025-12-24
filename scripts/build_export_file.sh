#!/bin/bash

SCRIPT_DIR=$(dirname "$0")
PROJECT_ROOT="$SCRIPT_DIR/.."
TARGET_FILE="$PROJECT_ROOT/lib/fluttersdk_wind.dart"
LIBRARY_NAME="fluttersdk_wind"
SOURCE_DIR="$PROJECT_ROOT/lib/src"

echo "library $LIBRARY_NAME;" > "$TARGET_FILE"
echo "" >> "$TARGET_FILE"
find "$SOURCE_DIR" -type f -name "*.dart" | \
sed "s|$PROJECT_ROOT/lib/||" | \
awk '{print "export \x27" $0 "\x27;"}' | \
sort | \
cat >> "$TARGET_FILE"

echo "Successfully exported all files from $SOURCE_DIR to $TARGET_FILE."