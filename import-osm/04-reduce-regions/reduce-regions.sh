#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
countries_file="$step_root/../01-list-countries/output/countries.json"
input_dir="$step_root/../03-clip-regions/output"
output_dir="$step_root/output"

mkdir -p "$output_dir"

node "$step_root/reduce-regions.js" "$countries_file" "$input_dir" "$output_dir"
