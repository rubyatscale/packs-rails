require 'packs'
require "active_support"
require "rails/application"
require 'sorbet-runtime'

module Packs
  module Rails
    extend ActiveSupport::Autoload

    autoload :Integrations
    autoload :Railtie
    autoload :Stim

    class Error < StandardError; end

    class << self
      attr_reader :config

      def root
        @root ||= ::Rails::Application.find_root(Dir.pwd)
      end
    end

    @config = ActiveSupport::OrderedOptions.new
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

  require "packs/rails/railtie"
end
