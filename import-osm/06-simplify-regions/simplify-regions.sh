#!/bin/bash
set -o errexit
set -o nounset

step_root=$(dirname "$0")
input_dir="$step_root/../05-split-by-region/output"
output_dir="$step_root/output"
tmp_subdir_max_size=200

mkdir -p "$output_dir"

for country_dir in "$input_dir"/*/
do
    dir="${country_dir%*/}"
    dir_name="${dir##*/}"
    output_country_dir="$output_dir/$dir_name"

    mkdir -p "$output_country_dir"

    for input_file in "$country_dir"/*.json; 
    do
      filename=$(basename "$input_file")
      output_file="$output_country_dir"/"$filename"
      npx mapshaper \
        -i "$input_file" \
        -simplify resolution=256x256 \
        -o format=geojson "$output_file"
    done
done
exit 1



# Split files into multiple subdirectories
n=$((`find $output_dir -maxdepth 1 -type f | wc -l`/$tmp_subdir_max_size+1))

for i in `seq 1 $n`;
do
    mkdir -p "$output_dir/$i";
    find $output_dir -maxdepth 1 -type f | head -n $tmp_subdir_max_size |xargs -J {} mv {} "$output_dir/$i"
done
