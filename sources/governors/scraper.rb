#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Members
    decorator RemoveReferences
    decorator UnspanAllTables
    decorator WikidataIdsDecorator::Links

    def member_container
      noko.xpath('//table[.//tr[contains(., "Gouverneur")]]//tr[td]//td[2]//a')
    end
  end

  class Member
    field :id do
      noko.attr('wikidata')
    end

    field :name do
      noko.text.tidy
    end

    field :province do
      province_node.attr('wikidata')
    end

    field :provinceLabel do
      province_node.text.tidy
    end

    field :position do
      "Governor of #{provinceLabel}"
    end

    private

    def province_node
      noko.xpath('ancestor::tr//td[1]/a')
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
