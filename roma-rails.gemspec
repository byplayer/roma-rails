# Provide a simple gemspec so you can easily use your enginex
# project in your rails apps through git.
Gem::Specification.new do |s|
  s.name = "roma_rails"
  s.summary = "Insert Roma-rails summary."
  s.description = "Insert Roma-rails description."
  s.files = Dir["{app,lib,config}/**/*"] + ["Rakefile", "Gemfile", "README.rdoc"]
  s.version = "0.0.1"
end