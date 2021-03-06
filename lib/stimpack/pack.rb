# frozen_string_literal: true

module Stimpack
  class Pack
    autoload :Configuration, "stimpack/pack/configuration"

    attr_reader :name
    attr_reader :path
    attr_reader :engine

    def self.root
      @root ||= Rails.root.join("packs")
    end

    def initialize(path)
      @path = path
      @name = path.relative_path_from(self.class.root)

      if config.engine?
        @engine = create_engine
      end
    end

    def relative_path
      @relative_path ||= path.relative_path_from(Rails.root)
    end

    def config
      @config ||= Configuration.new(self)
    end

    private

    def create_engine
      namespace = create_namespace(name)
      stim = Stim.new(self, namespace)
      namespace.const_set("Engine", Class.new(Rails::Engine)).include(stim)
    end

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
end
