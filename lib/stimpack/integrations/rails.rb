# frozen_string_literal: true

require "active_support/inflections"

module Stimpack
  module Integrations
    class Rails
      def initialize(app)
        @app = app
        Stimpack.config.paths.freeze
        create_engines
        inject_paths
      end

      def create_engines
        Packs.all.each do |pack|
          next unless pack.config.engine?

          pack.engine = create_engine(pack)
        end
      end

      def inject_paths
        Packs.all.each do |pack|
          Stimpack.config.paths.each do |path|
            autoload_path = pack.path.join(path)
            if pack.config.automatic_pack_namespace?
              next unless Dir.exist?(autoload_path)
              namespace = create_namespace(pack.name)
              ::Rails.autoloaders.main.push_dir(autoload_path, namespace: namespace)
            else
              @app.paths[path] << autoload_path
            end
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
        name = pack.path.relative_path_from(Stimpack::Packs.root)
        namespace = create_namespace(pack.name)
        stim = Stim.new(pack, namespace)
        namespace.const_set("Engine", Class.new(::Rails::Engine)).include(stim)
      end
    end
  end
end
