#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../07-merge-regions/output"

array=("$input_dir/countries-clipped_*.json")
echo $array