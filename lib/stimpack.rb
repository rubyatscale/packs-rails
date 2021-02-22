require "active_support"
require "rails"

module Stimpack
  extend ActiveSupport::Autoload

  autoload :Integrations
  autoload :Packs
  autoload :Railtie
  autoload :Settings
  autoload :Stim

  class Error < StandardError; end

  class << self
    def start!
      @started = @started ? return : true

      Packs.resolve

      install_integrations
    end

    def finalize!
      @finalized = @finalized ? return : true
    end

    def [](name)
      Packs[name.to_s]
    end

    private

    def install_integrations
      Integrations::FactoryBot.install
      Integrations::RSpec.install
    end
  end
end

require "stimpack/railtie"
