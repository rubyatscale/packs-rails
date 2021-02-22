require "active_support"
require "pathname"
require "rails"

module Stimpack
  module Packs
    PATH = Pathname.new("packs").freeze

    class << self
      def resolve
        PATH.glob("**/#{Settings::PACKWERK_PACKAGE_CONFIG}").each do |path|
          path = path.dirname
          create(path.relative_path_from(PATH).to_s, path.expand_path)
        end
      end

      def create(name, path)
        pack_class = ActiveSupport::Inflector.camelize(name).gsub("::", "_")
        stim = Stim.new(path)
        @packs[name] = const_set(pack_class, Class.new(Rails::Engine)).include(stim)
      end

      def find(path)
        path = "#{path}/"

        @packs.values.find do |pack|
          path.start_with?("#{pack.root}/")
        end
      end

      def [](name)
        @packs[name]
      end

      def each(*args, &block)
        @packs.each_value(*args, &block)
      end
    end

    @packs = {}
  end
end
