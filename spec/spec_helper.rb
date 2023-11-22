require "bundler/setup"
require "packs-rails"
require 'packs/rspec/support'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def require_test_rails_application(version = ENV.fetch("RAILS_VERSION", "7.0"))
  rails_dir = Pathname.new(File.expand_path("fixtures/rails-#{version}", __dir__))
  Dir.chdir(rails_dir)
  require_relative rails_dir.join("config/environment")
  rails_dir
end
