#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../04-reduce-regions/output"
output_dir="$step_root/output"

mkdir -p "$output_dir"

# Split countries into regions & output in country specific folders
for file_path in "$input_dir"/*.json;
do
      filename=$(basename -- "$file_path")
      filename="${filename%.*}"
      file_output_dir="$output_dir/$filename"
      
      mkdir -p "$file_output_dir"

      npx mapshaper \
        -i "$file_path" no-topology name= \
        -split wikidata \
        -o format=geojson "$file_output_dir"
done