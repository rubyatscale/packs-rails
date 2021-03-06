module Stimpack
  class Stim < Module
    def initialize(pack, namespace)
      @pack = pack
      @namespace = namespace
      super()
    end

    def included(engine)
      engine.called_from = @pack.path
      engine.extend(ClassMethods)
      engine.isolate_namespace(@namespace)

      # Set all of these paths to nil because we want the Rails integration to take
      # care of them. The purpose of this Engine is really just for the namespace
      # isolation.
      (Stimpack::Integrations::Rails::PATHS +
        # In addition to the paths we've delegated to the main app, we don't allow
        # Engine Packs to have various capabilities.
        %w(
          config/environments
          db/migrate
        )
      ).uniq.each do |path|
        engine.paths[path] = nil
      end
    end

    module ClassMethods
      def find_root(_from)
        called_from
      end
    end
  end
end
