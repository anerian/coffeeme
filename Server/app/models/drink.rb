class Drink < ActiveRecord::Base
  Sizes = [
            # starbucks
            'tall', 'grande', 'venti', 'solo', 'doppio', 'short',
            # dunkindonuts
            'medium', 'large', 'extra large', 'small'
          ].freeze
  Milks = [
            # starbucks
            'nonfat', 'whole', '2%', 'soy (us)', 'soy (cd)',
            # dunkindonuts
            'skim', 'splenda', 'cream', 'skim milk and splenda'
          ]
end
