const reduceRegionsByCountry = require("./reduce-regions-by-country.js");
const fs = require("fs");
const path = require("path");

function reduceRegions(countriesFile, inputDir, outputDir) {
  const countries = JSON.parse(fs.readFileSync(countriesFile));
  for (const country of countries) {
    const countryCode = country["ISO3166-1"];
    console.log(`Reducing regions for country ${countryCode}...`);

    const inputFile = path.join(inputDir, `${countryCode}.json`);
    const geojson = JSON.parse(fs.readFileSync(inputFile));
    reduceRegionsByCountry(geojson.features);

    const outputFile = path.join(outputDir, `${countryCode}.json`);
    fs.writeFileSync(outputFile, JSON.stringify(geojson));
  }
}

const [countriesFile, inputDir, outputDir] = process.argv.slice(2);
reduceRegions(countriesFile, inputDir, outputDir);
