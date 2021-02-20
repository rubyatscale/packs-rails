module Stimpack
  class Stim < Module
    def initialize(path)
      @path = path
      super()
    end

    def included(engine)
      engine.called_from = @path
      engine.extend(ClassMethods)
      settings = engine.settings

      if settings.isolate_namespace?
        engine.isolate_namespace(settings.namespace)
      end

      # if settings.implicit_namespace?
      #   engine.paths["lib"].skip_load_path!
      # end
    end

    module ClassMethods
      def find_root(_from)
        called_from
      end

      def settings
        @settings ||= Stimpack::Settings.new(self)
      end
    end
  end
end
