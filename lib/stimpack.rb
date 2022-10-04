require "active_support"
require "rails/application"

module Stimpack
  extend ActiveSupport::Autoload

  autoload :Integrations
  autoload :Pack
  autoload :Packs
  autoload :Railtie
  autoload :Stim
  autoload :ZeitwerkProxy
  autoload :Autoloaders

  class Error < StandardError; end

  class << self
    attr_reader :config

    def root
      @root ||= Rails::Application.find_root(Dir.pwd)
    end

    def autoloader(original)
      @autoloader_proxies ||= {}
      @autoloader_proxies[original] ||= ZeitwerkProxy.new(original)
    end
  end

  @config = ActiveSupport::OrderedOptions.new
  @config.root = "packs".freeze
  @config.paths = %w(
    app
    app/controllers
    app/channels
    app/helpers
    app/models
    app/mailers
    app/views
    lib
    lib/tasks
    config
    config/locales
    config/initializers
    config/routes
  )
end

require "stimpack/railtie"
