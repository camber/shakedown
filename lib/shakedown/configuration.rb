module Shakedown
  class Configuration
    attr_accessor :host, :namespace

    def initialize
      @host = "http://localhost:1234"
      @namespace = nil
      @start  = lambda {}
      @stop   = lambda {}
      @before = lambda {}
      @after  = lambda {}
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
      @stop.call()
    end

    def before(&block)
      @before = block
    end

    def before!
      @before.call()
    end

    def after(&block)
      @after = block
    end

    def after!
      @after.call()
    end
  end
end

