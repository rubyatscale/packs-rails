require "bundler/setup"
require "stimpack"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def require_test_rails_application
  rails_dir = Pathname.new(File.expand_path("fixtures/rails-7.0", __dir__))
  Dir.chdir(rails_dir)
  require_relative rails_dir.join("config/environment")
  rails_dir
end
