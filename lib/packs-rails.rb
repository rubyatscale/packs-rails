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

      #
      # This is temporary. For now, we allow packs-rails roots to be configured via Packs::Rails.config.root
      # Later, if clients configure packs directly, we can deprecate the packs-rails setting and
      # remove this function and its invocations.
      #
      def configure_packs
        Packs.configure do |config|
          roots = Array(Packs::Rails.config.root)
          pack_paths = roots.flat_map do |root|
            # Support nested packs by default. Later, this can be pushed to a client configuration.
            ["#{root}/*", "#{root}/*/*"]
          end

          config.pack_paths = pack_paths
        end
      end
    end

    @config = ActiveSupport::OrderedOptions.new
    # Should this allow a plural version to be set? What are semantics of that?
    @config.root = Array("packs".freeze)
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
