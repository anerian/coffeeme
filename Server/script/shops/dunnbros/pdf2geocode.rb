appid="QFoY1w7V34GUcrwOTlvIp46xJGhysm8wNr1kObebYVm4ny.Ef67oFgENwv8cvIKxz5fK"
require 'rubygems'
require 'geocoder'
require 'curb'
require 'hpricot'
require 'activesupport'
require 'pdf/reader'

input = "dbc_store_list.pdf" # from http://www.dunnbros.com/locations.asp

def cleanstr(str)
  ActiveSupport::Multibyte::Chars.new(str).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,' ').downcase.to_s.gsub(/\r|\n/,' ').gsub(/\s/, ' ').squeeze(' ')
end

class PageTextReceiver
  attr_accessor :content

  def initialize
    @content = []
  end

  # Called when page parsing starts
  def begin_page(arg = nil)
    @content << " "
  end

  # record text that is drawn on the page
  def show_text(string, *params)
  #puts "#{string.inspect} #{params.inspect}"
    @content.last << string
  end

  def  move_to_next_line_and_show_text(string, *params)
    @content << " "
    @content.last << "\n"
    @content.last << string
  end

  def set_spacing_next_line_show_text(string, *params)
    @content.last << " "
    @content.last << string
  end

  # there's a few text callbacks, so make sure we process them all
  alias :super_show_text :show_text
#  alias :move_to_next_line_and_show_text :show_text
#  alias :set_spacing_next_line_show_text :show_text

  # this final text callback takes slightly different arguments
  def show_text_with_positioning(*params)
    params = params.first
    params.each { |str|
      if str.kind_of?(String)
        show_text(str)
      else
#        if str < -100
#          puts str.inspect
#          show_text(" ")
#        end
      end
    }
  end
end

receiver = PageTextReceiver.new
pdf = PDF::Reader.file(input, receiver)
puts receiver.content.inspect
