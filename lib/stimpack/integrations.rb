require "active_support"

module Stimpack
  module Integrations
    autoload :FactoryBot, "stimpack/integrations/factory_bot"
    autoload :Rails, "stimpack/integrations/rails"
    autoload :RSpec, "stimpack/integrations/rspec"
  end
end
