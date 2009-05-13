require 'json'

class CreateTrivias < ActiveRecord::Migration
  def self.up
    create_table :trivias do |t|
      t.text :fact
    end
    
    trivia = JSON.parse(File.read("#{RAILS_ROOT}/db/data/trivia.js"))
    for fact in trivia do
      Trivia.create :fact => fact
    end
  end

  def self.down
    drop_table :trivias
  end
end
