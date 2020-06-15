#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir_osm_tiles="$step_root/../08-vector-tiles/output"
input_dir_ne_json="$step_root/../09-natural-earth-json/output"
input_dir_ne_tiles="$step_root/../10-natural-earth-tiles/output"
output_dir="$step_root/output"

mkdir -p "$output_dir"/parts

filter_file="$output_dir"/not-in-natural-earth.json

node "$step_root/not-in-natural-earth.js" "$input_dir_ne_json" "$filter_file"

tile-join \
  --minimum-zoom=0 \
  --maximum-zoom=4 \
  --output "$output_dir"/parts/regions-natural-earth_0-4.mbtiles \
  "$input_dir_ne_tiles"/regions.mbtiles

tile-join \
  --minimum-zoom=0 \
  --maximum-zoom=4 \
  --feature-filter-file "$filter_file" \
  --output "$output_dir"/parts/regions-osm_0-4.mbtiles \
  "$input_dir_osm_tiles"/regions.mbtiles

tile-join \
  --minimum-zoom=5 \
  --maximum-zoom=10 \
  --output "$output_dir"/parts/regions-osm_5-10.mbtiles \
  "$input_dir_osm_tiles"/regions.mbtiles

tile-join \
  --output "$output_dir"/regions.mbtiles \
  "$output_dir"/parts/regions-natural-earth_0-4.mbtiles \
  "$output_dir"/parts/regions-osm_0-4.mbtiles \
  "$output_dir"/parts/regions-osm_5-10.mbtiles
