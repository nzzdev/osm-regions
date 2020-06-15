#!/bin/bash
set -o errexit
set -o nounset

import_osm_root=$(dirname "$0")

rm -rf \
  "$import_osm_root"/00-static-data/output \
  "$import_osm_root"/01-list-countries/output \
  "$import_osm_root"/02-query-regions/output \
  "$import_osm_root"/03-clip-regions/output \
  "$import_osm_root"/04-reduce-regions/output \
  "$import_osm_root"/05-split-by-region/output \
  "$import_osm_root"/06-simplify-regions/output \
  "$import_osm_root"/07-merge-regions/output \
  "$import_osm_root"/08-vector-tiles/output \
  "$import_osm_root"/09-natural-earth-json/output \
  "$import_osm_root"/10-natural-earth-tiles/output \
  "$import_osm_root"/11-join-tiles/output
