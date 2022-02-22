#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../03-clip-regions/output"
input_dir_file_count=`find $input_dir/* -maxdepth 1 -type f | wc -l`
output_dir="$step_root/output"
tmp_dir="$output_dir/tmp"
tmp_subdir_max_size=150

mkdir -p "$output_dir"
mkdir -p "$tmp_dir"

# Copy & split input files into subdirectories and create a countries & subdivisions geojson for each subdirectory
n=$((`find $input_dir -maxdepth 1 -type f | wc -l`/$tmp_subdir_max_size+1))

for i in `seq 1 $n`;
do
    mkdir -p "$tmp_dir/$i";
    find $input_dir -maxdepth 1 -type f | head -n $tmp_subdir_max_size |xargs -J {} cp {} "$tmp_dir/$i"

    # npx --node-options='--max-old-space-size=8000' mapshaper-xl
    # npx mapshaper-xl
    npx mapshaper \
      -i "$tmp_dir/$i"/*.json combine-files no-topology -merge-layers \
      -split type \
      -o format=geojson target=country "$tmp_dir"/countries-clipped_"$i".json \
      -o format=geojson target=subdivision "$tmp_dir"/subdivisions-clipped_"$i".json
done

# Concat geojsons into single files for countries & subdivisions
jq -s -c '.[0].features=([.[].features]|flatten)|.[0]' $tmp_dir/countries-clipped_*.json > "$output_dir/countries-clipped.json"
jq -s -c '.[0].features=([.[].features]|flatten)|.[0]' $tmp_dir/subdivisions-clipped_*.json > "$output_dir/subdivisions-clipped.json"

rm -rf "$tmp_dir"