module Shakedown
  class Runner
    COLORS = {
      pending: 'yellow',
      success: 'green',
      failed:  'red'
    }

    SYMBOLS = {
      pending: '–',
      success: '✔',
      failed:  '✖'
    }

    attr_reader :type, :url, :params

    def initialize(type, url, params)
      @url    = url
      @params = params
      @type   = type
      @json   = nil
      @status = nil
    end

    def run
      print_status(:pending)
      @json = JSON.parse(response.body)
      @status = response.code.to_i
      return self
    end

    def print_status(status, update=false)
      message = "[#{COLORS[status]}]#{SYMBOLS[status]} #{type.to_s.upcase.ljust(8)} #{url}[/]"

      if update
        Formatador.redisplay(message)
        puts
      else
        Formatador.display(message)
      end
    end

    def uri
      URI.parse(url)
    end

    def http
      Net::HTTP.new(uri.host, uri.port)
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

    def response
      http.request(request)
    end

    def json(expected)
      assert_equal(@json, JSON.parse(expected.to_json))
    end

    def status(expected)
      assert_equal(@status, expected)
    end

    def assert(assertions=nil)
      print_status(:success, true)

      if assertions.nil?
        return self
      end

      begin
        instance_eval &assertions
      rescue NotEqualError => e
        print_status(:failed, true)
        puts
        puts "Expected: #{e.expected}"
        puts "     Got: #{e.got}"
        puts
        exit
      end
    end

    def assert_equal(a, b)
      raise NotEqualError.new(a, b) unless a == b
    end
  end
end
