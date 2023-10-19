# frozen_string_literal: true
# typed: true

require "active_support/inflections"

module Packs
  module Rails
    module Integrations
      class Rails
        CONFIG_ROUTES_PATH =  "config/routes".freeze

        def initialize(app)
          @app = app

          Packs::Rails.config.paths.freeze

          create_engines
          inject_paths
        end

        def create_engines
          Packs.all.reject(&:is_gem?).each do |pack|
            next unless pack.metadata['engine']

            create_engine(pack)
          end
        end

        def inject_paths
          Packs.all.reject(&:is_gem?).each do |pack|
            Packs::Rails.config.paths.each do |path|
              # Prior to Rails 6.1, the "config/routes" app path is nil and was not added until drawable routes feature was implemented
              # https://github.com/rails/rails/pull/37892/files#diff-a785e41df3f87063a8fcffcac726856a25d8eae6d1f9bca2b36989fe88613f8eR62
              next if path == CONFIG_ROUTES_PATH && Gem::Version.new(::Rails.version) < Gem::Version.new("6.1")

              @app.paths[path] << pack.relative_path.join(path)
            end
          end
        end

        private

        def create_namespace(name)
          namespace = ActiveSupport::Inflector.camelize(name)
          namespace.split("::").reduce(Object) do |base, mod|
            if base.const_defined?(mod, false)
              base.const_get(mod, false)
            else
              base.const_set(mod, Module.new)
            end
          end
        end

        def create_engine(pack)
          name = pack.last_name
          namespace = create_namespace(name)
          stim = Stim.new(pack, namespace)
          namespace.const_set("Engine", Class.new(::Rails::Engine)).include(stim)
        end
      end
    end
  end
end
