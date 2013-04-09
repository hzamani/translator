$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "translator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "translator"
  s.version     = Translator::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Translator."
  s.description = "TODO: Description of Translator."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "activerecord-postgres-hstore"

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails"
end
