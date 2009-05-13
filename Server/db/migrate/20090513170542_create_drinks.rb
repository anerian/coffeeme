class CreateDrinks < ActiveRecord::Migration
  def self.up
    create_table :drinks do |t|
      t.string :name
      t.integer :serving_size, :default => 0
      t.integer :calories, :default => 0
      t.integer :fat_calories, :default => 0
      t.integer :total_fat, :default => 0
      t.integer :saturated_fat, :default => 0
      t.integer :trans_fat, :default => 0
      t.integer :cholesterol, :default => 0
      t.integer :sodium, :default => 0
      t.integer :total_carbohydrates, :default => 0
      t.integer :fiber, :default => 0
      t.integer :sugars, :default => 0
      t.integer :protein, :default => 0
 
      # specials (name + size + milk) is unique
      t.integer :size
      t.integer :milk
    end
  end

  def self.down
    drop_table :drinks
  end
end
