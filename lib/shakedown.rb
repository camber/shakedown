require "net/http"
require "uri"
require "json"
require "formatador"

require "shakedown/version"
require "shakedown/configuration"
require "shakedown/errors"
require "shakedown/runner"
require "shakedown/sequence"


module Shakedown
  def self.configure
    yield config
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.sequence(&block)
    sequence = Sequence.new(config, block)

    begin
      config.start!
      sequence.run!
    ensure
      config.stop!
    end
  end
end

