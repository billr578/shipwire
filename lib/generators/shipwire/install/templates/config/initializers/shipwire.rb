Shipwire.configure do |config|
  # Note there is a difference between an account registered from
  # https://www.shipwire.com/ and one registered from https://beta.shipwire.com/
  #
  # If you create an account from https://www.shipwire.com/ and then request
  # data from the beta URL, the API will throw errors about an invalid account.

  #############################################################################

  # Shipwire username (email address) used for basic auth login to Shipwire
  config.username = "<%= ENV['SHIPWIRE_USERNAME'] %>"

  # Shipwire password used for basic auth login to Shipwire.
  config.password = "<%= ENV['SHIPWIRE_PASSWORD'] %>"

  # Read timeout Integer in seconds. Default is 2 seconds
  # config.open_timeout = 2

  # Open/read timeout Integer in seconds. Default is 5 seconds
  # config.timeout = 5

  # Endpoint base URL to use for requests. Specifying a value here will use that
  # value is all Rails environments. Default is 'https://api.shipwire.com' for
  # config.endpoint = 'https://api.shipwire.com'
end
