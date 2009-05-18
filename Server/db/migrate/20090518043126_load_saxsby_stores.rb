require 'fastercsv'

class LoadSaxsbyStores < ActiveRecord::Migration
  def self.up
    FasterCSV.foreach("#{RAILS_ROOT}/db/data/saxbys.csv") do |row|      
      Store.create :street     => row[1], 
                   :city       => row[3], 
                   :state      => row[4],
                   :zip        => row[5],
                   :phone      => row[6],
                   :latitude   => row[7],
                   :longitude  => row[8],
                   :store_type => Store::StoreType::SAXBYS
                   
    end
  end

  def self.down
    Store.delete_all :store_type => Store::StoreType::SAXBYS
  end
end
