require 'yaml'

stores = YAML.load_file('stores.yml')
puts stores.size
