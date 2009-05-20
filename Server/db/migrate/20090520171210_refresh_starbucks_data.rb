class RefreshStarbucksData < ActiveRecord::Migration
  def self.up
    root = "#{RAILS_ROOT}/db/data/nutrition"
    key_table     = YAML.load_file("#{root}/starbucks-key.yml")

    # invert the key table
    keys = {}
    count = 0
    key_table[:milks].each do|i|
      name = (i[:name]).gsub(/[^\x00-\x7F]/n,'')
      keys[i[:value]] = {:name => name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s, :enum => count}
      count += 1
    end
    count = 0
    key_table[:sizes].each do|i|
      name = (i[:name]).gsub(/[^\x00-\x7F]/n,'')
      keys[i[:value]] = {:name => name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s, :enum => count}
      count += 1
    end

    # write the keys to disk
    File.open("#{root}/keys.yml", "w"){|f| f << keys.to_yaml }
    drink_groups = YAML.load_file("#{root}/starbucks.yml")
    execute("delete from drinks where store_type = #{Store::StoreType::STARBUCKS}")
    drink_groups.each do|dg|
      dg[:products].each do|p|
        Drink.create (
          :name => p[:name].titleize,
          :serving_size => p[:serving_size],
          :calories => p[:calories],
          :fat_calories => p[:fat_calories],
          :total_fat => p[:total_fat],
          :saturated_fat => p[:saturated_fat],
          :trans_fat => p[:trans_fat],
          :cholesterol => p[:cholesterol],
          :sodium => p[:sodium],
          :total_carbohydrates => p[:total_carbohydrates],
          :fiber => p[:fiber],
          :sugars => p[:sugars],
          :protein => p[:protein],
          :milk => keys[dg[:milk]][:enum],
          :size => keys[dg[:size]][:enum],
          :store_type => 0
        )
      end
    end
  end

  def self.down
    execute("delete from drinks where store_type = #{Store::StoreType::STARBUCKS}")
  end
end
