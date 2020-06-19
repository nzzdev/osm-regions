# Preview Website

The code in this folder powers the [preview website](https://osm-regions.netlify.app/).

It installs tippecanoe, downloads the OSM regions vector tileset, and extracts
the individual tiles (`.pbf` files) up to zoom level 8 using
[tile-join](https://github.com/mapbox/tippecanoe#tile-join).
This generates about 24k files; adding more tiles with zoom levels 9 or 10 would make the
build time out on Netlify.

This approach makes it possible to preview the content of `regions.mbtiles` without
maintaining a tile server in the back-end, and without storing the individual `.pbf`
anywhere else.

The deployment on Netlify is configured to run `build.sh` and then publish the content
of the `public` folder.

## Run locally

- Run `build.sh`
- Start a web server in the `public` folder and check the result
