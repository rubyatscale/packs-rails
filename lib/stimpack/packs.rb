# frozen_string_literal: true

require "active_support"

module Stimpack
  module Packs
    class << self
      def root
        @root ||= Pack.new(Stimpack.app_root, level: 0, packs_path: Stimpack.packs_root)
      end

      def all
        @all ||= root.all_children.sort_by(&:relative_path)
      end

      def all_by_path
        @all_by_path ||= all.each_with_object({}) do |pack, map|
          map[pack.relative_path.to_s] = pack
        end
      end
    end
  end
end
