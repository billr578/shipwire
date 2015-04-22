Shipwire
========

Ruby gem to integrate with Shipwire's fulfillment API.  The current implementation works with their deprecated (but still supported) XML API.  Version 2 of this gem will integrate with their current, RESTful API.

## Installation

Add this line to your application's Gemfile:

  `gem 'shipwire'`

And then execute:

  `$ bundle`

You can install it locally as:

  `$ gem install shipwire`

## Getting Started

Get a Shipwire sandbox account for development & testing:

  `http://beta.shipwire.com/`

Your credentials, endpoint, and sever environment variables need to be set:

  SHIPWIRE_USERNAME
  
  SHIPWIRE_PASSWORD
  
  SHIPWIRE_SERVER
  
  SHIPWIRE_ENDPOINT

SHIPWIRE_SERVER is either `Test` or `Production`.  SHIPWIRE_ENDPOINT is one of their API hosts:

  `https://api.shipwire.com/exec/`

Or

  `https://api.beta.shipwire.com/exec/`

Use `api.beta` for any development or testing.

## Running Tests

If making contributions to this gem, make sure you write tests for any new functionality.  Contributions will be rejected if there are no tests or tests do not pass.

#### Shipping Quotes

Shipwire relies on product SKUs being present to return a shipping quote.  In your Sandbox environment, create a test product with SKU `123456` to get quote tests to pass.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/shipwire/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
