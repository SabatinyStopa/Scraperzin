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
  puts "Adicionado a página"
  create_file(phrases)
  puts "Criado arquivo. Da uma olhada lá"
  puts "Obrigado!"
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
  puts "Criado arquivo. Da uma olhada lá"
  puts "Obrigado!"

end

def create_file(array)
  File.open("Frases.txt", 'w') do |file|
    file.puts array
  end
end

def menu
  while(true)
    puts "Digite 1 para buscar no site todo ou 2 para uma página única"
    value = gets.chomp
    if value == "1"
      puts "Site todo escolhido."
      puts "Digite a url do site: "
      url = gets.chomp
      puts "Digite a classe: (ex: p.frase)"
      css_div = gets.chomp
      puts "Total de páginas que você quer: "
      total_pages = gets.chomp
      all_site_scraper(url, css_div, total_pages.to_i)
    else
      puts "Uma página apenas escolhida."
      puts "Digite a url do site: "
      url = gets.chomp
      puts "Digite a classe: (ex: p.frase)"
      css_div = gets.chomp
      single_page_scraper(url, css_div)
    end
  end
end

menu

# ('https://www.frasesdobem.com.br/frases-de-aniversario/page/1', 'p.frase')
