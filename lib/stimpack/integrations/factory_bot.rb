module Stimpack
  module Integrations
    class FactoryBot
      def self.install(app)
        return unless app.config.respond_to?(:factory_bot)

        Packs.each do |pack|
          app.config.factory_bot.definition_file_paths << pack.relative_path.join("spec/factories").to_s
        end
      end
    end
  end
end
