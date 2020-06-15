#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../03-clip-regions/output"
output_dir="$step_root/output"

mkdir -p "$output_dir"

npx mapshaper \
  -i "$input_dir"/*.json combine-files no-topology -merge-layers \
  -split type \
  -o format=geojson target=country "$output_dir"/countries-clipped.json \
  -o format=geojson target=subdivision "$output_dir"/subdivisions-clipped.json
