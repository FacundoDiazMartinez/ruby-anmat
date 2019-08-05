require "ruby/anmat/version"
require 'savon'
require 'ruby/anmat/constants'

module Ruby
  module Anmat
    class Error < StandardError; end

    def self.root
    	File.expand_path '../..', __FILE__
  	end

  	autoload :Traceability,   "ruby/anmat/traceability"
  end
end
