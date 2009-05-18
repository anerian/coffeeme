appid="QFoY1w7V34GUcrwOTlvIp46xJGhysm8wNr1kObebYVm4ny.Ef67oFgENwv8cvIKxz5fK"
require 'rubygems'
require 'geocoder'
require 'curb'
require 'hpricot'
require 'activesupport'

url = 'http://www.saxbyscoffee.com/main/national.html'

doc = Hpricot Curl::Easy.http_get(url).body_str
td = ((doc/'table')[2]/'td')[1]
stores = []
(td/'.titlenav').each do|p|
  next if p.inner_text == 'COMING SOON'
  parts = []
  name = p.at('.bodytext2')
  name = name.inner_text if name
  (p/'.bodytext').each do|bt|
    text = bt.inner_text.strip
    parts << text if text != ''
  end
  if parts.size == 1
    store = parts[0]
    next if store.strip == ''
    parts = store.strip.split("\r\n")
    next if parts[1].nil?
    address = parts[0] + parts[1]
    phone = parts[2]
  elsif parts.size > 1
    address = parts[0]
    phone = parts[1]
  else
    next
  end
  next if name.nil?
  name = ActiveSupport::Multibyte::Chars.new(name).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,' ').downcase.to_s.gsub(/\r|\n/,' ').gsub(/\s/, ' ').squeeze(' ')
  address = ActiveSupport::Multibyte::Chars.new(address).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,' ').downcase.to_s.gsub(/\r|\n/,' ').gsub(/\s/, ' ').squeeze(' ')
  if phone.nil?
    puts name.inspect
    puts address.inspect
    phone = p.next_sibling.inner_text
  end
  phone = ActiveSupport::Multibyte::Chars.new(phone).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,' ').downcase.to_s.gsub(/\r|\n/,' ').gsub(/\s/, ' ').squeeze(' ')

  address.gsub!(/\(plus drive-thru\)/,'')
  address.gsub!(/drive-thru location/,'')

  store = { :name => name.strip, :address => address.strip, :phone => phone.strip }
  puts store.inspect
  stores << store
end
puts stores.size

#exit
geocoder = Geocoder::Yahoo.new appid

errors = 0
File.open("saxsbys.csv", "w") do|f|
  for s in stores do
    result = geocoder.geocode s[:address]
#    puts "----"
#    puts "address: #{s[:address]}"
#    puts "phone: #{ s[:phone] }"
#    puts "lat: #{result.latitude}"
#    puts "lng: #{result.longitude}"
#    puts "----"
    if result.success?
      f << %("#{s[:name]}","#{result.address}",,"#{result.city}","#{result.state}","#{result.zip}","#{s[:phone]}",#{result.latitude},#{result.longitude}\r\n)
    else
      if result.first.precision != 'address'
        result = geocoder.geocode s[:name] + ' ' + s[:address]
        if result.success?
          f << %("#{s[:name]}","#{result.address}",,"#{result.city}","#{result.state}","#{result.zip}","#{s[:phone]}",#{result.latitude},#{result.longitude}\r\n)
        elsif result.first.warning.nil? or result.first.warning.match( 'The exact location could not be found, here is the closest match:' )
          result = result.first
          f << %("#{s[:name]}","#{result.address}",,"#{result.city}","#{result.state}","#{result.zip}","#{s[:phone]}",#{result.latitude},#{result.longitude}\r\n)
        else
          puts "address: #{s[:address]}"
          puts "data check #{result.inspect} searching for #{s[:address].inspect}"
          errors += 1
        end
      else
        if result.first.warning.nil? or result.first.warning.match( 'The exact location could not be found, here is the closest match:' )
          result = result.first
          f << %("#{s[:name]}","#{result.address}",,"#{result.city}","#{result.state}","#{result.zip}","#{s[:phone]}",#{result.latitude},#{result.longitude}\r\n)
        else
          puts "address: #{s[:address]}"
          puts "data check #{result.inspect} searching for #{s[:address].inspect}"
          errors += 1
        end
      end
    end
  end
end

puts stores.size - errors

#result = geocoder.geocode "1140 Old York Road Abington, PA 19001"
#puts result.inspect
