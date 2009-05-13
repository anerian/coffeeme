class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zip, :limit => 5
      t.string :phone
      t.decimal :latitude, :precision => 15, :scale => 6
      t.decimal :longitude, :precision => 15, :scale => 6
      t.integer :store_type, :default => 0
    end
  end

  def self.down
    drop_table :stores
  end
end