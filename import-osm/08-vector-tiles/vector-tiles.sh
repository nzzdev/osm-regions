#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../07-merge-regions/output"
output_dir="$step_root/output"
countries_clipped=($input_dir/countries-clipped_*.json)
subdivisions_clipped=($input_dir/subdivisions-clipped_*.json)

mkdir -p "$output_dir"

#  --named-layer="{\"file\": \"$input_dir/countries-clipped_*.json\", \"layer\": \"countries\"}" \
#  --named-layer="{\"file\": \"$input_dir/subdivisions-clipped_*.json\", \"layer\": \"subdivisions\"}" \

tippecanoe \
  --minimum-zoom=0 \
  --maximum-zoom=10 \
  --named-layer="{\"file\": \"$input_dir/countries-clipped.json\", \"layer\": \"countries\"}" \
  --named-layer="{\"file\": \"$input_dir/subdivisions-clipped.json\", \"layer\": \"subdivisions\"}" \
  --include=wikidata \
  --simplification=4 \
  --simplify-only-low-zooms \
  --output "$output_dir"/regions.mbtiles

#  --named-layer="{\"file\": \"$countries_clipped\", \"layer\": \"countries\"}" \
#  --named-layer="{\"file\": \"$subdivisions_clipped\", \"layer\": \"subdivisions\"}" \


