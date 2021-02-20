require "rails"
require "active_support/core_ext/module/delegation"

module Stimpack
  class Package < ::Rails::Engine
    class << self
      delegate :subclasses, to: :superclass

      def find_root(from)
        Packages.paths[module_parent.name]
      end
    end
  end
end
