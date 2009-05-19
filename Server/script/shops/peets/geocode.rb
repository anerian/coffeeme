appid="QFoY1w7V34GUcrwOTlvIp46xJGhysm8wNr1kObebYVm4ny.Ef67oFgENwv8cvIKxz5fK"
require 'yaml'
require 'rubygems'
require 'geocoder'
require 'activesupport'

def cleanstr(str)
  ActiveSupport::Multibyte::Chars.new(str).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,' ').downcase.to_s.gsub(/\r|\n/,' ').gsub(/\s/, ' ').squeeze(' ')
end

if not File.exist?("stores-pass1.yml")
  STDERR.puts "run fetch.rb first"
  exit(1)
end

stores = YAML.load_file("stores-pass1.yml")

geos = []

geocoder = Geocoder::Yahoo.new appid

errors = []
for store in stores do
  address = store[:address]
  begin
    puts "lookup: #{address}"
    sleep 1.5
    result = geocoder.geocode address
    if result.success? or (result = result.first and result.precision == 'address' or result.precision == 'street' )
      geos << store.merge(:lat => result.latitude, :lng => result.longitude,
                          :city => result.city, :state => result.state, :zip => result.zip)
    else
      errors << store.merge(:details => result)
    end
  rescue Geocoder::GeocodingError => e
    puts e.message
    errors << store.merge(:details => e)
  end
end
puts "Errors: #{errors.size}"
File.open("stores.yml","w"){|f| f << geos.to_yaml }
File.open("errors.yml","w"){|f| f << errors.to_yaml }
