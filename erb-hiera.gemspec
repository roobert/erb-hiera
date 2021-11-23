$:.push File.expand_path("../lib", __FILE__)

require "erb-hiera/version"

Gem::Specification.new do |spec|
  spec.name                       = "erb-hiera"
  spec.summary                    = "ERB Hiera Document Generator"
  spec.description                = "Generate documents from a scope, ERB template(s) and Hiera data"

  spec.version                    = ErbHiera::VERSION

  spec.authors                    = ["Rob Wilson"]
  spec.email                      = "roobert@gmail.com"
  spec.homepage                   = "https://github.com/roobert/erb-hiera"

  spec.license                    = "MIT"

  spec.files                      = Dir["lib/**/*.rb", "bin/erb-hiera", "*.md", "example/**/*"]
  spec.executables                = ["erb-hiera"]
  spec.require_paths              = ["lib"]

  spec.add_runtime_dependency     "hiera"
  spec.add_runtime_dependency     "optimist"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
end
