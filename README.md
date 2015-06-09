# Shipwire

Ruby gem to integrate with Shipwire's API.


## Installation

Install locally with

```
gem install shipwire
```

Add this line to your application's Gemfile:

```
gem 'shipwire'
```

> Note: The master branch is not guaranteed to be in a fully functioning state. It is unwise to use this branch in a production environment.


Run the bundle command:

```
bundle install
```

If you are using Rails, run the generator:

```
rails g shipwire:install
```


## Configuration

There is a difference between an account registered from [https://www.shipwire.com/](https://www.shipwire.com/) and one registered from [https://beta.shipwire.com/](https://beta.shipwire.com/) If you create an account from [https://www.shipwire.com/](https://www.shipwire.com/) and then request data from the beta URL, the API will throw errors about an invalid account. Accounts are only valid from that registration point.

`username` - (required) Shipwire username (email address) used for basic auth login to Shipwire

`password` - (required) Shipwire password used for basic auth login to Shipwire.

`open_timeout` - Read timeout in seconds. Default is 2.

`timeout` - Open/read timeout in seconds. Default is 5.

`endpoint` -  Endpoint base URL to use for requests. Specifying a value here will use that value is all Rails environments. Default is 'https://api.shipwire.com' for Rails production environment and 'https://api.beta.shipwire.com' for all other Rails environments.

`server` - Server type to use for requests. Specifying a value here will use that value is all Rails environments. Available options are 'Production' and 'Test'. Default is 'Production' in Rails production environment and 'Test' in all other Rails environments. Note the capital P and T on the values.


## Testing

Tests are using a throwaway Shipwire (beta) account that is only meant for testing. A personal Shipwire Beta account is not required.

```
bundle exec rake spec
```

or

```
bundle exec rspec spec
```


## TODO

- Remove Rails dependency
- Required option validation
- Option type validation
- Option value validation


## Contributions

If making contributions to this gem, make sure you write tests for any new functionality. Contributions will be rejected if there are no tests or tests do not pass.


## Contributing

1. Fork it ( https://github.com/billr578/shipwire/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
