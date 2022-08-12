# frozen_string_literal: true

require "yaml"

module Stimpack
  class Pack
    class Configuration
      KEY = "metadata"

      def initialize(path)
        @path = path
      end

      def engine
        data.fetch("engine", false)
      end
      alias_method :engine?, :engine

      private

      def data
        @data ||= begin
          contents = YAML.respond_to?(:safe_load_file) ? YAML.safe_load_file(@path) : YAML.load_file(@path)
          contents ||= {}
          contents.fetch(KEY, {}).freeze
        end
      end
    end
  end
end
