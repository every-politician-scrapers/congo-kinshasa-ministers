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
      noko.xpath('//h2[contains(., "inistre")]//following::ul[1]//li[a]')
    end
  end

  class Member
    field :id do
      name_node.attr('wikidata')
    end

    field :name do
      name_node.text.tidy.gsub(/\.$/, '')
    end

    field :positionID do
    end

    field :position do
      return 'Commerce extérieur' if ['Kasongo Ilunga', 'Denis Mbuyu Manga'].include?(name)

      raw_position.prepend(section == 'Vice-ministres' ? 'Vice-ministre, ' : '')
    end

    field :startDate do
    end

    field :endDate do
    end

    private

    def name_node
      noko.css('a').first
    end

    def section
      noko.xpath('preceding::h2[1]/span[@class="mw-headline"]').text.tidy
    end

    def raw_position
      noko.text.split(':').first.tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
