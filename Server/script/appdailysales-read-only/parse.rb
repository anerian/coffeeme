#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__),"..","..","config","environment.rb")
require 'zlib'
require 'rubygems'
require 'fastercsv'

Dir["#{File.dirname(__FILE__)}/*.gz"].each do|file|
  buffer = nil
  Zlib::GzipReader.open(file) {|gz| buffer = gz.read }
  rows = []
  FasterCSV.parse(buffer) {|row| rows << row }
  header = rows.shift
  for row in rows do
    cols = row.first.split("\t")
    product = cols[6].strip.gsub(/\s/, ' ').squeeze(' ')
    units = cols[9].strip.gsub(/\s/, ' ').squeeze(' ')
    date = cols[11].strip.gsub(/\s/, ' ').squeeze(' ')
    puts "Sold #{units} #{product}'s on #{date}"
    report = Report.find_by_date(date)
    if not report
      Report.create :product => product, :units => units, :date => date
    end
  end
  system("mv #{file} #{File.dirname(__FILE__)}/archives/")
end
