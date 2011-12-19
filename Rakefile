# encoding: UTF-8
require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rake'
require 'rdoc/task'

begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
rescue LoadError
  puts "no rspec"
else
  RSpec::Core::RakeTask.new(:spec) do |t|
  end

  task :default => :spec

  SPEC_LOGS = FileList["spec/dummy/log/**/*.log"]
  desc "Remove spec logs."
  task :clean_spec_log do
    SPEC_LOGS.each { |fn| rm_r fn rescue nil }
  end

end


Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Roma-rails'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('CHANGELOG.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

def gemspec
  @gemspec = nil
  Dir.glob(File.expand_path('*.gemspec', File.dirname(__FILE__))) do |f|
    @gemspec = eval(File.read(f), binding, f)
  end
  @gemspec
end

begin
  require 'rake/gempackagetask'
rescue LoadError
  task(:gem) { $stderr.puts '`gem install rake` to package gems' }
else
  Rake::GemPackageTask.new(gemspec) do |pkg|
    pkg.gem_spec = gemspec
  end
end
