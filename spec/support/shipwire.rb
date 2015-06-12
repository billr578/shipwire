RSpec.configure do |config|
  config.before :each do
    Shipwire.configure do |c|
      # c.username = "billr578@gmail.com"
      # c.password = "black.cat!17"
      c.username = "david.freerksen@groundctrl.com"
      c.password = "gOg6maBr6E"
      c.endpoint = 'https://api.beta.shipwire.com'
    end
  end
end
