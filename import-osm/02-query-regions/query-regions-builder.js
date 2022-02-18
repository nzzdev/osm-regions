function queryRegionsBuilder(countryCode, countryBoundaryViewpoints) {
  const relevantViewpoints = countryBoundaryViewpoints.find(
    (viewpoint) => viewpoint["ISO3166-1"] === countryCode
  );
  let relationByCountryQuery = `
        relation
            [boundary=administrative]
            ["ISO3166-1"="${countryCode}"]
  `;
  let relationByRegionQuery = `
        relation
            [boundary=administrative]
            ["ISO3166-2"~"^${countryCode}"]
  `;

  if (relevantViewpoints) {
    relevantViewpoints.affectedAreas.forEach((affectedArea) => {
      const countryQueryChange = affectedArea["ISO3166-1"];
      const regionQueryChange = affectedArea["ISO3166-2"];

      if (countryQueryChange) {
        for (const [key, value] of Object.entries(countryQueryChange.exclude)) {
          relationByCountryQuery += `["${key}"!="${value}"]`;
        }
      }

      if (regionQueryChange) {
        for (const [key, value] of Object.entries(regionQueryChange.exclude)) {
          relationByRegionQuery += `["${key}"!="${value}"]`;
        }
      }
    });
  }

  let query = `[out:json]; (${relationByCountryQuery};${relationByRegionQuery};); out; >; out skel;`;

  return query;
}

module.exports = queryRegionsBuilder;
