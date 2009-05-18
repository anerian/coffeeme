

def caribou_size_to_enum(size)
  Drink::Sizes.index(size.downcase)
end

def caribou_milk_to_enum(milk)
  m = milk.downcase
  m = '2%' if m == 'two_percent'
  m = 'soy (us)' if m == 'soy'
  Drink::Milks.index(m)
end

class LoadCaribouNutritionData < ActiveRecord::Migration
  def self.up
    root = "#{RAILS_ROOT}/db/data/nutrition"
    drinks = YAML.load_file("#{root}/caribou.yml")
    execute("delete from drinks where store_type = #{Store::StoreType::CARIBOU}")
    add_column :drinks, :caffeine, :integer
    for drink in drinks do
      drink[:size] = caribou_size_to_enum(drink[:size])
      drink[:milk] = caribou_milk_to_enum(drink[:milk])
      drink[:store_type] = Store::StoreType::CARIBOU
      Drink.create( drink )
    end
  end

  def self.down
    execute("delete from drinks where store_type = #{Store::StoreType::CARIBOU}")
  end
end
