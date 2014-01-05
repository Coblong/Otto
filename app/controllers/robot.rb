require 'net/http'
require 'nokogiri'

url = URI.parse('http://www.rightmove.co.uk/property-for-sale/property-27095217.html')
req = Net::HTTP::Get.new(url.path)
res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}
puts "page found"

@doc = Nokogiri::XML(res.body)
puts 'page read'

puts 'Asking price is [' + @doc.css("#propertyprice").text.strip + "]"
puts 'STC status is [' + @doc.css(".propertystatus").text + "]"

puts 'Done'