# MaxMind minFraud

This is a Ruby library to the MaxMind minFraud service. It provides easy access
to run fraud checks on a variety of data.

## Installation & Setup

The library is provided in the form of a RubyGem, you can install it or just pop it
in your Gemfile.

    [sudo] gem install maxminder

Once installed, just require it and specify your MaxMind licence key.

    require 'max_mind'
    MaxMind.licence_key = 'xxxxxxxxxx'
    
If you'd like to try the MaxMind service, you can signup for a free trial on their
[website](http://www.maxmind.com/app/ccv2r_signup).

## Running enquiries

To run an enquiry just create an instance of the MaxMind::Enquiry charge and then 
run MaxMind::Enquiry#lookup to run the lookup on the MaxMind service. All the fields
below with the exception of the `ip_address`, `city`, `region`, `postal` and `country`
fields are optional.

    enquiry = MaxMind::Enquiry.new
    
    ## IP address options
    enquiry.ip_address = "123.123.123.123" # => IP address of the client
    enquiry.forwarded_ip = "123.123.123.123" # => Forwarded IP of the client
    
    ## Addresses
    enquiry.city = 'Blandford'
    enquiry.region = 'Dorset'
    enquiry.postal = 'DT11 7AA'
    enquiry.country = 'United Kingdom'
    
    enquiry.shipping_address = '4 Market Place'
    enquiry.shipping_city = 'Blandford'
    enquiry.shipping_region = 'Dorset'
    enquiry.shipping_postal = 'DT11 7AA'
    
    ## E-Mail Address` - the email address is sent to MaxMind as an MD5 hash
    ## and the domain is sent as a seperate attribute used to identify free 
    ## email hosting.
    enquiry.email = 'adam@atechmedia.com'
    
    ## Usernames & passwords` - both are sent as an MD5 hash
    enquiry.username = 'adam'
    enquiry.password = 'mypassword'
    
    ## Credit Card Checks
    enquiry.bin = '123456'  # => First 6 digits of credit card number
    enquiry.bin_name = 'HSBC Bank' #=> Name of issuing bank
    enquiry.bin_phone = '0845 123123' #=> Customer services number on back on card

    ## Information
    enquiry.transaction_id = 'ABC1234512345' #=> Transaction ID for your order.
    enquiry.session_id = '987654321' #=> Internal session ID for website
    
    if lookup = enquiry.lookup
      ## lookup was successful and lookup contains an instsance of 
      ## MaxMind::Lookup (see below)
    else
      ## lookup failed
    end

## Looking at your lookup results

Once you have run an enquiry you will be given an instance of a MaxMind::Lookup
class. This class has a number of methods which you can use...

 * `country_match` - Whether country of IP address matches billing address country (mismatch = higher risk)
 * `country_code` - Country Code of the IP address
 * `high_risk_country?` - Whether IP address or billing address country is in Egypt, Ghana, Indonesia, Lebanon, Macedonia, Morocco, Nigeria, Pakistan, Romania, Serbia and Montenegro, Ukraine, or Vietnam.

 * `distance` - Distance from IP address to Billing Location in kilometers (large distance = higher risk)
 * `ip_region` - Estimated State/Region of the IP address
 * `ip_city` - Estimated City of the IP address
 * `ip_latitude` - Estimated Latitude of the IP address
 * `ip_longitude` - Estimated Longitude of the IP address
 * `ip_isp` - ISP of the IP address
 * `ip_organisation` - Organization of the IP address
 * `anonymous_proxy?` - Whether IP address is Anonymous Proxy (anonymous proxy = very high risk)
 * `proxy_score` - Likelihood of IP Address being an Open Proxy
 * `transparent_proxy?` - Whether IP address is in our database of known transparent proxy servers, returned if forwardedIP is passed as an input.

 * `free_email?` - Whether e-mail is from free e-mail provider (free e-mail = higher risk)
 * `high_risk_email?` - Whether e-mail is in database of high risk e-mails
 * `high_risk_username?` - Whether username input is in database of high risk usernames
 * `high_risk_password?` - Whether password input is in database of high risk passwords

 * `bin_match?` - Whether country of issuing bank based on BIN number matches billing address country*
 * `bin_country` - Country Code of the bank which issued the credit card based on BIN number*
 * `bin_name_match?` - Whether name of issuing bank matches inputted binName. A return value of Yes provides a positive indication that cardholder is in possession of credit card.*
 * `bin_name` - Name of the bank which issued the credit card based on BIN number*. Available for approximately 96% of BIN numbers.
 * `bin_phone_match?` - Whether customer service phone number matches inputed bin_phone. A return value of Yes provides a positive indication that cardholder is in possession of credit card.*
 * `bin_phone` - Customer service phone number listed on back of credit card*. Available for approximately 75% of BIN numbers. In some cases phone number returned may be outdated.

 * `phone_in_billing_location?` - Whether the customer phone number is in the billing zip code.
 * `mail_drop_address?` - Whether shipping address is in database of known mail drops
 * `city_matches_postal?` - Whether billing city and state match zipcode. Currently available for US addresses only, returns empty string outside the US.
 * `ship_city_matches_postal?` - Whether shipping city and state match zipcode. Currently available for US addresses only, returns empty string outside the US.

 * `score` - Overall fraud score based on outputs listed above. This is the original fraud score, and is based on a simple formula.
 * `explanation` - A brief explanation of the score, detailing what factors contributed to it
 * `risk_score` - New fraud score representing the estimated probability that the order is fraud, based off of analysis of past minFraud transactions. 

 * `queries_remaining` - Number of queries remaining in your account, can be used to alert you when you may need to add more queries to your account
 * `id` - Unique identifier, used to reference transactions when reporting fraudulent activity back to MaxMind.
 * `error` - Returns an error string with a warning message or a reason why the request failed. 

For more information you can look at the [integration pages](http://www.maxmind.com/app/ccv) on the MaxMind website.

## Disclaimer

This library is not developed or supported by MaxMind and just uses their API. For support with your MaxMind
account directly, please contact MaxMind but if your issue is with this library, please just post an issue 
on the Github repository.
