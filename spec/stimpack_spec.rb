# typed: ignore

require "pathname"

rails_dir = Pathname.new(File.expand_path("fixtures/rails-7.0", __dir__))
Dir.chdir(rails_dir)
require_relative rails_dir.join("config/environment")

RSpec.describe Stimpack do
  it "autoloads classes in autoload paths" do
    expect(defined?(Shirts::ShortSleeve)).to eq("constant")
  end

  it "adds pack paths to the application" do
    Stimpack.config.paths.each do |path|
      expect(Rails.application.paths[path].paths).to include(rails_dir.join(Stimpack.config.root, "shirts", path))
    end
  end

  it "creates engines namespace for engine packs" do
    expect(defined?(Shoes::Engine)).to eq("constant")
  end

  context 'nested packs' do
    it "autoloads classes in autoload paths" do
      expect(defined?(Shorts::Linen)).to eq("constant")
    end

    it "adds pack paths to the application" do
      Stimpack.config.paths.each do |path|
        expect(Rails.application.paths[path].paths).to include(rails_dir.join(Stimpack.config.root, "pants", "shorts", path))
      end
    end

    it "creates engines namespace for engine packs" do
      expect(defined?(Shorts::Engine)).to eq("constant")
    end
  end

  context 'packs with automatic namespaces' do
    it 'can find namespaced models without namespace dirs' do
      expect(defined?(Jackets::Winter)).to eq("constant")
      expect(defined?(Jackets::Summer)).to eq("constant")
    end

    xit 'can access methods on the root namespace defined in `jackets.rb`' do
      # left as a skipped test to reveal the intention that
      #    a) we want this behavior
      #    b) we recognize this behavior is not working at this time
      #    c) we felt the overall feature has value despite this shortcoming
      expect(Jackets.test_operation).to eq("test result")
    end

    # This should pass once we ensure that *both* paths are added to *and* we push a custom root dir
    it 'can access methods on the root namespace when defined using hacky pattern' do
      expect(Jackets.other_test_operation).to eq("other test result")
    end

    context 'pack is nested' do
      it 'can find namespaced models without namespace dirs' do
        expect(defined?(Coats::Parkas)).to eq("constant")
      end
    end
  end
end
