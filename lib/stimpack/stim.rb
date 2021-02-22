module Stimpack
  class Stim < Module
    def initialize(settings, namespace)
      @settings = settings
      @namespace = namespace
      super()
    end

    def included(engine)
      engine.attr_accessor(:settings)
      engine.settings = @settings
      engine.called_from = @settings.path
      engine.extend(ClassMethods)

      if @settings.engine?
        engine.isolate_namespace(@namespace)
      end
    end

    module ClassMethods
      def find_root(_from)
        called_from
      end
    end
  end
end
