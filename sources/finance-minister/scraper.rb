#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class WikipediaDate::French
  def date_str
    super.downcase.gsub('en fonction', 'en cours')
  end
end

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Parti'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[_ name _ _ start end].freeze
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
