require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "pine2csv"
    gem.summary = %Q{Convert pine address books to csv format}
    gem.description = %Q{A library and binary for converting pine address books to csv format.}
    gem.email = "bwalton@artsci.utoronto.ca"
    gem.homepage = "http://github.com/bdwalton/pine2csv"
    gem.authors = ["Ben Walton"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.executables = ["pine2csv"]
    gem.add_dependency "treetop", ">= 1.4.8"
    gem.add_dependency "polyglot", ">= 0.3.1"

  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "pine2csv #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
