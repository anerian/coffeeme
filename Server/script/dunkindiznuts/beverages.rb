require 'uri'
require 'yaml'
require 'rubygems'
require 'hpricot'
require 'curb'

Sizes = ['Extra Large', 'Small', 'Medium', 'Large']
Milks = ['Skim Milk and Splenda', 'Skim', 'Splenda', 'Cream']

# Mapping values as parsed to how they're stored
DunkinToDB =
  { "Calories from Fat" => :fat_calories,
    "Trans Fat" => :trans_fat,
    "Serving Size" => :serving_size,
    "Sodium" => :sodium,
    "Cholesterol" => :cholesterol,
    "Dietary Fiber" => :fiber,
    "Protein" => :protein,
    "Total Carbohydrates" => :total_carbohydrates,
    "Saturated Fat" => :saturated_fat,
    "Total Fat" => :total_fat,
    "Calories" => :calories,
    "Sugar" => :sugars }.freeze

def fetch_drink_list
  c = Curl::Easy.new("https://www.dunkindonuts.com/aboutus/nutrition/ProductList.aspx?category=Beverages")

  c.perform

  doc = Hpricot c.body_str

  drinks = []
  (doc.at("#contentarea")/'td.emphasis').each do|td|
    (td/'a.emphasis').each do|anchor|
      drinks << {:link => anchor['href'], :name => anchor.inner_text.strip}
    end
  end
  drinks
end

# determine the drink size and milk
def drink_classifcation(name)
  size = Sizes.select{|s| name.match(s) }.first
  milk = Milks.select{|m| name.match(m) }.first
  [name, size, milk]
end

def fetch_drink_data(link,name)
  size, milk = drink_classifcation(name)
  doc = Hpricot Curl::Easy.http_get(link).body_str
  (doc/'.nutritionhead').each do|span|
    if span.inner_text == 'Nutrition Facts'
      data = {}
      key = nil
      ( span.parent.parent.parent/'span').each do|span|
        text = span.inner_text.gsub(/\302\240/,'').strip 
        next if (text == 'Nutrition Facts' or text== '' or text.match(/%$/))
        if key
          data[DunkinToDB[key]] = text if DunkinToDB.key?(key)
          key = nil
        else
          key = text
        end
      end
      data[:name] = name
      return data
    end
  end
end

drinks = fetch_drink_list
products = []
for drink in drinks do
  puts "#{drink[:name]} #{drink_classifcation(drink[:name]).inspect} => #{drink[:link]}"
  products << fetch_drink_data("https://www.dunkindonuts.com#{drink[:link]}", drink[:name])
end
puts "Total drinks: #{drinks.size}"
File.open("dunkindonuts.yml", "w") {|f| f << products.to_yaml }

#drink = fetch_drink_data("https://www.dunkindonuts.com/aboutus/nutrition/Product.aspx?Category=Beverages&id=DD-1100", "Coffee Medium")
#puts drink.inspect
