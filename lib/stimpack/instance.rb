require "pathname"
require "active_support/inflector"

module Stimpack
  class Instance
    def initialize
      Pathname.new("packages").glob("*/package.yml").each do |path|
        path = path.realpath.dirname
        name = ActiveSupport::Inflector.classify(path.basename)
        Stimpack::Packages.create(name, path)
      end
    end
  end
end
