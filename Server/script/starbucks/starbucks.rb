require 'rubygems'
require 'hpricot'
require 'curb'
require 'yaml'
#require 'json'

start_category = "CEFE1DE0-7395-4FE6-ACF3-61EBB884A380"

# parse a single set of options
def fetch_all_combinations(category)
  c = Curl::Easy.new("http://www.starbucks.com/retail/nutrition_comparison_popup.asp?category={#{category}}")

  c.perform

  doc = Hpricot( c.body_str )

  category = nil
  subcategory = nil
  # have to run through a number of options
  (doc/"input").each do|input|
    case input['name']
    when 'category' then category = input['value']
    when 'subcategory' then subcategory = input['value']
    end
  end

  milks = []
  sizes = []

  (doc/"select").each do|select|
    optvalues = []  
    (select/"option").each do|opt|
      optvalues << {:value => opt['value'], :name => opt.inner_text}
    end
    case select['name']
    when 'milk'
      milks = optvalues
    when 'size'
      sizes = optvalues
    end
  end

  {
    :category => category,
    :subcategory => subcategory,
    :milks => milks,
    :sizes => sizes
  }
end

# returns the number of pages
def locate_paginate(doc)
  anchors = (doc/'a')
  page_numbers = []
  anchors.each do|anchor|
    href = anchor["href"]
    if href and href.match(/nutrition_comparison_popup/) and href.match(/page=/)
      page_numbers << href.scan(/page=(\d*)/).flatten.map{|i| i.first.to_i }.first
    end
  end
  page_numbers.uniq!
  puts page_numbers.inspect
  page_numbers
end

def fetch_nutrition_table_for(category, subcategory, milk, size)
  c = Curl::Easy.new("http://www.starbucks.com/retail/nutrition_comparison_popup.asp?category={#{category}}&subcategory=#{subcategory}&milk=#{milk}&size=#{size}")

  c.perform

  doc = Hpricot c.body_str
  other_pages = locate_paginate(doc)
  products = []

  begin

    item = []
    count = 0
    # ha starbucks and their icky tables... oh copytext how nice
    (doc/'span.copytext').each do|copy|
      if count == 13
        # map each item component to a name
        product = {}
        product[:name] = item[0]
        product[:serving_size] = item[1]
        product[:calories] = item[2]
        product[:fat_calories] = item[3]
        product[:total_fat] = item[4]
        product[:saturated_fat] = item[5]
        product[:trans_fat] = item[6]
        product[:cholesterol] = item[7]
        product[:sodium] = item[8]
        product[:total_carbohydrates] = item[9]
        product[:fiber] = item[10]
        product[:sugars] = item[11]
        product[:protein] = item[12]
        products << product
        item = []
        count = 0
      end
      if count != 0
        text = copy.inner_text
        item << text
        puts "#{count}: #{text}"
      end
      count += 1
    end

    # request the next page
    page = other_pages.pop
    STDERR.puts "fetch #{page}"
    c = Curl::Easy.new("http://www.starbucks.com/retail/nutrition_comparison_popup.asp?category={#{category}}&page=#{page}&subcategory=#{subcategory}&milk=#{milk}&size=#{size}")
    c.perform
    doc = Hpricot c.body_str

  end until other_pages.empty?
  {:size => size, :milk => milk, :products => products}
end

result = fetch_all_combinations start_category
File.open("starbucks-key.yml","w") {|f|
  f << result.to_yaml
}
STDERR.puts "generated starbucks grouping key"
# loop over all combinations of milk and size
products = []
# start here
group = fetch_nutrition_table_for(result[:category], result[:subcategory],
                                  "552984f2-9dab-4b36-a38a-88600019ad0f",
                                  "a5868afb-2847-4596-998a-8c9d34c7ebaf")

products << group
STDERR.puts "products: #{group[:products].size}"
result[:sizes].each do|size|
  result[:milks].each do|milk|
    STDERR.puts "request #{result[:category]}:#{result[:subcategory]} => milk:#{milk[:name]} size:#{size[:name]}"
    group = fetch_nutrition_table_for( result[:category], result[:subcategory], milk[:value], size[:value] )
    products << group
    STDERR.puts "products: #{group[:products].size}"
  end
end

# test 1
puts products.inspect
for product in products do
  puts product[:name]
  puts "\tserving size: #{product[:serving_size]}"
  puts "\tcalories: #{product[:calories]}"
  puts "\tfat calories: #{product[:fat_calories]}"
  puts "\ttotal fat: #{product[:total_fat]}"
  puts "\tsaturated fat: #{product[:saturated_fat]}"
  puts "\ttrans fat: #{product[:trans_fat]}"
  puts "\tcholesterol: #{product[:cholesterol]}"
  puts "\tsodium: #{product[:sodium]}"
  puts "\ttotal carbohydrates: #{product[:total_carbohydrates]}"
  puts "\tfiber: #{product[:fiber]}"
  puts "\tsugars: #{product[:sugars]}"
  puts "\tprotein: #{product[:protein]}"
  puts "-----"
end
puts "Total product data: #{products.size}"
File.open("starbucks.yml", "w") {|f| f << products.to_yaml }
#File.open("starbucks.js", "w") {|f| f << products.to_json }
