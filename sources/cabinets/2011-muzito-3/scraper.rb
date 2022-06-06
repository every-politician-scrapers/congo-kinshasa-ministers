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
      noko.xpath("//table[.//th[contains(.,'Fonction')]]//tr[td]")
    end
  end

  class Member
    field :id do
      name_node.attr('wikidata')
    end

    field :name do
      name_node.text.tidy
    end

    field :positionID do
    end

    field :position do
      raw_position.prepend(section == 'Vice-Ministres' ? 'Vice-ministre, ' : '')
    end

    field :startDate do
    end

    field :endDate do
    end

    private

    def tds
      noko.css('td')
    end

    def name_node
      tds[2].css('a').first
    end

    def section
      noko.xpath('preceding::h3[1]/span[@class="mw-headline"]').text.tidy
    end

    def raw_position
      tds[1].text.tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url).csv
