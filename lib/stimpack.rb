require "active_support"
require "rails"

module Stimpack
  extend ActiveSupport::Autoload

  autoload :Integrations
  autoload :Pack
  autoload :Packs
  autoload :Railtie
  autoload :Stim

  class Error < StandardError; end

  class << self
    def load(app)
      Packs.resolve

      Integrations::Rails.install(app)
      Integrations::FactoryBot.install(app)
      Integrations::RSpec.install(app)
    end

    def [](name)
      Packs[name.to_s]
    end
  end
end

require "stimpack/railtie"
