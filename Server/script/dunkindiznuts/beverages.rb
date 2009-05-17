require 'uri'
require 'rubygems'
require 'hpricot'
require 'curb'

Sizes = ['Extra Large', 'Small', 'Medium', 'Large']
Milks = ['Skim Milk and Splenda', 'Skim', 'Splenda', 'Cream']

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
          data[key] = text
          key = nil
        else
          key = text
        end
      end
      puts data.inspect
    end
  end
end

#drinks = fetch_drink_list
#for drink in drinks do
#  puts "#{drink[:name]} #{drink_classifcation(drink[:name]).inspect} => #{drink[:link]}"
#end
#puts "Total drinks: #{drinks.size}"

fetch_drink_data("https://www.dunkindonuts.com/aboutus/nutrition/Product.aspx?Category=Beverages&id=DD-1100", "Coffee Medium")
