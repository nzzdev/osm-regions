const map = new mapboxgl.Map({
  container: document.getElementById("map"),
  hash: true,
  style:
    "https://api.maptiler.com/maps/positron/style.json?key=qdSqvQdaTpTPAsu0YByB",
});

map.on("load", () => {
  // Add regions as source
  map.addSource("regions", {
    maxzoom: 10,
    promoteId: "wikidata",
    type: "vector",
    tiles: ["http://localhost:8080/data/regions/{z}/{x}/{y}.pbf"],
  });

  ["countries", "subdivisions"].forEach((regionType, i) => {
    const visibility = ["visible", "none"][i];

    // Fill polygons blue, with highlight on mouseover
    map.addLayer({
      id: `${regionType}-area`,
      type: "fill",
      source: "regions",
      "source-layer": regionType,
      paint: {
        "fill-color": [
          "case",
          ["boolean", ["feature-state", "mouseover"], false],
          "#fad250",
          "steelblue",
        ],
        "fill-opacity": [
          "case",
          ["boolean", ["feature-state", "mouseover"], false],
          0.4,
          0.1,
        ],
      },
      layout: { visibility },
    });

    // Add blue outline
    map.addLayer({
      id: `${regionType}-outline`,
      type: "line",
      source: "regions",
      "source-layer": regionType,
      paint: {
        "line-width": 1,
        "line-color": "steelblue",
      },
      layout: { visibility },
    });

    // Show attributes on mouseover
    const popup = new mapboxgl.Popup({
      closeButton: false,
      closeOnClick: false,
    });

    let oldFeatures = [];

    map.on("mousemove", `${regionType}-area`, ({ features, lngLat }) => {
      if (features.length) {
        map.getCanvas().style.cursor = "pointer";

        // Update highlighting of features
        setMouseoverState(oldFeatures, false);
        setMouseoverState(features, true);
        oldFeatures = features;

        // Show popup at mouse location
        const wikidataIds = features.map(
          ({ properties: { wikidata } }) => wikidata
        );
        popup
          .setLngLat(lngLat)
          .setHTML(`<div>${wikidataIds.join(", ")}</div>`)
          .addTo(map);
      }
    });

    map.on("mouseleave", `${regionType}-area`, ({ features }) => {
      map.getCanvas().style.cursor = "";

      // Remove highlighting from features
      setMouseoverState(oldFeatures, false);

      popup.remove();
    });
  });

  // Adapted from https://docs.mapbox.com/mapbox-gl-js/example/toggle-layers/
  const toggleableLayers = {
    countries: "Countries",
    subdivisions: "Subdivisions",
  };
  Object.entries(toggleableLayers).forEach(([id, name]) => {
    const link = document.createElement("a");
    link.href = "#";
    link.id = id;
    link.textContent = name;
    if (map.getLayoutProperty(`${id}-area`, "visibility") !== "none") {
      link.className = "active";
    }

    link.onclick = function (event) {
      event.preventDefault();
      event.stopPropagation();

      const visibility = map.getLayoutProperty(`${this.id}-area`, "visibility");

      if (visibility === "none") {
        this.className = "active";
        map.setLayoutProperty(`${this.id}-area`, "visibility", "visible");
        map.setLayoutProperty(`${this.id}-outline`, "visibility", "visible");
      } else {
        map.setLayoutProperty(`${this.id}-area`, "visibility", "none");
        map.setLayoutProperty(`${this.id}-outline`, "visibility", "none");
        this.className = "";
      }
    };

    const layers = document.getElementById("menu");
    layers.appendChild(link);
  });
});

function setMouseoverState(features, state) {
  features.forEach((feature) => {
    map.setFeatureState(feature, { mouseover: state });
  });
}
