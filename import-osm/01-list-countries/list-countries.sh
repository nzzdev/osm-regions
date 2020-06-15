#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
output_dir="$step_root/output"

mkdir -p "$output_dir"

curl https://overpass-api.de/api/interpreter \
  --compressed \
  --data 'data=[out:csv(::"id", "ISO3166-1", wikidata, name, "name:de", "name:en")]; relation[boundary=administrative][admin_level=2]["ISO3166-1"]; out;' \
  | npx tsv2json \
  | npx prettier \
    --parser json \
    > "$output_dir/countries.json"
