require 'rest-client'
require 'json'
require 'addressable/uri'
require 'nokogiri'

def get_coords(address)
  url = Addressable::URI.new(
    scheme: "https",
    host: "maps.googleapis.com",
    path: "maps/api/geocode/json",
    query_values: {
      key: $api_key,
      address: address
      }
    ).to_s
  response = RestClient.get(url)
  coords = JSON.parse(response)["results"].first["geometry"]["location"]
end

$api_key = File.read('.api_key').chomp
address = "1061 Market St, San Francisco, CA"
coords = get_coords(address).values

def nearby_search(coords, query)
  url = Addressable::URI.new(
    scheme: "https",
    host: "maps.googleapis.com",
    path: "maps/api/place/nearbysearch/json",
    query_values: {
      key: $api_key,
      location: coords.join(","),
      radius: 300,
      sensor: false,
      keyword: query
    }
  ).to_s
  response = RestClient.get(url)
  JSON.parse(response)["results"]
  .map do |result|
    result["vicinity"]
  end
end

def directions(from, to)
  url = Addressable::URI.new(
    scheme: "https",
    host: "maps.googleapis.com",
    path: "maps/api/directions/json",
    query_values: {
      origin: from,
      destination: to
      }
    ).to_s
    puts url
  response = RestClient.get(url)
  steps = JSON.parse(response)["routes"].first["legs"].first["steps"]
  steps.map do |step|
    Nokogiri::HTML(step["html_instructions"]).text
  end.join("\n")
end

stores = nearby_search(coords, "ice cream")

puts directions(address, store)