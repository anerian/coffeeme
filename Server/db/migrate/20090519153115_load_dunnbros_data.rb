class LoadDunnbrosData < ActiveRecord::Migration
  def self.up
    stores = YAML.load_file("#{RAILS_ROOT}/db/data/dunnbros.yml")
    for store in stores do
      street = "#{store[:address]} => #{store[:address].sub(/#{store[:city]},.*$/i,'')}"
      Store.create :street     => street,
                   :city       => store[:city], 
                   :state      => store[:state],
                   :zip        => store[:zip],
                   :phone      => store[:phone],
                   :latitude   => store[:lat],
                   :longitude  => store[:lng],
                   :store_type => Store::StoreType::DUNNBROS
    end
  end

  def self.down
    Store.delete_all :store_type => Store::StoreType::DUNNBROS
  end
end
