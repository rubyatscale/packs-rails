module Stimpack
  module Integrations
    class RSpec
      def self.install(app)
        return unless defined?(::RSpec)
        # Sometimes, the `rspec-rails` gem is installed in the development
        # group. This means the ::RSpec module will be defined. However, this
        # doesn't mean that we've loaded rspec-core, or even about to run tests.
        # Let's make sure we are actually loading the test environment before
        # installing our integration. An easy of doing this is seeing of the
        # configuration method exists on RSpec.
        return unless ::RSpec.respond_to?(:configuration)

        Packs.each do |pack|
          ::RSpec.configuration.pattern.concat(",../#{pack.relative_path.join("spec/**/*_spec.rb")}")
        end
      end
    end
  end
end
