#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../04-reduce-regions/output"
output_dir="$step_root/output"

mkdir -p "$output_dir"

npx mapshaper \
  -i "$input_dir"/*.json no-topology name= \
  -split wikidata \
  -o format=geojson "$output_dir"
