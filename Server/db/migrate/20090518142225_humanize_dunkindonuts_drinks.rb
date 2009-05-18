class HumanizeDunkindonutsDrinks < ActiveRecord::Migration
  def self.up
    Drink.find_each(:conditions => {:store_type => Store::StoreType::DUNKIN }) do|drink|
      drink.name = drink.name.humanize
      drink.save!
    end
  end

  def self.down
    Drink.find_each(:conditions => {:store_type => Store::StoreType::DUNKIN }) do|drink|
      drink.name = drink.name.downcase
      drink.save!
    end
  end
end
