require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'

#http response
page = HTTParty.get 'http://www.verizonwireless.com'
#Make Nokogiri object
parse_page = Nokogiri::HTML(page)

images = []

#parse phone carousel data
nodes = parse_page.css('.phone-carousel').css('.phone-carousel-slide-wrapper')
#grab srcs by traversing through nodes
nodes.each{|node| images.push node.children.children[1].attributes['src'].to_s}

File.open("phone_images.txt", "w+") do |f|
	images.map{|image| f.puts(image) }
end
