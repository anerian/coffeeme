#!/usr/bin/env ruby

root = File.expand_path(File.dirname(__FILE__))
system("/usr/bin/python #{File.join(root,'appdailysales.py')}")
system("/opt/local/bin/ruby #{File.join(root,'parse.rb')}")
