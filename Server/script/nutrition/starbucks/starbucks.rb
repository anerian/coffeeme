require 'rubygems'
require 'hpricot'
require 'curb'
require 'yaml'
require 'activesupport'

def cleanstr(str)
  str = str.gsub(/[^\x00-\x7F]/n,'')
  ActiveSupport::Multibyte::Chars.new(str).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,' ').downcase.to_s.gsub(/\r|\n/,' ').gsub(/\s/, ' ').squeeze(' ')
end

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

def fetch_nutrition_table_for(params)
  query = params.map{|k,v| "#{k}=#{v}" unless v.blank? }.join('&')
  # build the url
  url = "http://www.starbucks.com/retail/nutrition_comparison_popup.asp?#{query}"
  puts "request: #{url.inspect}"
  c = Curl::Easy.new(url)

  c.perform

  doc = Hpricot c.body_str
  other_pages = locate_paginate(doc)
  products = []

  begin

    item = []
    count = 0
    # ha starbucks and their icky tables... oh copytext how nice
    (doc.at("table").at("table[@width=528]")/'span.copytext').each do|copy|
      if count == 13
        # map each item component to a name
        product = {}
        name = cleanstr item[0]
        puts "Add '#{name}' with #{item[1..12].inspect}"
        product[:name] = name
        product[:serving_size] = cleanstr item[1] if item[1]
        product[:calories] = cleanstr item[2] if item[2]
        product[:fat_calories] = cleanstr item[3] if item[3]
        product[:total_fat] = cleanstr item[4] if item[4]
        product[:saturated_fat] = cleanstr item[5] if item[5]
        product[:trans_fat] = cleanstr item[6] if item[6]
        product[:cholesterol] = cleanstr item[7] if item[7]
        product[:sodium] = cleanstr item[8] if item[8]
        product[:total_carbohydrates] = cleanstr item[9] if item[9]
        product[:fiber] = cleanstr item[10] if item[10]
        product[:sugars] = cleanstr item[11] if item[11]
        product[:protein] = cleanstr item[12] if item[12]
        products << product
        item = []
        count = 0
      end
      #if count != 0
        text = copy.inner_text
        if text.nil?
          raise "#{url} => #{item.inspect}, #{copy.inspect}"
        end
        item << text
        #puts "#{count}: #{text}"
      #end
      count += 1
    end

    # request the next page
    page = other_pages.pop
    query = params.merge(:page => page).map{|k,v| "#{k}=#{v}" unless v.blank? }.join('&')
    # build the url
    url = "http://www.starbucks.com/retail/nutrition_comparison_popup.asp?#{query}"
    STDERR.puts "fetch #{page} at #{url}"
    c = Curl::Easy.new(url)
    c.perform
    doc = Hpricot c.body_str

  end until other_pages.empty?
  { :size => (params[:size] || '552984f2-9dab-4b36-a38a-88600019ad0f'), # default is Grande
    :milk => (params[:milk] || 'a5868afb-2847-4596-998a-8c9d34c7ebaf'), # default is 2%
    :products => products}
end

result = fetch_all_combinations start_category
File.open("starbucks-key.yml","w") {|f|
  f << result.to_yaml
}
# invert the key table
keys = {}
count = 0
result[:milks].each do|i|
  name = (i[:name]).gsub(/[^\x00-\x7F]/n,'')
  keys[i[:value]] = {:name => cleanstr(name), :enum => count}
  count += 1
end
count = 0
result[:sizes].each do|i|
  name = (i[:name]).gsub(/[^\x00-\x7F]/n,'')
  keys[i[:value]] = {:name => cleanstr(name), :enum => count}
  count += 1
end

STDERR.puts "generated starbucks grouping key"
# loop over all combinations of milk and size
products = []

# test
#group = fetch_nutrition_table_for({})
#products << group
#STDERR.puts "products: #{group[:products].size}"

total = 0
result[:sizes].each do|size|
  result[:milks].each do|milk|
    STDERR.puts "milk:#{keys[milk[:value]][:name]} size:#{keys[size[:value]][:name]}"
    params = {
      :category => result[:category],
      :subcategory => result[:subcategory],
      :milk => milk[:value],
      :size => size[:value]
    }
    group = fetch_nutrition_table_for( params )
    products << group
    total += group[:products].size
    STDERR.puts "products: #{total}"
  end
end

# test 1
puts "Total product data: #{products.size}"
File.open("starbucks.yml", "w") {|f| f << products.to_yaml }
#File.open("starbucks.js", "w") {|f| f << products.to_json }
