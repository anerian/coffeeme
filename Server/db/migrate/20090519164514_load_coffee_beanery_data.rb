class LoadCoffeeBeaneryData < ActiveRecord::Migration
  def self.up
    stores = YAML.load_file("#{RAILS_ROOT}/db/data/coffee_beanery.yml")
    for store in stores do
      Store.create :street     => store[:street],
                   :city       => store[:city], 
                   :state      => store[:state],
                   :zip        => store[:zip],
                   :phone      => store[:phone],
                   :latitude   => store[:lat],
                   :longitude  => store[:lng],
                   :store_type => Store::StoreType::BEANERY
    end
  end

  def self.down
    Store.delete_all :store_type => Store::StoreType::BEANERY
  end
end
