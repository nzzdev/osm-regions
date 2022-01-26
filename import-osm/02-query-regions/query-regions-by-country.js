const fs = require("fs");
const { geoBounds } = require("d3-geo");
const queryOverpassWithCallback = require("query-overpass");
const turf = require("@turf/turf");

async function queryRegionsByCountry(countryCode, overpassResult) {
  const query = `
    [out:json];

    (
      relation
        [boundary=administrative]
        ["ISO3166-1"="${countryCode}"];

      relation
        [boundary=administrative]
        ["ISO3166-2"~"^${countryCode}"];
    );
    
    out; >; out skel;`;
  const keepTags = [
    "ISO3166-1",
    "ISO3166-2",
    "admin_level",
    "wikidata",
    "name",
    "name:de",
    "name:en",
  ];

  if (overpassResult) {
    console.log("Reuse existing data");
  } else {
    overpassResult = await queryOverpass(query);
  }

  const geojson = await parseOverpassResult(
    overpassResult,
    keepTags,
    countryCode
  );

  return {
    geojson,
    rawData: overpassResult,
  };
}

function queryOverpass(query) {
  return new Promise((resolve) => {
    const runQuery = () => {
      queryOverpassWithCallback(query, (error, data) => {
        if (error) {
          if (error.statusCode === 429) {
            console.log("Too many requests, will retry in 30 seconds...");
            sleep(30).then(runQuery);
          } else if (error.statusCode === 504) {
            console.log("Gateway timeout, will retry in 30 seconds...");
            sleep(30).then(runQuery);
          } else {
            throw error;
          }
        } else {
          console.log("Query done");
          resolve(data);
        }
      });
    };

    runQuery();
  });
}

function sleep(seconds) {
  return new Promise((resolve) => setTimeout(resolve, seconds * 1000));
}

async function parseOverpassResult(overpassResult, keepTags, countryCode) {
  const geojson = turf.clone(overpassResult);

  // Add bounding box
  geojson.bbox = getBbox(geojson);

  // Keep only Polygon and MultiPolygon features
  geojson.features = geojson.features.filter((feature) => {
    const { type } = feature.geometry;
    return type === "Polygon" || type === "MultiPolygon";
  });

  geojson.features.forEach((feature) => {
    // Keep only a subset of tags
    const { tags } = feature.properties;
    const properties = {};
    keepTags.forEach((keepTag) => {
      if (tags[keepTag] === undefined) {
        properties[keepTag] = null;
      } else {
        properties[keepTag] = tags[keepTag];
      }
    });

    // Add OSM relation id as property and remove feature id
    properties.osmRelationId = parseInt(feature.id.split("/")[1]);
    delete feature.id;

    // Set type to country / subdivision
    // ---
    // Some regions (usually "dependent territories") are both countries and subdivisions and also
    // have a separate ISO3166-1 country code, in addition to the ISO3166-2 subdivision code.
    // For example American Samoa has these codes:
    //    ISO3166-1: AS, ISO3166-2: US-AS
    // These regions will be labeled as "subdivision" here.
    // See https://en.wikipedia.org/wiki/ISO_3166-2#Subdivisions_included_in_ISO_3166-1
    if (properties["ISO3166-1"] === countryCode) {
      properties.type = "country";
    } else if (properties["ISO3166-2"]) {
      properties.type = "subdivision";
      properties["ISO3166-1"] = countryCode;
    }

    feature.properties = properties;
  });

  // Remove duplicate wikidata entries
  const featuresByWikidata = {};
  geojson.features.forEach((feature) => {
    const { wikidata } = feature.properties;
    if (wikidata) {
      if (!featuresByWikidata[wikidata]) {
        featuresByWikidata[wikidata] = [];
      }
      featuresByWikidata[wikidata].push(feature);
    } else {
      console.warn(
        "Discarded feature without wikidata tag",
        JSON.stringify(feature.properties)
      );
    }
  });
  geojson.features = [];
  Object.values(featuresByWikidata).forEach((features) => {
    features.sort(
      (a, b) => a.properties.admin_level - b.properties.admin_level
    );
    geojson.features.push(features[0]);
    if (features.length > 1) {
      console.log(
        `Discarded ${features.length - 1} features with duplicate wikidata tags`
      );
    }
  });

  return geojson;
}

function getBbox(geojson) {
  // D3 required the opposite of the standard (RFC 7946) GeoJSON winding order:
  // The exterior ring for polygons must be clockwise.
  const geojsonClockwise = turf.rewind(geojson, {
    reverse: true,
  });
  // D3 instead of turf is used to get a correct bounding box for countries that
  // cross the antimeridian (180° east/west), for example Russia, United States
  return geoBounds(geojsonClockwise).flat();
}

if (require.main === module) {
  queryRegionsByCountry("CH").then(({ geojson }) => {
    fs.writeFileSync("CH-regions.json", JSON.stringify(geojson));
  });
}

module.exports = queryRegionsByCountry;
