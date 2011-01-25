require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'bacon'
Dir[File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', '*.rb'))].each {|f| require f }

