require "rails"

module Stimpack
  class Railtie < Rails::Railtie
    config.before_configuration do |app|
      Stimpack.load(app)
      # This is not used within stimpack. Rather, this allows OTHER tools to
      # hook into Stimpack via ActiveSupport hooks.
      ActiveSupport.run_load_hooks(:stimpack, Packs)
    end
  end
end
