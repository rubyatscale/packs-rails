require "active_support"

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
