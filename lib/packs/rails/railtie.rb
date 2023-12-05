require "rails/railtie"

module Packs
  module Rails
    class Railtie < ::Rails::Railtie
      config.before_configuration do |app|
        Integrations::Rails.new(app)

        # This is not used within packs-rails. Rather, this allows OTHER tools to
        # hook into packs-rails via ActiveSupport hooks.
        ActiveSupport.run_load_hooks(:packs_rails, Packs)
      end

      config.before_initialize do |app|
        Integrations::FactoryBot.new(app)
      end
    end
  end
end
