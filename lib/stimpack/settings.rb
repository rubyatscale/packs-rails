# frozen_string_literal: true

module Stimpack
  class Settings
    PACKWERK_PACKAGE_CONFIG = "package.yml"

    def initialize(pack)
      @pack = pack

      package_config = YAML.load_file(pack.root.join(PACKWERK_PACKAGE_CONFIG)) || {}
      @config = package_config.fetch("metadata", {}).freeze
    end

    def path
      @pack.called_from
    end

    def relative_path
      @relative_path ||= path.relative_path_from(Rails.root)
    end

    def name
      @name ||= ActiveSupport::Inflector.underscore(namespace.name)
    end

    def namespace
      @pack.module_parent
    end

    # def implicit_namespace
    #   @config.fetch("implicit_namespace", true)
    # end
    # alias_method :implicit_namespace?, :implicit_namespace

    def isolate_namespace
      @config.fetch("isolate_namespace", false)
    end
    alias_method :isolate_namespace?, :isolate_namespace
  end
end
