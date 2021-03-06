# frozen_string_literal: true

module Stimpack
  module Integrations
    class Rails
      PATHS = %w(
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
      ).freeze

      def self.install(app)
        Packs.each do |pack|
          PATHS.each do |path|
            app.paths[path] << pack.path.join(path)
          end
        end
      end
    end
  end
end
