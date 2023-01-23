require_relative "lib/packs/rails/version"

Gem::Specification.new do |spec|
  spec.name          = "packs-rails"
  spec.version       = Packs::Rails::VERSION
  spec.authors       = ["Ngan Pham"]
  spec.email         = ["gusto-opensource-buildkite@gusto.com"]

  spec.summary       = "A Rails helper to package your code."
  spec.description   = "packs-rails establishes and implements a set of conventions for splitting up large monoliths."
  spec.homepage      = "https://github.com/Gusto/packs-rails"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Gusto/packs-rails"
  spec.metadata["changelog_uri"] = "https://github.com/Gusto/packs-rails/blob/main/CHANGELOG.md"

  spec.files         = Dir["VERSION", "CHANGELOG.md", "LICENSE.txt", "README.md", "lib/**/*", "bin/**/*"]
  spec.bindir        = "exe"
  spec.executables   = Dir["exe/*"].map { |exe| File.basename(exe) }
  spec.require_paths = ["lib"]

  spec.add_dependency "railties"
  spec.add_dependency "activesupport"
  spec.add_dependency "packs"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "debug"
  spec.add_development_dependency "sorbet"
  spec.add_development_dependency "tapioca"

  # We need this in test to load our test fixture Rails application, which represents the "client" of packs-rails
  spec.add_development_dependency "rails"
end
