require "rails"

module Stimpack
  class Railtie < Rails::Railtie
    config.before_configuration do |app|
      Stimpack.load(app)
    end
  end
end
