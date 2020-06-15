const fs = require("fs");
const path = require("path");

function notInNaturalEarth(inputDir, filterFile) {
  const filenames = [
    "ne_10m_admin_0_countries.json",
    "ne_10m_admin_1_states_provinces.json"
  ];
  const naturalEarthRegions = filenames
    .map(filename => {
      const inputFile = path.join(inputDir, filename);
      const regions = JSON.parse(fs.readFileSync(inputFile));
      return regions.features
        .map(({ properties: { wikidata } }) => wikidata)
        .filter(wikidata => wikidata !== "");
    })
    .flat()
    .sort();
  // Mapbox style specification set exclusion filter used by tile-join
  const filter = { "*": ["!in", "wikidata", ...naturalEarthRegions] };
  fs.writeFileSync(filterFile, JSON.stringify(filter));
}

const [inputDir, filterFile] = process.argv.slice(2);
notInNaturalEarth(inputDir, filterFile);
