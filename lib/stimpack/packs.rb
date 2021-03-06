# frozen_string_literal: true

require "active_support"
require "pathname"
require "rails"

module Stimpack
  module Packs
    PACK_CLASS = "Pack"

    class << self
      def resolve
        # Gather all the directories with package config files.
        paths = filter(Pack.root.glob("**/#{Pack::Configuration::FILE}").map(&:dirname).sort)

        # Create thes packs.
        paths.each do |path|
          pack = Pack.new(path)
          @packs[pack.name] = pack
        end
      end

      def find(path)
        path = "#{path}/"

        @packs.values.find do |pack|
          path.start_with?("#{pack.path}/")
        end
      end

      def [](name)
        @packs[name]
      end

      def each(*args, &block)
        @packs.each_value(*args, &block)
      end

      private

      def filter(paths)
        # Reject all paths that are nested since they might be just packwerk
        # packages instead of packs.
        paths.reject do |path|
          path = "#{path}/"
          paths.any? do |other_path|
            other_path = "#{other_path}/"
            path != other_path && path.start_with?(other_path)
          end
        end
      end
    end

    @packs = {}
  end
end
