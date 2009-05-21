require 'fastercsv'
class ReloadTimHortonsStoreLocations < ActiveRecord::Migration
  def self.up
    # the first import was off... correcting that here
    Store.delete_all :store_type => Store::StoreType::TIMHORTONS
    FasterCSV.foreach("#{RAILS_ROOT}/db/data/timhortons.csv") do |row|
      # 0 - store name
      # 1 - street
      # 2 - city
      # 3 - state
      # 4 - zip
      # 5 - phone
      # 6 - lat
      # 7 - lng
      Store.create :street     => row[1],
                   :city       => row[2],
                   :state      => row[3],
                   :zip        => row[4],
                   :phone      => row[5],
                   :latitude   => row[6],
                   :longitude  => row[7],
                   :store_type => Store::StoreType::TIMHORTONS
    end
  end

  def self.down
    Store.delete_all :store_type => Store::StoreType::TIMHORTONS
  end
end
