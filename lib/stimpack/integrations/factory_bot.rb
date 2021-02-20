module Stimpack
  module Integrations
    class FactoryBot
      def self.install
        return unless Rails.configuration.respond_to?(:factory_bot)

        Packs.each do |pack|
          Rails.configuration.factory_bot.definition_file_paths << pack.settings.relative_path.join("spec/factories").to_s
        end
      end
    end
  end
end
