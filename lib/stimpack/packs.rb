require "active_support"
require "pathname"
require "rails"

module Stimpack
  module Packs
    PATH = Pathname.new("packs").freeze
    PACK_CLASS = "Pack".freeze

    class << self
      def resolve
        PATH.glob("**/#{Settings::PACK_CONFIG}").each do |path|
          path = path.dirname
          create(path.relative_path_from(PATH).to_s, path.expand_path)
        end
      end

      def create(name, path)
        settings = Settings.new(name, path)
        namespace = create_namespace(settings.engine? ? Object : self, name)
        stim = Stim.new(settings, namespace)
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

      def create_namespace(base, name)
        namespace = ActiveSupport::Inflector.camelize(name)
        namespace.split("::").reduce(base) do |current_base, mod|
          if current_base.const_defined?(mod)
            current_base.const_get(mod)
          else
            current_base.const_set(mod, Module.new)
          end
        end
      end
    end

    @packs = {}
  end
end
