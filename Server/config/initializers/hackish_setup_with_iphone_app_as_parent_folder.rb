if not File.exist?('public/images/iphone')
  src = File.expand_path("#{RAILS_ROOT}/../Images")
  dst = File.expand_path("#{RAILS_ROOT}/public/images/iphone")
  puts "linking iphone Images folder to public/images/iphone"
  system("ln -s #{src} #{dst}")
end
