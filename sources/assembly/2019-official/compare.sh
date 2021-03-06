#!/bin/bash

cd $(dirname $0)

bundle exec ruby scraper.rb $(jq -r .source meta.json) |
  qsv select id,name,party,circonscript,gender |
  qsv rename id,itemLabel,partyLabel,areaLabel,gender > scraped.csv

wd sparql -f csv wikidata.js | sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' | qsv dedup -s psid | qsv sort -s itemLabel,startDate > wikidata.csv

bundle exec ruby diff.rb | qsv sort -s itemlabel | tee diff.csv

cd ~-
