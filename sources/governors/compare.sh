#!/bin/bash

cd $(dirname $0)

bundle exec ruby scraper.rb $(jq -r .source meta.json) |
  qsv select id,name,position,province,provinceLabel |
  qsv rename item,itemLabel,positionLabel,province,provinceLabel > scraped.csv

wd sparql -f csv wikidata.js |
  sed -e 's/T00:00:00Z//g' -e 's#http://www.wikidata.org/entity/##g' |
  qsv dedup -s psid |
  qsv select item,name,position,positionLabel,province,provinceLabel,source,sourceDate,psid |
  qsv rename item,itemLabel,position,positionLabel,province,provinceLabel,source,sourceDate,psid > wikidata.csv

bundle exec ruby diff.rb | tee diff.csv

cd ~-
