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
          pack_source_directories(pack).each do |dir|
            pack_source_path = pack.path.join(dir)
            if pack.config.automatic_pack_namespace?
              next unless Dir.exist?(pack_source_path)
              namespace = pack.find_or_create_namespace
              autoloader.push_dir(pack_source_path, namespace: namespace)
            else
              @app.paths[dir] << pack_source_path
            end
          end
        end
      end

      private

      def autoloader
        ::Rails.autoloaders.main
      end

      def pack_source_directories(pack)
        pack.config.automatic_pack_namespace? ?
          Stimpack.config.paths + ['app/public'] :
          Stimpack.config.paths
      end

      def create_engine(pack)
        name = pack.path.relative_path_from(Stimpack::Packs.root)
        namespace = pack.find_or_create_namespace
        stim = Stim.new(pack, namespace)
        namespace.const_set("Engine", Class.new(::Rails::Engine)).include(stim)
      end
    end
  end
end
