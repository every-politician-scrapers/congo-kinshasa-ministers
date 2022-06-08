const fs = require('fs');
let rawmeta = fs.readFileSync('meta.json');
let meta = JSON.parse(rawmeta);

module.exports = function () {
  return `SELECT DISTINCT ?province ?provinceLabel ?position ?positionLabel ?item ?name
         ?source ?sourceDate (STRAFTER(STR(?held), '/statement/') AS ?psid)
  WHERE {
    ?position wdt:P279 wd:Q132050 ; wdt:P17 wd:Q974 ; wdt:P1001 ?province .
    MINUS { ?province wdt:P576 [] }
    OPTIONAL {
      ?item wdt:P31 wd:Q5 ; p:P39 ?held .
      OPTIONAL { ?item wdt:P569 ?dob }

      ?held ps:P39 ?position ; pq:P580 ?start .
      FILTER NOT EXISTS { ?held pq:P582 ?end }

      OPTIONAL {
        ?held prov:wasDerivedFrom ?ref .
        ?ref pr:P4656 ?source FILTER CONTAINS(STR(?source), '${meta.source.url}') .
        OPTIONAL { ?ref pr:P1810 ?sourceName }
        OPTIONAL { ?ref pr:P1932 ?statedName }
        OPTIONAL { ?ref pr:P813  ?sourceDate }
      }
      OPTIONAL { ?item rdfs:label ?wdLabel FILTER(LANG(?wdLabel) = "en") }
      BIND(COALESCE(?sourceName, ?wdLabel) AS ?name)

      OPTIONAL { ?position rdfs:label ?posLabel FILTER(LANG(?posLabel) = "en") }
      BIND(COALESCE(?statedName, ?posLabel) AS ?positionLabel)
    }

    SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
  } # ${new Date().toISOString()}
  ORDER BY ?provinceLabel ?sourceDate`
}
