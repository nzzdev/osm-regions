const queryRegionsByCountry = require("./query-regions-by-country");
const fs = require("fs");
const path = require("path");

async function queryRegions(countriesFile, outputDir) {
  const countries = JSON.parse(fs.readFileSync(countriesFile));
  const allRegions = new Set();
  for (const country of countries) {
    const countryCode = country["ISO3166-1"];
    console.log(`Querying regions for country ${countryCode}...`);

    const rawDataPath = path.join(outputDir, "raw", `${countryCode}.json`);
    let oldRawData;
    if (fs.existsSync(rawDataPath)) {
      oldRawData = JSON.parse(fs.readFileSync(rawDataPath));
    }

    const { geojson, rawData } = await queryRegionsByCountry(
      countryCode,
      oldRawData
    );
    if (!oldRawData) {
      fs.writeFileSync(rawDataPath, JSON.stringify(rawData));
    }
    const outputFile = path.join(outputDir, `${countryCode}.json`);
    fs.writeFileSync(outputFile, JSON.stringify(geojson));

    geojson.features.forEach(({ properties: { wikidata } }) => {
      allRegions.add(wikidata);
    });
  }
  const listFile = path.join(outputDir, `list/list.json`);
  fs.writeFileSync(listFile, JSON.stringify(Array.from(allRegions).sort()));
}

const [countriesFile, outputDir] = process.argv.slice(2);
queryRegions(countriesFile, outputDir);
