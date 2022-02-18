// Boundary viewpoints to account for, when querying the OSM Overpass API
const countryBoundaryViewpoints = [
  // Case 1: Query russian (RU) boundaries without crimea region.

  // The main issue is that crimea is not listed as a separate region when querying russia
  // instead it is part of the russian boundaries (OSM tag 'admin_level = 2').
  // The best we can do, in this case, is to query russia while ignoring all results with a 'according_to:UA' tag set to 'false' on a national scale.
  // Main issue with this method is, that other areas (not regions) in russia which are not acknowledged by Ukraine will also be left out,
  // regardless of wether or not we want that.

  // Related wiki link: https://wiki.openstreetmap.org/wiki/Proposed_features/ClaimedBorders
  // Overpass Query (tested in https://overpass-turbo.eu/):
  /*     
    [out:json];
    ( relation
      [boundary=administrative]
      ["ISO3166-1"="RU"]
      ["according_to:UA"!="no"];

      relation
      [boundary=administrative]
      ["ISO3166-2"~"RU"];
    );

    out; >; out skel; 
   */
  {
    "ISO3166-1": "RU", // Country to query
    affectedAreas: [
      {
        description: "Exclude crimea region",
        "ISO3166-1": {
          exclude: {
            "according_to:UA": "no",
          },
        },
        "ISO3166-2": null,
      },
    ],
  },

  // Case 2: Query serbian (RS) boundaries without kosovo.

  // Kosovo is currently declared as a principal subdivision of Serbia ('ISO3166-2 = RS-KO') but is also being declared as an independent
  // country ('ISO3166-1 = XK', 'admin_level = 2').
  // The solution in this case is to ignore areas with Kosovo's 'ISO3166-2' value 'RS-KO', when querying Serbia.

  // Related wiki link: https://wiki.openstreetmap.org/wiki/Proposed_features/ClaimedBorders
  // Overpass Query (tested in https://overpass-turbo.eu/):
  /*     
    [out:json];
    ( 
      relation
      [boundary=administrative]
      ["ISO3166-1"="RS"];

      relation
      [boundary=administrative]
      ["ISO3166-2"~"RS"]
      ["ISO3166-2"!="RS-KO"];
    );

    out; >; out skel;
   */
  {
    "ISO3166-1": "RS", // Country to query
    affectedAreas: [
      {
        description: "Exclude Kosovo from Serbia",
        "ISO3166-1": null,
        "ISO3166-2": {
          exclude: {
            "ISO3166-2": "RS-KO",
          },
        },
      },
    ],
  },

  // TODO: Explain Kashmir case regarding all affected countries and their borders
  // TODO: Ask International Ressort about Kashmir region display
];

module.exports = countryBoundaryViewpoints;
