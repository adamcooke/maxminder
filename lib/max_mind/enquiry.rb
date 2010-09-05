module MaxMind
  class Enquiry
    
    attr_accessor :attributes
    
    def initialize(attributes = {})
      self.attributes = attributes if attributes.is_a?(Hash)
    end
    
    ## The attributes here will be sent to max mind
    def sendable_attributes
      hash = Hash.new
      for field, data in attributes
        hash[mapping[field]] = data
      end
      hash['license_key'] = MaxMind.licence_key
      hash
    end
    
    ## Run the check and return a hash of responses from the server.
    def lookup
      MaxMind.logger.debug "Beginning lookups"
      MaxMind.logger.debug "('#{sendable_attributes.inspect}')"
      for endpoint in MaxMind.endpoints
        MaxMind.logger.debug "Attempting lookup on #{endpoint}"
        uri = URI.parse(endpoint)
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data(sendable_attributes)
        res = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        
        begin
          case res = res.request(req)
          when Net::HTTPSuccess
            return Lookup.new(res.body)
          else
            MaxMind.logger.debug "Error on #{endpoint} (#{res.class.to_s})"
            next
          end
        rescue Timeout::Error
          MaxMind.logger.debug "Timed out connecting to #{endpoint}"
          next
        end
      end
      
      false
    end
    
    ## Set or get an attribute from the attributes hash or raise 
    ## no method error if it doesn't exist in our mapping.
    def method_missing(name, value = nil)
      attribute_name = name.to_s.gsub(/\=\z/, '').to_sym
      return super unless mapping.keys.include?(attribute_name)
      value ? (attributes[attribute_name] = value) : attributes[attribute_name]
    end
    
    ## Various methods to make setting fields in the attributes hash 
    ## a little easier.
    attr_reader :email, :username, :password
    
    def email=(value)
      @email = value
      self.attributes[:email_md5] = Digest::MD5.hexdigest(value)
      self.attributes[:email_domain] = value.split('@', 2).last
      value
    end
    
    def username=(value)
      @username = value
      self.attributes[:username_md5] = Digest::MD5.hexdigest(value)
      value
    end
    
    def password=(value)
      @password = value
      self.attributes[:password_md5] = Digest::MD5.hexdigest(value)
      value
    end
    
    private
    
    ## This method returns a mapping of method names to the appropriate attribute
    ## expected by the MaxMind API.
    def mapping
      {
        :ip_address         => 'i',
        :forwarded_ip       => 'forwardedIP',
        
        :city               => 'city',
        :region             => 'region',
        :postal             => 'postal',
        :country            => 'country',

        :shipping_address   => 'shipAddr',
        :shipping_city      => 'shipCity',
        :shipping_region    => 'shipRegion',
        :shipping_postal    => 'shipPostal',
        :shipping_country   => 'shipCountry',
        
        :email_domain       => 'domain',
        :email_md5          => 'emailMD5',
        :username_md5       => 'usernameMD5',
        :password_md5       => 'passwordMD5',
        
        :bin                => 'bin',
        :bin_name           => 'binName',
        :bin_phone          => 'binPhone',
        
        :transaction_id     => 'txnID',
        :session_id         => 'sessionID',
        :user_agent         => 'user_agent',
        :accept_language    => 'accept_language'
      }
    end
    
  end
end
