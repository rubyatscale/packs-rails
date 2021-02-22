# frozen_string_literal: true

module Stimpack
  class Settings
    PACK_CONFIG = "package.yml"

    attr_reader :name
    attr_reader :path

    def initialize(name, path)
      @name = name
      @path = path
    end

    def relative_path
      @path.relative_path_from(Rails.root)
    end

    def engine
      config.fetch("engine", false)
    end
    alias_method :engine?, :engine

    private

    def config
      @config ||= begin
        package_config = YAML.load_file(path.join(PACK_CONFIG))
        package_config.fetch("metadata", {}).freeze
      end
    end
  end
end
