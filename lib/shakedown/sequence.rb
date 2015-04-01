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

    def get(url, params={}, &assertion)
      request = Request.new(:get, url_for(url), params)
      assert(request, assertion)
    end

    def post(url, params={}, &assertion)
      request = Request.new(:post, url_for(url), params)
      assert(request, assertion)
    end

    def delete(url, params={}, &assertion)
      request = Request.new(:delete, url_for(url), params)
      assert(request, assertion)
    end

    def assert(request, callable)
      assertion = Assertion.new(callable)

      if assertion.status != request.status
        puts " ✖ #{request.type.to_s.upcase.ljust(7)} #{request.url}".red
        puts
        puts "Expected: #{assertion.status}"
        puts "  Actual: #{request.status}"
        puts
        exit
      end

      if assertion.body != request.body
        puts " ✖ #{request.type.to_s.upcase.ljust(7)} #{request.url}".red
        puts
        puts "Expected: #{assertion.body}"
        puts "  Actual: #{request.body}"
        puts
        exit
      end

      puts " ✔ #{request.type.to_s.upcase.ljust(7)} #{request.url}".green
    end
  end

  class Assertion
    class Null
      def self.==(other)
        true
      end
      def self.!=(other)
        false
      end
    end

    attr_reader :status, :body

    def initialize(callable)
      @status = Null
      @body = Null
      unless callable.nil?
        @body = JSON.parse(instance_eval(&callable).to_json)
      end
    end

    def status(code=nil)
      @status = code unless code.nil?
      @status
    end
  end

  class Request
    attr_reader :type, :url, :params

    def initialize(type, url, params={})
      @type   = type
      @url    = url
      @params = params
    end

    def body
      @body ||= JSON.parse(response.body)
    end

    def status
      @status ||= response.code.to_i
    end

    def uri
      URI.parse(url)
    end

    def http
      Net::HTTP.new(uri.host, uri.port)
    end

    def response
      @response ||= http.request(request)
    end

    def request
      case type
      when :get
        request = Net::HTTP::Get.new(uri.request_uri)
      when :post
        request = Net::HTTP::Post.new(uri.request_uri)
      when :delete
        request = Net::HTTP::Delete.new(uri.request_uri)
      end

      request.set_form_data(params)
      request
    end
  end
end

