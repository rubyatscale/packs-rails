require "active_support"

module Stimpack
  class ZeitwerkProxy
    delegate_missing_to :@loader

    def initialize(loader)
      @loader = loader
    end

    def push_dir(path, namespace: Object)
      @loader.push_dir(path, namespace: _resolve_namespace(path) || namespace)
    end

    private

    def _resolve_namespace(path)
      pack = Packs.find(path)
      return unless pack

      pack.settings.namespace if pack.settings.implicit_namespace?
    end
  end
end
