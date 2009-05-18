class Store < ActiveRecord::Base
  module StoreType
    STARBUCKS  = 0
    DUNKIN     = 1
    CARIBOU    = 2
    TIMHORTONS = 3
  end
end
