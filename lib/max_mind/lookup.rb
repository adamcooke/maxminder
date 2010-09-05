module MaxMind
  class Lookup
    
    def initialize(raw)
      @attributes = Hash.new
      for key, value in raw.split(';').map{|r| r.split('=', 2)}
        field_name, type = mapping[key]
        @attributes[field_name] = parse_value(value, type)
      end
    end
    
    ## Return the appropriate attribute from the attributes hash.
    def method_missing(name)
      super unless mapping.values.map(&:first).include?(name.to_sym)
      @attributes[name.to_sym]
    end
    
    private
    
    ## This is the mapping of response attributes to their local variable name
    ## and type of data which is expected.
    def mapping
      {
        'countryMatch'            => [:country_match, :boolean],
        'countryCode'             => [:country_code, :string],
        'highRiskCountry'         => [:high_risk_country?, :boolean],
        'distance'                => [:distance, :integer],
        'ip_region'               => [:ip_region, :string],
        'ip_city'                 => [:ip_city, :string],
        'ip_latitude'             => [:ip_latitude, :decimal],
        'ip_longitude'            => [:ip_longitude, :decimal],
        'ip_isp'                  => [:ip_isp, :string],
        'ip_org'                  => [:ip_organisation, :string],
        'anonymousProxy'          => [:anonymous_proxy?, :boolean],
        'proxyScore'              => [:proxy_score, :float],
        'isTransProxy'            => [:transparent_proxy?, :boolean],
        'freeMail'                => [:free_email?, :boolean],
        'carderEmail'             => [:high_risk_email?, :boolean],
        'highRiskUsername'        => [:high_risk_username?, :boolean],
        'highRiskPassword'        => [:high_risk_password?, :boolean],
        'binMatch'                => [:bin_match?, :boolean],
        'binCountry'              => [:bin_country, :string],
        'binNameMatch'            => [:bin_name_match?, :boolean],
        'binName'                 => [:bin_name, :string],
        'binPhoneMatch'           => [:bin_phone_match?, :boolean],
        'binPhone'                => [:bin_phone, :string],
        'custPhoneInBillingLoc'   => [:phone_in_billing_location?, :boolean],
        'shipForward'             => [:mail_drop_address?, :boolean],
        'cityPostalMatch'         => [:city_matches_postal?, :boolean],
        'shipCityPostalMatch'     => [:ship_city_matches_postal?, :boolean],
        'score'                   => [:score, :decimal],
        'explanation'             => [:explaination, :string],
        'riskScore'               => [:risk_score, :decimal],
        'queriesRemaining'        => [:queries_remaining, :decimal],
        'maxmindID'               => [:id, :string],
        'err'                     => [:error, :string]
      }
    end
    
    ## Return a value as an instance of an appropriate ruby object.
    def parse_value(value, type = :string)
      case type
      when :integer then value.to_i
      when :decimal then value.to_f
      when :boolean
        case value
        when 'Yes' then true
        when 'No' then false
        else
          nil
        end
      else
        value
      end
    end
    
  end
end
