module Shakedown
  class Sequence
    attr_reader :config

    def initialize(config, block)
      @config = config
      @runnable = block
    end

    def run!
      instance_eval &@runnable
    end

    def base_url
      [config.host, config.namespace].compact.join('/')
    end

    def url_for(url)
      [base_url, url].join
    end

    def get(url, params={}, &assertions)
      Runner.new(:get, url_for(url), params).run.assert(assertions)
    end

    def post(url, params={}, &assertions)
      Runner.new(:post, url_for(url), params).run.assert(assertions)
    end

    def delete(url, params={}, &assertions)
      Runner.new(:delete, url_for(url), params).run.assert(assertions)
    end
  end
end

