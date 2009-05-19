class Store < ActiveRecord::Base
  module StoreType
    STARBUCKS  = 0
    DUNKIN     = 1
    CARIBOU    = 2
    TIMHORTONS = 3
    SAXBYS     = 4
    PEETS      = 5
    DUNNBROS   = 6
    BEANERY    = 7
  end

  def titled_type
    case store_type
    when StoreType::STARBUCKS then 'Starkbucks'
    when StoreType::DUNKIN then 'Dunkin Donuts'
    when StoreType::CARIBOU then 'Caribou'
    when StoreType::TIMHORTONS then 'Tim Hortons'
    when StoreType::SAXBYS then 'SAXBYS'
    when StoreType::PEETS then 'PEETS'
    when StoreType::DUNNBROS then 'Dunn Bros'
    when StoreType::BEANERY then 'Coffee Beanery'
    else
      "Unknown"
    end
  end

  def title
    "#{self.titled_type} #{self.street}"
  end
end
