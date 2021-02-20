# frozen_string_literal: true

module Stimpack
  class Require
    IGNORED_PATH_PREFIXES = ["/", "./"].freeze
    RUBY_EXTENSION = ".rb"

    include Singleton

    attr_accessor :enabled

    def self.resolve(path)
      instance.resolve(path)
    end

    def self.setup
      instance.setup
    end

    def initialize
      @packs = {}
    end

    def setup
      @setup = @setup ? return : true

      Packs.each do |pack|
        if pack.settings.implicit_namespace?
          @packs["#{pack.settings.name}/"] = "#{pack.paths["lib"].first}/"
        end
      end
    end

    def resolve(path)
      path = path.to_s
      return if path.start_with?(*IGNORED_PATH_PREFIXES)

      @packs.find do |pack_path, full_path|
        if path.start_with?(pack_path)
          full_pack_path = path.sub(pack_path, full_path)
          full_pack_path.concat(RUBY_EXTENSION) unless full_pack_path.end_with?(RUBY_EXTENSION)
          return File.exist?(full_pack_path) && full_pack_path
        end
      end
    end
  end
end
