require "active_support"

module Stimpack
  class ZeitwerkProxy
    delegate_missing_to :@loader

    def initialize(loader)
      @loader = loader
    end

    def push_dir(absolute_path, namespace: Object)
      @loader.push_dir(absolute_path, namespace: _resolve_namespace(absolute_path) || namespace)
    end

    private

    def _resolve_namespace(absolute_path)
      pack = Packs.all.sort_by{|p| p.name.length}.find do |pack|
        absolute_path.starts_with?(pack.path.to_s)
      end
      return unless pack
      pack.find_or_create_namespace if pack.config.automatic_pack_namespace?
    end
  end
end
