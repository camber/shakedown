module Shakedown
  class NotEqualError < StandardError
    attr_reader :got, :expected
    def initialize(got, expected)
      @got = got
      @expected = expected
    end
  end
end

