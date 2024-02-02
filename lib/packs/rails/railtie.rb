require "rails/railtie"

module Packs
  module Rails
    class Railtie < ::Rails::Railtie
      config.before_configuration do |app|
        Integrations::Rails.new(app)
        Integrations::FactoryBot.new(app)

        # This is not used within packs-rails. Rather, this allows OTHER tools to
        # hook into packs-rails via ActiveSupport hooks.
        ActiveSupport.run_load_hooks(:packs_rails, Packs)
      end

      config.after_initialize do |app|
        if defined?(Spring)
          puts "Hello Db Blasters!"
          Packs::Specification::Configuration.fetch.pack_paths.each do |dir|
            puts "#{dir}"
            Dir["#{dir}/package.yml"].each { |f|
              puts f
              Spring.watch(f)
            }
          end
        end
      end
    end
  end
end
