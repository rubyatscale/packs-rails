# frozen_string_literal: true

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
        @data ||= YAML.load_file(@path).fetch(KEY, {}).freeze
      end
    end
  end
end
