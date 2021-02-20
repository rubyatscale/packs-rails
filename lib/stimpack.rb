require "active_support"
require "rails"

module Stimpack
  extend ActiveSupport::Autoload

  autoload :Integrations
  autoload :Autoloaders
  autoload :Packs
  autoload :Settings
  autoload :Stim
  autoload :Railtie
  # autoload :Require
  autoload :ZeitwerkProxy

  class Error < StandardError; end

  class << self
    def start!
      @started = @started ? return : true

      # Override Rails' autoloader accessors.
      # Rails::Autoloaders.singleton_class.prepend(Autoloaders)

      Packs.resolve

      install_integrations
    end

    def finalize!
      @finalized = @finalized ? return : true

      # Require.setup
    end

    def autoloader(original)
      return original if @finalized

      @autoloader_proxies ||= {}
      @autoloader_proxies[original] ||= ZeitwerkProxy.new(original)
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
# require "stimpack/require"
# require "stimpack/kernel"
