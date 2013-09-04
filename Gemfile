source 'https://rubygems.org'

gem 'httparty'
gem 'prawn', git: "https://github.com/prawnpdf/prawn.git", branch: "master"

group :test, :development do
  # Ruby (even 2.0.0-rc2) includes an old (version 4.3.2) of Minitest
  # We can include it here and Bundler will pull the latest
  gem 'minitest'
  gem 'simplecov', require: false

  #gem 'rspec'  # I've been weening myself off of RSpec lately
end
