#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
countries_file="$step_root/../01-list-countries/output/countries.json"
output_dir="$step_root/output"

mkdir -p "$output_dir"
mkdir -p "$output_dir/raw"
mkdir -p "$output_dir/list"

node "$step_root/query-regions.js" "$countries_file" "$output_dir"
