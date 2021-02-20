require "rails"

module Stimpack
  module Packages
    def self.paths
      @paths ||= {}
    end

    def self.create(name, path)
      paths[name] = path

      class_eval(<<~RUBY, __FILE__, __LINE__ + 1)
        module ::#{name}
          class Engine < ::Stimpack::Package
          end
        end
      RUBY

      engine = const_get("::#{name}::Engine")
      # Isolate the package namespace.
      engine.isolate_namespace(engine.module_parent)

      # Disable Railtie initializers for Packages.
      engine.paths["config/initializers"] = nil

      engine.paths["lib/tasks"] = "tasks"
      engine.paths["db/migrate"] = "migrations"
      engine.paths["config/routes.rb"] = "routes.rb"

      if engine.paths["db/migrate"].existent.any?
        ActiveRecord::Migrator.migrations_paths << engine.paths["db/migrate"].first
      end
    end
  end
end
