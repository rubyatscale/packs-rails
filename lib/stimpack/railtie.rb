require "rails"

module Stimpack
  class Railtie < Rails::Railtie
    config.before_configuration do
      Stimpack.start!
    end

    config.after_initialize do
      Stimpack.finalize!
    end
  end
end
