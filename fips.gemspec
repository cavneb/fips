$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fips/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fips"
  s.version     = Fips::VERSION
  s.authors     = "Eric Berry"
  s.email       = "cavneb@gmail.com"
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Fips."
  s.description = "TODO: Description of Fips."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.6"
  s.add_dependency "ruby-progressbar"
  s.add_dependency "nokogiri"

  s.add_development_dependency "sqlite3"
end
