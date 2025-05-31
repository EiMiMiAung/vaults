#!/bin/sh

# Find all directories named "file"
find ./../ -type d -name "file" | while read dir; do
  echo "Cleaning: $dir"
  rm -rf "$dir"/* "$dir"/.[!.]* "$dir"/..?*
done

echo "All 'file' directories have been cleaned."