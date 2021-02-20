require "active_support"

module Stimpack
  module Integrations
    extend ActiveSupport::Autoload

    autoload :RSpec, "stimpack/integrations/rspec"
    autoload :FactoryBot, "stimpack/integrations/factory_bot"
  end
end
