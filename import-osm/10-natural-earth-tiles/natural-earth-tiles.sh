#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../09-natural-earth-json/output"
output_dir="$step_root/output"

mkdir -p "$output_dir"

tippecanoe \
  --minimum-zoom=0 \
  --maximum-zoom=4 \
  --named-layer="{\"file\": \"$input_dir/ne_10m_admin_0_countries.json\", \"layer\": \"countries\"}" \
  --named-layer="{\"file\": \"$input_dir/ne_10m_admin_1_states_provinces.json\", \"layer\": \"subdivisions\"}" \
  --include=wikidata \
  --simplification=4 \
  --simplify-only-low-zooms \
  --output "$output_dir"/regions.mbtiles
