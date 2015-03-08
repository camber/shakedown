require "net/http"
require "uri"
require "json"
require "formatador"

require_relative "./shakedown/version"
require_relative "./shakedown/configuration"
require_relative "./shakedown/errors"
require_relative "./shakedown/runner"
require_relative "./shakedown/sequence"

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
      config.before!
      sequence.run!
      config.after!
    ensure
      config.stop!
    end
  end
end

