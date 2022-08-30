# frozen_string_literal: true

require "pathname"

module Stimpack
  class Pack
    PACKAGE_FILE = "package.yml"
    ROOT_PATH = Pathname.new(".")

    autoload :Configuration, "stimpack/pack/configuration"

    attr_reader :path
    attr_reader :name
    attr_accessor :engine

    def initialize(path, level:, packs_path: nil)
      if Stimpack.config.max_levels && level > Stimpack.config.max_levels
        raise ArgumentError, "level (#{level}) exceeds max_levels (#{Stimpack.config.max_levels})"
      elsif !path.join(PACKAGE_FILE).exist?
        raise ArgumentError, "path does not contain a #{PACKAGE_FILE} file: #{path}"
      end

      @path = path
      @name = path.basename
      @level = level
      @packs_path = packs_path
    end

    def children
      @children ||= begin
        pack_paths = @packs_path&.glob("*/#{PACKAGE_FILE}") || []
        packs = pack_paths.map(&:dirname).sort.map do |pack_path|
          Pack.new(pack_path, level: @level + 1, packs_path: pack_path)
        end
        packs.freeze
      end
    end

    def all_children
      @all_children ||= (children + children.map(&:all_children).flatten).freeze
    end

    def root?
      path == Stimpack.app_root
    end

    def relative_path
      @relative_path ||= path.relative_path_from(Stimpack.app_root)
    end

    def config
      @config ||= Configuration.new(path.join(PACKAGE_FILE))
    end
  end
end
