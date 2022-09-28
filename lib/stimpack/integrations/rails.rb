# frozen_string_literal: true

require "active_support/inflections"
require 'pry'

module Stimpack
  module Integrations
    class Rails
      def initialize(app)
        @app = app
        ::Rails.autoloaders.main.log!
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
          module_name = pack.name.camelize
          Object.const_set(module_name, Module.new) if pack.config.automatic_pack_namespace? #
          Stimpack.config.paths.each do |path|
            @app.paths[path] << pack.path.join(path) unless pack.config.automatic_pack_namespace?
            ::Rails.autoloaders.main.push_dir(pack.path.join(path), namespace: module_name.constantize) if pack.config.automatic_pack_namespace? && Dir.exist?(pack.path.join(path))
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
