#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../02-query-regions/output"
output_dir="$step_root/output"

land_polygons="$step_root/../00-static-data/land-polygons-complete-4326/land_polygons.shp"

mkdir -p "$output_dir"

# Split by admin_level before clipping to work around a bug (?) with overlapping geometries.
npx mapshaper \
  -i "$input_dir"/*.json combine-files no-topology -merge-layers \
  -split admin_level \
  -clip "$land_polygons" \
  -merge-layers \
  -split ISO3166-1 \
  -o format=geojson "$output_dir"
