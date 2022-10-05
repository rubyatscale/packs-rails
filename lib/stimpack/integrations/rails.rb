# frozen_string_literal: true

require "active_support/inflections"

module Stimpack
  module Integrations
    class Rails
      def initialize(app)
        @app = app
        # Here we override Rails' autoloader accessors to support default pack namespaces.
        # To better understand why we do this (and what it would take to remove this), please see:
        # https://github.com/rails/rails/blob/v7.0.4/railties/lib/rails/application/finisher.rb#L17-L41
        # What Rails is doing here is taking the `ActiveSupport::Dependencies.autoload_paths`, which we add
        # to in `inject_paths`, and then calls `autoloader.push_dir`. The autoloader here is a `zeitwerk` autoloader,
        # meaning `zeitwerk` provides this API, as documented here: https://github.com/fxn/zeitwerk#root-directories-and-root-namespaces
        # Note that Rails uses these autoload paths to make first-class Rails concerns (such as loading initializers)
        # possible. Therefore it's not possible to simply *not* push to autoload paths and attempt to call `push_dir` directly ourselves,
        # as we'd lose a lot of other functionality (like initializers running).
        #
        # So by default, Rails calls `push_dir` without the optional `namespace` keyword that permits custom root namespaces.
        # In order to permit custom root namespaces, we `extend` the autoloaders with `Stimpack::Autoloaders`,
        # which wraps the autoloader with our `Stimpack::ZeitwerkProxy`. This proxy wraps `push_dir` and passes in
        # the pack namespace when it is called if the pack is using this feature.
        #
        # Instead, we'd love a way to do this more natively in Rails. There are two main paths for this:
        # 1) If Rails can provide a way for an application to add to autoload paths AND specify a custom root namespace for those
        # autoload paths simultaneously. If so, we could just pass the namespace directly in `inject_paths` instead of doing all this
        # with the `ZeitwerkProxy`.
        # 2) If Rails could simply give more lower level control over what and how zeitwerk API is called, this could be more easily
        # supported client side.
        #
        # We are hoping to find some time to chat with `rails` and/or `zeitwerk` maintainers to see if there is a better long-term path
        # forward. For now, we believe this is a reasonable enough alternative that supports the behavior without any known adverse effects.
        @app.autoloaders.extend(Stimpack::Autoloaders)

        Stimpack.config.paths.freeze
        create_engines
        inject_paths
      end

      def create_engines
        Packs.all.each do |pack|
          next unless pack.config.engine?

          pack.engine = create_engine(pack)
        end
      end

      def inject_paths
        Packs.all.each do |pack|
          Stimpack.config.paths.each do |dir|
            pack_source_path = pack.path.join(dir)
            @app.paths[dir] << pack_source_path
          end
        end
      end

      def create_engine(pack)
        name = pack.path.relative_path_from(Stimpack::Packs.root)
        namespace = pack.find_or_create_namespace
        stim = Stim.new(pack, namespace)
        namespace.const_set("Engine", Class.new(::Rails::Engine)).include(stim)
      end
    end
  end
end
