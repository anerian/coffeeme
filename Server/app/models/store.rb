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
end
