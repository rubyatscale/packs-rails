require "pathname"

rails_dir = require_test_rails_application

RSpec.describe Packs::Rails do
  it "autoloads classes in autoload paths" do
    expect(defined?(Shirts::ShortSleeve)).to eq("constant")
  end

  it "adds pack paths to the application" do
    Packs::Rails.config.paths.each do |path|
      expect(Rails.application.paths[path].paths).to include(rails_dir.join('packs', "shirts", path))
    end
  end

  it "does not add gem paths to the application" do
    Packs::Rails.config.paths.each do |path|
      expect(Rails.application.paths[path].paths).to_not include(rails_dir.join('components', "jackets", path))
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
      Packs::Rails.config.paths.each do |path|
        expect(Rails.application.paths[path].paths).to include(rails_dir.join('packs', "pants", "shorts", path))
      end
    end

    it "creates engines namespace for engine packs" do
      expect(defined?(Shorts::Engine)).to eq("constant")
    end
  end

  context 'alternate roots' do
    it "autoloads classes in autoload paths" do
      expect(defined?(Belts::Brown)).to eq("constant")
    end

    it "adds pack paths to the application" do
      Packs::Rails.config.paths.each do |path|
        expect(Rails.application.paths[path].paths).to include(rails_dir.join('utilities', "belts", path))
      end
    end
  end
end
