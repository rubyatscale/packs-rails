module Stimpack
  module Integrations
    class RSpec
      def self.install(app)
        return unless defined?(::RSpec)
        return unless ::RSpec.respond_to?(:configuration)

        Packs.each do |pack|
          ::RSpec.configuration.pattern.concat(",#{pack.relative_path.join("spec/**/*_spec.rb")}")
        end
      end
    end
  end
end
