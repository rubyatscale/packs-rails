require "active_support"
require "rails/application"

module Stimpack
  extend ActiveSupport::Autoload

  autoload :Integrations
  autoload :Pack
  autoload :Packs
  autoload :Railtie
  autoload :Stim

  class Error < StandardError; end

  class << self
    attr_reader :config

    def packs_root
      @root ||= app_root.join(config.root)
    end

    def app_root
      @app_root ||= Rails::Application.find_root(Dir.pwd)
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
  # (0) / -> (1) /packs -> (2) /packs/foo/bar
  @config.max_levels = 2
end

require "stimpack/railtie"
