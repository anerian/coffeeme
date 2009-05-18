require 'yaml'

key_table = YAML.load_file("starbucks-key.yml")
product_table = YAML.load_file("starbucks.yml")
products = []
for group in product_table do
  products << group[:products]
end
products.flatten!
puts "Total: #{products.size}"
