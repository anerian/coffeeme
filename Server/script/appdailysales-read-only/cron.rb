#!/usr/bin/env ruby

#root = File.expand_path(File.dirname(__FILE__))
#system("cd #{root} && /usr/bin/python #{File.join(root,'appdailysales.py')}")
#system("cd #{root} && /opt/local/bin/ruby #{File.join(root,'parse.rb')}")

root = "/var/www/apps/coffeeme/current/Server/script/appdailysales-read-only/"
system("cd #{root} && /usr/bin/python #{File.join(root,'appdailysales.py')}")
system("cd #{root} && /opt/local/bin/ruby #{File.join(root,'parse.rb')}")
