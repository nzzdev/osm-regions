#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../05-split-by-region/output"
output_dir="$step_root/output"

mkdir -p "$output_dir"

for input_file in "$input_dir"/*.json; do
  filename=$(basename "$input_file")
  output_file="$output_dir"/"$filename"
  npx mapshaper \
    -i "$input_file" \
    -simplify resolution=256x256 \
    -o format=geojson "$output_file"
done
