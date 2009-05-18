require 'yaml'
require 'rubygems'
require 'curb'
require 'hpricot'
require 'activesupport'

test_url = 'http://www.cariboucoffee.com/page/1/beverage-food-detail.jsp?id=1466&type=drink'

# there is also the JUNIOR but those pages do not exist for all drinks
Sizes = ['JUNIOR', 'SMALL', 'MEDIUM', 'LARGE' ].freeze
Milks = ['SKIM', 'TWO_PERCENT', 'SOY'].freeze

# Mapping values as parsed to how they're stored
CaribouToDB =
  { "Fat Calories" => :fat_calories,
    "Trans Fat" => :trans_fat,
    "Serving Size" => :serving_size,
    "Sodium" => :sodium,
    "Cholesterol" => :cholesterol,
    "Fiber" => :fiber,
    "Protein" => :protein,
    "Total Carbohydrates" => :total_carbohydrates,
    "Saturated Fat" => :saturated_fat,
    "Total Fat" => :total_fat,
    "Calories" => :calories,
    "Caffeine" => :caffeine, # Only found in Caribou so far
    "Surgars" => :sugars }.freeze

class String
  def cleanstr
    ActiveSupport::Multibyte::Chars.new(self).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,' ').downcase.to_s.gsub(/\r|\n/,' ').gsub(/\s/, ' ').squeeze(' ')
  end
end

# get all drink combinations
def fetch_drink_page(name, url, size, milk)
  doc = Hpricot Curl::Easy.http_get(url).body_str
  key = nil
  data = {}

  (doc.at('#nutrition')/:td).each do|td|
    value = td.inner_text.gsub(/\(.*\)/,'').strip
    if key.nil?
      key = value
    else
      data[CaribouToDB[key]] = value if CaribouToDB.key?(key)
      key = nil
    end
  end
  data[:name] = ((doc.at("#content h1").inner_text) || name).cleanstr
  data[:size] = size
  data[:milk] = milk
  data
end

def fetch_drink_list(url)
  doc = Hpricot Curl::Easy.http_get(url).body_str
  refs = []
  (doc.at('#content')/'.menuList').each do|mlist|
    (mlist/'a').each do|anchor|
      refs << { :name => anchor.inner_text.cleanstr.gsub(/,/,' ').strip, :link => anchor['href'] }
    end
  end
  refs
end

# test
#puts fetch_drink_page("Latte", test_url).inspect

# fetch the drink list
drink_refs = fetch_drink_list("http://www.cariboucoffee.com/page/1/menu-nutrition.jsp")
puts drink_refs.size

products = []
for drink_ref in drink_refs do
  # for each link, iterate through Sizes and Milks
  Sizes.each do|size|
    Milks.each do|milk|
      link = "http://www.cariboucoffee.com#{drink_ref[:link]}&size=#{size}&milk=#{milk}"
      puts "fetch #{drink_ref[:name]} at #{link}"
      begin
        products << fetch_drink_page(drink_ref[:name], link, size, milk)
      rescue => e
        puts "#{e.message} #{e.backtrace.join("\n")}"
      end
    end
  end
end
puts "Total drinks: #{products.size}"
File.open("caribou.yml", "w") {|f| f << products.to_yaml }
