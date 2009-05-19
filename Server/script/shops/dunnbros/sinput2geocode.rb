appid="QFoY1w7V34GUcrwOTlvIp46xJGhysm8wNr1kObebYVm4ny.Ef67oFgENwv8cvIKxz5fK"
require 'yaml'
require 'rubygems'
require 'geocoder'
require 'curb'
require 'hpricot'
require 'activesupport'

input = "input.txt"
geocoder = Geocoder::Yahoo.new appid
count = 0

stores = []
nogeo = []

File.read(input).each_line do|line|
  
  parts = line.strip.split(' ')
  phone = parts.pop
  c = 0
  for i in parts do
    if i.match(/^\d*$/)
      parts[c-1] += ","
      break
    end
    c += 1
  end
  parts = parts.join(' ').split(',')
  name = parts.first
  address = parts.last.gsub(/\//,' ').strip

  puts address.inspect
  puts phone.inspect

  begin
  result = geocoder.geocode address

  if result.success? or (result = result.first and result.precision == 'address' or result.precision == 'street' )
    puts "lat: #{result.latitude}"
    puts "lng: #{result.longitude}"
    stores << {:name => name, :address => address, :phone => phone, :lat => result.latitude, :lng => result.longitude}
  else
    nogeo << {:name => name, :address => address, :phone => phone, :line => line, :details => result }
    count += 1
  end
  rescue Geocoder::GeocodingError => e
    puts e.inspect
    puts address.inspect
    nogeo << {:name => name, :address => address, :phone => phone, :line => line }
    count += 1
  end

end
puts "error geocoding: #{count}"
File.open("stores.yml", "w") {|f| f << stores.to_yaml }
nogeo.each do|fs|
  puts fs.inspect
end
File.open("errors.yml", "w") {|f| f << nogeo.to_yaml }
