#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class Legislature
  # details for an individual member
  class Member < Scraped::HTML
    field :id do
      tds[0].attr('data-order').tidy
    end

    field :name do
      tds[1].attr('data-order').tidy
    end

    field :party do
      tds[5].attr('data-order').tidy
    end

    field :province do
      tds[4].attr('data-order').tidy
    end

    field :circonscript do
      tds[3].attr('data-order').tidy
    end

    field :gender do
      tds[2].attr('data-order')
    end

    field :gender do
      return 'male' if raw_gender == 'M'
      return 'female' if raw_gender == 'F'
    end

    def skip?
      name.to_s.empty?
    end

    private

    def tds
      noko.css('td')
    end

    def raw_gender
      tds[2].attr('data-order')
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      noko.xpath('//table[.//tr[contains(.,"CIRCONSCRIPT")]]//tr[td]').map { |mp| fragment(mp => Member) }.reject(&:skip?).map(&:to_h)
    end
  end
end

file = Pathname.new 'scraped.html'
puts EveryPoliticianScraper::FileData.new(file, klass: Legislature::Members).csv
