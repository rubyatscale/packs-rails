# frozen_string_literal: true

require "pathname"

module Stimpack
  class Pack
    PACKAGE_FILE = "package.yml"

    autoload :Configuration, "stimpack/pack/configuration"

    attr_reader :path
    attr_reader :name
    attr_accessor :engine

    def initialize(path)
      @path = path
      @name = path.basename.to_s
    end

    def relative_path
      @relative_path ||= path.relative_path_from(Stimpack.root)
    end

    def config
      @config ||= Configuration.new(path.join(PACKAGE_FILE))
    end

    def find_or_create_namespace
      name = self.name
      namespace = ActiveSupport::Inflector.camelize(name)
      namespace.split("::").reduce(Object) do |base, mod|
        if base.const_defined?(mod, false)
          base.const_get(mod, false)
        else
          base.const_set(mod, Module.new)
        end
      end
    end
  end
end
