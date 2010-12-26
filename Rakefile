require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "mongoid_nested_fields"
  gem.homepage = "http://github.com/retro/mongoid_nested_fields"
  gem.license = "MIT"
  gem.summary = %Q{MongoidNestedFields allows you to handle complex data structures inside one field in MongoDB.}
  gem.description = %Q{MongoidNestedFields allows you to handle complex data structures inside one field in MongoDB. It also validates whole object graph on field validation}
  gem.email = "konjevic@gmail.com"
  gem.authors = ["retro"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
  # gem 'mongoid', "2.0.0.beta.20"
  gem.add_runtime_dependency "bson_ext",      ">= 1.1.5"
  gem.add_runtime_dependency 'yajl-ruby',     ">= 0.7.8"
  gem.add_runtime_dependency 'activesupport', ">= 3.0.3"
  gem.add_runtime_dependency 'activemodel',   ">= 3.0.3"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mongoid_content_block #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
