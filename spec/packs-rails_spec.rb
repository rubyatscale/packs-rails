require "pathname"

RSpec.describe Packs::Rails do
  shared_examples_for "uh.." do
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

    context 'custom engine name' do
      it "autoloads classes in autoload paths" do
        expect(defined?(Pants::Jeans::Bootcut)).to eq("constant")
      end

      it "adds pack paths to the application" do
        Packs::Rails.config.paths.each do |path|
          expect(Rails.application.paths[path].paths).to include(rails_dir.join('packs', "pants", "jeans", path))
        end
      end

      it "creates engines namespace for engine packs" do
        expect(defined?(Pants::Jeans::Engine)).to eq("constant")
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

  context "rails 6.1" do
    let!(:rails_dir) { require_test_rails_application("6.1") }
    it_behaves_like "uh.."
  end

  context "rails 7.0" do
    let!(:rails_dir) { require_test_rails_application("7.0") }
    it_behaves_like "uh.."
  end
end
