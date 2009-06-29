class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer  :units
      t.string   :product
      t.date     :date
    end
  end

  def self.down
    drop_table :reports
  end
end
