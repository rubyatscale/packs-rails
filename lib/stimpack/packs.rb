# frozen_string_literal: true

require "active_support"

module Stimpack
  module Packs
    PACKAGE_GLOB_PATTERN = "*/#{Pack::PACKAGE_FILE}"

    class << self
      def root
        @root ||= Stimpack.root.join(Stimpack.config.root)
      end

      def find(path)
        @find_pack_paths ||= all_by_path.keys.sort_by(&:length).reverse!.map { |path| "#{path}/" }
        path = "#{path}/"
        matched_path = @find_pack_paths.find do |pack_path|
          path.start_with?(pack_path)
        end
        all_by_path.fetch(matched_path.chomp("/")) if matched_path
      end

      def all(parent = nil)
        @all ||= resolve(root).each_with_object({}) do |pack, map|
          map[pack] = resolve(pack.path).freeze
        end.freeze

        if parent
          @all[parent]
        else
          @all.keys + @all.values.flatten
        end
      end

      def all_by_path
        @all_by_path ||= all.each_with_object({}) do |pack, map|
          map[pack.relative_path.to_s] = pack
        end
      end

      private

      def resolve(directory)
        directory.glob(PACKAGE_GLOB_PATTERN).map { |path| Pack.new(path.dirname) }
      end
    end
  end
end
