def caribou_size_to_enum(size)
  Drink::Sizes.index(size.downcase)
end

def caribou_milk_to_enum(milk)
  m = milk.downcase
  m = '2%' if m == 'two_percent'
  m = 'soy (us)' if m == 'soy'
  Drink::Milks.index(m)
end

class ReloadCaribouNutritionData < ActiveRecord::Migration
  def self.up
    root = "#{RAILS_ROOT}/db/data/nutrition"
    drinks = YAML.load_file("#{root}/caribou.yml")
    execute("delete from drinks where store_type = #{Store::StoreType::CARIBOU}")
    for drink in drinks do

      next if drink[:total_fat] == 'N/A' and drink[:serving_size] == 'N/A' and 
              drink[:saturated_fat] == 'N/A' and drink[:sodium] == 'N/A' and
              drink[:cholesterol] == 'N/A' and drink[:calories] == 'N/A' and
              drink[:fiber] == 'N/A'

      drink[:size] = caribou_size_to_enum(drink[:size])
      drink[:milk] = caribou_milk_to_enum(drink[:milk])
      drink[:store_type] = Store::StoreType::CARIBOU
      drink[:name] = drink[:name].humanize
      Drink.create( drink )
    end
  end

  def self.down
    execute("delete from drinks where store_type = #{Store::StoreType::CARIBOU}")
  end
end
