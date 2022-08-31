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
      @name = path.basename
    end

    def relative_path
      @relative_path ||= path.relative_path_from(Stimpack.root)
    end

    def config
      @config ||= Configuration.new(path.join(PACKAGE_FILE))
    end
  end
end
