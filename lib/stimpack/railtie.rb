require "rails"

module Stimpack
  class Railtie < Rails::Railtie
    config.before_configuration do |app|
      Stimpack.load(app)
      ActiveSupport.run_load_hooks(:stimpack, Packs)
    end
  end
end
