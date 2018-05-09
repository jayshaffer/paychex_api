# This file is copied to spec/ when you run 'rails generate rspec:install'
SimpleCov.minimum_coverage 80
SimpleCov.minimum_coverage_by_file 80
SimpleCov.start do
  add_group 'lib', 'lib'
  add_filter 'spec'
end
