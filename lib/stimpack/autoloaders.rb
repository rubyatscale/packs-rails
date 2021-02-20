module Stimpack
  module Autoloaders
    def main
      Stimpack.autoloader(super)
    end

    def once
      Stimpack.autoloader(super)
    end
  end
end
