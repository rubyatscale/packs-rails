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
  end
end
