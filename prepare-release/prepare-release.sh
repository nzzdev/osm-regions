#!/bin/bash
set -o errexit
set -o nounset

if [ "$#" -lt 1 ]; then
    echo "Version argument is missing."
    exit 1
fi
version="$1"

import_osm_root=$(dirname "$0")/../import-osm
release_assets=$(dirname "$0")/release-assets
readme=$(dirname "$0")/copyright-notice/README.txt

rm -rf "$release_assets"
mkdir -p "$release_assets"

###
# Inputs
###

# land-polygons-complete-4326 => osmdata-land-polygons-{version}.zip
zip --junk-paths \
    "$release_assets"/osmdata-land-polygons-"$version".zip \
    "$import_osm_root"/00-static-data/land-polygons-complete-4326/*


###
# Ouputs
###

# Q{###}.json => simplified-regions-{version}.zip
zip --quiet --recurse-paths --junk-paths \
    "$release_assets"/simplified-regions-"$version".zip \
    "$import_osm_root"/06-simplify-regions/output \
    "$readme"

# countries-clipped.json => countries-geojson-{version}.zip
zip --junk-paths \
    "$release_assets"/countries-geojson-"$version".zip \
    "$import_osm_root"/07-merge-regions/output/countries-clipped.json \
    "$readme"

# subdivisions-clipped.json => subdivisions-geojson-{version}.zip
zip --junk-paths \
    "$release_assets"/subdivisions-geojson-"$version".zip \
    "$import_osm_root"/07-merge-regions/output/subdivisions-clipped.json \
    "$readme"

# regions.mbtiles => regions-mbtiles-{version}.zip
zip --junk-paths \
    "$release_assets"/regions-mbtiles-"$version".zip \
    "$import_osm_root"/11-join-tiles/output/regions.mbtiles \
    "$readme"
