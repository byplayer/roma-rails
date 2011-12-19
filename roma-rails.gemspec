# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
lib = File.expand_path(File.join('lib'), File.dirname(__FILE__))
$:.unshift lib unless $:.include?(lib)
require 'roma-rails/version'


Gem::Specification.new do |s|
  s.name = "roma-rails"
  s.version = RomaRails::VERSION::STRING
  s.summary = "Rails3.1.x plugin to use ROMA."
  s.description = "Rails3.1.x plugin to use ROMA."
  s.authors = ["byplayer"]
  s.date = %q{2011-12-19}

  s.extra_rdoc_files = [
    "README.rdoc",
    "CHANGELOG.rdoc",
  ]

  s.files = FileList[
    '[A-Z]*',
    'bin/**/*',
    'lib/**/*.rb',
    'test/**/*.rb',
    'doc/**/*',
    'spec/**/*.rb',
  ]
  s.rdoc_options = ["--charset=UTF-8", "--line-numbers", "--inline-source",
                    "--main", "README.rdoc", "-c UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.test_files = Dir.glob("spec/**/*")

  s.add_dependency("roma-client", [">= 0.4.0"])
end