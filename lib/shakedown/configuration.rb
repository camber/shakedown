module Shakedown
  class Configuration
    attr_accessor :host, :namespace
    attr_reader :start, :stop

    def initialize
      @host = "http://localhost:1234"
      @namespace = nil
      @start = lambda {}
      @stop = lambda {}
    end

    def start(&block)
      @start = block
    end

    def start!
      @start.call()
    end

    def stop(&block)
      @stop = block
    end

    def stop!
      @start.call()
    end
  end
end

