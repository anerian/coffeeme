# determine the drink size and milk
#module Dunkin
#  Sizes = ['Extra Large', 'Small', 'Medium', 'Large']
#  Milks = ['Skim Milk and Splenda', 'Skim', 'Splenda', 'Cream']
##end
def drink_classifcation(name)
  size = Drink::Sizes.select{|s| name.match(s) }.last
  milk = Drink::Milks.select{|s| name.match(s) }.last
  [size ? size.downcase : nil, milk ? milk.downcase : nil]
end

class LoadDunkendonutsNutritionData < ActiveRecord::Migration
  def self.up
    change_column :drinks, :milk, :integer, :null => true
    change_column :drinks, :size, :integer, :null => true
    root = "#{RAILS_ROOT}/db/data/nutrition"
    drinks = YAML.load_file("#{root}/dunkindonuts.yml")
    execute("delete from drinks where store_type = #{Store::StoreType::DUNKIN}")
    for drink in drinks do
      drink[:store_type] = Store::StoreType::DUNKIN
      drink[:name] = drink[:name].mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
      size, milk = drink_classifcation(drink[:name])
      drink[:size] = size
      drink[:milk] = milk
      puts "create drink: #{drink[:name]} -> #{drink[:size]}"
      Drink.create( drink )
    end
  end

  def self.down
    execute("delete from drinks where store_type = #{Store::StoreType::DUNKIN}")
  end
end
