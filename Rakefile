# Use the updated rdoc gem rather than version
# included with ruby.
require 'rdoc'

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the netflix plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the netflix plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Netflix'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
