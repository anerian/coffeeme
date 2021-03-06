#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__),"..","..","config","environment.rb")
require 'zlib'
require 'rubygems'
require 'fastercsv'
require 'date'
RLogger = ActiveRecord::Base.logger

RLogger.info("checking daily report in #{RAILS_ROOT}")

Root = File.join(RAILS_ROOT,"script", "appdailysales-read-only")

archives = File.join(Root,"archives")

if not File.exist?(archives)
  system("mkdir -p #{archives}")
end

Dir["#{Root}/*.gz"].each do|file|
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
    report = Report.find_by_date(Date.parse(date))
    if !report
      puts "Sold #{units} #{product}'s on #{date}"
      Report.create :product => product, :units => units, :date => date
    end
  end
  system("mv #{file} #{Root}/archives/")
end
