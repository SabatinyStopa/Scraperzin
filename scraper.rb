require 'nokogiri'
require 'httparty'
require 'byebug'

def single_page_scraper(url, css_div)
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  phrases = Array.new
  phrases_listings = parsed_page.css(css_div)

  phrases_listings.each do |phrase|
    phrases << phrase.text.gsub(/\s+/, " ")
  end
  byebug
end

def all_site_scraper(url, css_div, total_pages)
  phrases = Array.new
  page = 1
  
  while page <= total_pages
    pagination_url = "#{url}#{page}"
    pagination_unparsed_page = HTTParty.get(pagination_url)
    pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
    pagination_phrases_listings = pagination_parsed_page.css(css_div)

    pagination_phrases_listings.each do |phrase|
      phrases << phrase.text.gsub(/\s+/, " ")
    end
    puts "Adicionado página: #{page}"
    page += 1
  end
  create_file(phrases)
  byebug

end

def create_file(array)
  File.open("Frases.txt", 'w') do |file|
    file.puts array
  end
end

all_site_scraper('https://www.frasesdobem.com.br/frases-de-aniversario/page/', 'p.frase', 3)