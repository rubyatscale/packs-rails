# frozen_string_literal: true

module Kernel
  module_function

  alias_method :stimpack_original_require, :require

  def require(path)
    stimpack_original_require(Stimpack::Require.resolve(path) || path)
  end
end
