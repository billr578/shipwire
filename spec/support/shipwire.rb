RSpec.configure do |config|
  config.before :each do
    Shipwire.configure do |c|
      c.username = "david.freerksen@groundctrl.com"
      c.password = "gOg6maBr6E"
      c.endpoint = "https://api.beta.shipwire.com"
      c.logger   = false
    end
  end
end
