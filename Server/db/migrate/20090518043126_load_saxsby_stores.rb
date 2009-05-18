require 'fastercsv'

class LoadSaxsbyStores < ActiveRecord::Migration
  def self.up
    FasterCSV.foreach("#{RAILS_ROOT}/db/data/saxbys.csv") do |row|      
      Store.create :street     => row[2], 
                   :city       => row[3], 
                   :state      => row[4],
                   :zip        => row[5],
                   :phone      => row[6],
                   :latitude   => row[8],
                   :longitude  => row[9],
                   :store_type => Store::StoreType::SAXBYS
                   
    end
  end

  def self.down
    Store.delete_all :store_type => Store::StoreType::SAXBYS
  end
end
