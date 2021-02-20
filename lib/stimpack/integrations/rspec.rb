module Stimpack
  module Integrations
    class RSpec
      def self.install
        return unless defined?(::RSpec)

        Packs.each do |pack|
          ::RSpec.configuration.pattern.concat(",#{pack.settings.relative_path.join("spec/**/*_spec.rb")}")
        end
      end
    end
  end
end
