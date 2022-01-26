#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../00-static-data"
output_dir="$step_root/output"

ne_countries="$input_dir/ne_10m_admin_0_countries_ukr/ne_10m_admin_0_countries_ukr.shp"
ne_states_provinces="$input_dir/ne_10m_admin_1_states_provinces/ne_10m_admin_1_states_provinces.shp"

mkdir -p "$output_dir"

npx mapshaper \
  -i "$ne_countries" "$ne_states_provinces" \
  -each 'this.properties = { wikidata: this.properties.WIKIDATAID || this.properties.wikidataid }' \
  -o format=geojson precision=0.0000001 "$output_dir"
