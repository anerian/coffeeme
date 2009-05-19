appid="QFoY1w7V34GUcrwOTlvIp46xJGhysm8wNr1kObebYVm4ny.Ef67oFgENwv8cvIKxz5fK"
require 'rubygems'
require 'geocoder'
require 'curb'
require 'hpricot'
require 'activesupport'

def cleanstr(str)
  ActiveSupport::Multibyte::Chars.new(str).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,' ').downcase.to_s.gsub(/\r|\n/,' ').gsub(/\s/, ' ').squeeze(' ')
end

url = "http://www.peets.com/stores/store_list.asp"
c = Curl::Easy.new(url) do|conf|
  conf.headers["User-Agent"] = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en; rv:1.8.1.21) Gecko/20090327 Camino/1.6.7 (like Firefox/2.0.0.21pre)"
  conf.follow_location = true
end
c.perform
doc = Hpricot c.body_str
(doc.at("table[@width='578']")/"td[@width='33%']").each do|td|
  parts = td.inner_text.strip.split("\r\n").map{|p| p.strip }.select{|p| p != '' }
  begin
  puts parts.size
  name = cleanstr(parts[0])
  address = cleanstr(parts[1])
  phone = cleanstr(parts[2])
  times = cleanstr(parts[3..parts.size].join(' '))
  puts "name: #{name}, address: #{address}, phone: #{phone}, times: #{times}"
  rescue => e
    puts e.message
    puts parts.inspect
    break
  end
end
