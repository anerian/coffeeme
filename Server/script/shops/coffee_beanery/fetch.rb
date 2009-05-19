require 'yaml'
require 'rubygems'
require 'curb'
require 'hpricot'
require 'activesupport'

def cleanstr(str)
  ActiveSupport::Multibyte::Chars.new(str).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,' ').downcase.to_s.gsub(/\r|\n/,' ').gsub(/\s/, ' ').squeeze(' ')
end

url = "http://www.coffeebeanery.com/information/"

start = 180
last = 199

counter = start

stores = []

begin
  request_url = "#{url}?page_id=#{counter}"
  puts "\tfetching: #{request_url}"
  c = Curl::Easy.new(request_url){|conf| conf.follow_location = true }
  c.perform
  if c.last_effective_url != request_url
    puts "SKIPPING(#{counter}): #{c.last_effective_url} <=> #{c.url}"
    counter += 1 # increment
    next
  end
  # parse 
  puts "\treceived: #{c.last_effective_url}"
  doc = Hpricot(c.body_str)
  post = doc.at("#post-#{counter}")
  (post/'.storeLocation').each do|loc|
    parts          = (loc/'li')
    begin
    name           = parts[0].inner_text
    street         = parts[1].inner_text
    city_state_zip = parts[2].inner_text
    address        = "#{street} #{city_state_zip}"
    phone          = parts[3].inner_text
    stores << { :name => name, :address => address, :street => street, :phone => phone }
    rescue => e
      puts e.message
      puts parts.inspect
      next
    end
  end
  counter += 1 # increment
end until counter == last
puts stores.inspect
File.open("stores-pass1.yml","w"){|f| f << stores.to_yaml }
