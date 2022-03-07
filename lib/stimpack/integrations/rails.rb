# frozen_string_literal: true

module Stimpack
  module Integrations
    class Rails
      def self.install(app)
        Stimpack.config.paths.freeze

        Packs.each do |pack|
          Stimpack.config.paths.each do |path|
            app.paths[path] << pack.path.join(path)
          end
        end
      end
    end
  end
end
