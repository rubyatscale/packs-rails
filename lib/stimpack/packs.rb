require "active_support"
require "pathname"
require "rails"

module Stimpack
  module Packs
    PATH = Pathname.new("packs").freeze
    PACK_CLASS = "Pack".freeze

    class << self
      def resolve
        PATH.glob("**/#{Settings::PACKWERK_PACKAGE_CONFIG}").each do |path|
          path = path.dirname
          create(path.relative_path_from(PATH).to_s, path.expand_path)
        end
      end

      def create(name, path)
        namespace = create_namespace(name)
        stim = Stim.new(path)
        @packs[name] = namespace.const_set(PACK_CLASS, Class.new(Rails::Engine)).include(stim)
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

      private

      def create_namespace(name)
        namespace = ActiveSupport::Inflector.camelize(name)
        namespace.split("::").reduce(Object) do |base, mod|
          if base.const_defined?(mod)
            base.const_get(mod)
          else
            base.const_set(mod, Module.new)
          end
        end
      end
    end

    @packs = {}
  end
end
