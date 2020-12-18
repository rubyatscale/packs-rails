require_relative 'lib/stimpack/version'

Gem::Specification.new do |spec|
  spec.name          = "stimpack"
  spec.version       = Stimpack::VERSION
  spec.authors       = ["Ngan Pham"]
  spec.email         = ["gusto-opensource-buildkite@gusto.com"]

  spec.summary       = %q{Name hold for upcoming gem}
  spec.description   = %q{Name hold for upcoming gem}
  spec.homepage      = "https://github.com/Gusto/stimpack"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Gusto/stimpack"
  spec.metadata["changelog_uri"] = "https://github.com/Gusto/stimpack/blob/master/CHANGELOG.md"

  spec.files         = Dir["VERSION", "CHANGELOG.md", "LICENSE.txt", "README.md", "lib/**/*", "bin/**/*"]
  spec.bindir        = "exe"
  spec.executables   = Dir["exe/*"].map { |exe| File.basename(exe) }
  spec.require_paths = ["lib"]
end
