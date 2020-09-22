#!/bin/bash
set -o errexit
set -o nounset

# Enter directory of build script, so relative paths below are working
cd $(dirname "$0")

# Build tippecanoe
(
  mkdir -p build/tippecanoe
  cd build/tippecanoe
  curl -L https://github.com/mapbox/tippecanoe/archive/1.35.0.tar.gz | tar xz --strip-components=1
  make -j
)

# Download and extract tileset
curl -L -o build/regions.zip https://github.com/nzzdev/osm-regions/releases/download/v0.2.0/regions-mbtiles-v0.2.0.zip
unzip build/regions.zip -d build

# Extract tiles
./build/tippecanoe/tile-join \
  --no-tile-compression \
  --no-tile-size-limit \
  --maximum-zoom=8 \
  --output-to-directory=public/tiles \
  build/regions.mbtiles 

