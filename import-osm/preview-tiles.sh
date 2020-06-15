#!/bin/bash
set -o errexit
set -o nounset

import_osm_root=$(dirname "$0")

npx opener "$import_osm_root"/preview-tiles/preview-tiles.html
npx tileserver-gl-light --config "$import_osm_root"/preview-tiles/tileserver-config.json
