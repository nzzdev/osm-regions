#!/bin/bash
set -o errexit
set -o nounset

import_osm_root=$(dirname "$0")

"$import_osm_root"/01-list-countries/list-countries.sh
"$import_osm_root"/02-query-regions/query-regions.sh
"$import_osm_root"/03-clip-regions/clip-regions.sh
"$import_osm_root"/04-reduce-regions/reduce-regions.sh
"$import_osm_root"/05-split-by-region/split-by-region.sh
"$import_osm_root"/06-simplify-regions/simplify-regions.sh
"$import_osm_root"/07-merge-regions/merge-regions.sh
"$import_osm_root"/08-vector-tiles/vector-tiles.sh
"$import_osm_root"/09-natural-earth-json/natural-earth-json.sh
"$import_osm_root"/10-natural-earth-tiles/natural-earth-tiles.sh
"$import_osm_root"/11-join-tiles/join-tiles.sh
