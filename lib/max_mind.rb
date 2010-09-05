require 'uri'
require 'net/https'
require 'logger'
require 'timeout'

require 'max_mind/enquiry'
require 'max_mind/lookup'

module MaxMind
  
  ## Exception class for generic errors.
  class Error < StandardError; end
  
  ## Exception class for when connection to the max mind service fails.
  class ConnectionError < Error; end
  
  class << self
    ## Licence key for accessing the maxmind service. A trial key
    ## can be requested from http://www.maxmind.com/app/ccv2r_signup
    attr_accessor :licence_key
    
    ## The server (or servers) to accept your request
    attr_accessor :endpoints
    
    ## Return a default array of end points if none are specified.
    def endpoints
      @endpoints || ["https://minfraud1.maxmind.com/app/ccv2r", "https://minfraud3.maxmind.com/app/ccv2r"]
    end
    
    ## Return a logger object for this MaxMind interaction
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
  
end
