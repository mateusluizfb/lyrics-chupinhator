# frozen_string_literal: true

require 'mechanize'
require 'twitter'
require 'open-uri'

module Application
  LYRICS_URL = 'https://www.letras.mus.br'
  LYRICS_ARTIST = 'chitaozinho-e-xororo'


  def self.find_musics
    musics_urls = find_musics_urls
    File.open('lyrics.txt', 'w') do |file|
      musics_urls.each do |url|
        file.write(get_lyric(url))
      end
    end
  end

  def self.find_musics_urls
    Mechanize.new
             .get("#{LYRICS_URL}/#{LYRICS_ARTIST}")
             .search('ul.cnt-list')
             .first
             .search('li')
             .map { |li| "#{LYRICS_URL}#{li.at('a')['href']}" }
  end

  def self.get_lyric(url)
    Mechanize.new
             .get(url)
             .search('div.cnt-letra')
             .search('p')
             .map(&:children)
             .map do |children|
               children.map(&:content).reject(&:empty?).join("\n")
             end
             .join("\n\n")
  end
end

Application.find_musics
