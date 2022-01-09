#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

require 'open-uri/cached'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Portrait'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no img name start end].freeze
    end

    def tds
      noko.css('td,th')
    end

    def empty?
      (tds[1].text == tds[2].text) || !country.include?('Democratic Republic of the Congo')
    end

    def country
      noko.xpath('preceding::h3[1]').text.tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
