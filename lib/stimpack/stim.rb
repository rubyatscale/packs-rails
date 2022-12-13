# typed: true

module Stimpack
  class Stim < Module
    extend T::Sig

    sig { params(pack: Packs::Pack, namespace: Module).void }
    def initialize(pack, namespace)
      @pack = pack
      @namespace = namespace
      super()
    end

    def included(engine)
      engine.called_from = @pack.relative_path
      engine.extend(ClassMethods)
      engine.isolate_namespace(@namespace)

      # Set all of these paths to nil because we want the Rails integration to take
      # care of them. The purpose of this Engine is really just for the namespace
      # isolation.
      (Stimpack.config.paths +
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
        T.unsafe(self).called_from
      end
    end
  end
end
