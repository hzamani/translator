$:.push File.expand_path("../lib", __FILE__)

require "translator/version"

Gem::Specification.new do |s|
  s.name        = "rails-translator"
  s.version     = Translator::VERSION
  s.authors     = ["Hassan Zamani"]
  s.email       = ["hsn.zamani@gmail.com"]
  s.homepage    = "https://github.com/hzamani/translator"
  s.summary     = "Rails plugin for model translation."
  s.description = "Translator uses postgres hstore to keep model translations in your database."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "activerecord-postgres-hstore"

  s.add_development_dependency "pg"
  s.add_development_dependency "test-unit"
  s.add_development_dependency "rspec-rails"
end
