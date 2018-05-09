require 'paychex_api/version'
require 'paychex_api/client'

module PaychexAPI
  class << self
    attr_accessor :proxy
    def configure
      yield self if block_given?
    end
  end
end
