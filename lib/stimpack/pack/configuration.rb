# frozen_string_literal: true

module Stimpack
  class Pack
    class Configuration
      FILE = "package.yml"
      KEY = "metadata"

      def initialize(pack)
        @pack = pack
      end

      def engine
        data.fetch("engine", false)
      end
      alias_method :engine?, :engine

      private

      def data
        @data ||= YAML.load_file(@pack.path.join(FILE)).fetch(KEY, {}).freeze
      end
    end
  end
end
