require 'fastercsv'

class LoadTimhortonsData < ActiveRecord::Migration
  def self.up
    FasterCSV.foreach("#{RAILS_ROOT}/db/data/timhortons.csv") do |row|      
      Store.create :street     => row[1],  
                   :city       => row[3], 
                   :state      => row[4],
                   :zip        => row[5],
                   :phone      => row[6],
                   :latitude   => row[8],
                   :longitude  => row[9],
                   :store_type => Store::StoreType::TIMHORTONS
    end
  end

  def self.down
    Store.delete_all :store_type => Store::StoreType::TIMHORTONS
  end
end
