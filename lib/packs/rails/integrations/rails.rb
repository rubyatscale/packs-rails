# frozen_string_literal: true
# typed: true

require 'active_support/inflections'

module Packs
  module Rails
    module Integrations
      class Rails
        def initialize(app)
          @app = app

          Packs::Rails.config.paths.freeze

          inject_paths
        end

        def inject_paths
          Packs.all.reject(&:is_gem?).each do |pack|
            Packs::Rails.config.paths.each do |path|
              @app.paths[path] << pack.relative_path.join(path)
            end
          end
        end
      end
    end
  end
end
