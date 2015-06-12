require 'spec_helper'

RSpec.describe "General access", type: :feature, vcr: true do
  describe 'with missing credentials' do
    before do
      Shipwire.configuration.username = nil
      Shipwire.configuration.password = nil
    end

    it "raises an error" do
      VCR.use_cassette("credentials_missing") do
        request = Shipwire::Secret.new.list

        expect(request.errors?).to be_truthy
        expect(request.errors).to include(
          'Please include a valid Authorization header (Basic)'
        )
      end
    end
  end

  describe "with incorrect credentials" do
    before do
      Shipwire.configuration.username = 'fake@email.com'
      Shipwire.configuration.password = 'fake-password'
    end

    it "raises an error" do
      VCR.use_cassette("credentials_incorrect") do
        request = Shipwire::Secret.new.list

        expect(request.errors?).to be_truthy
        expect(request.errors).to include(
          'Please include a valid Authorization header (Basic)'
        )
      end
    end
  end

  describe "with incorrect base endpoint" do
    before { Shipwire.configuration.endpoint = 'https://api.fake.shipwire.com' }

    it "raises an error" do
      request = Shipwire::Secret.new.list

      expect(request.errors?).to be_truthy
      expect(request.errors).to include 'Unable to connect to Shipwire'
    end
  end

  describe "with API timeout" do
    before { Shipwire.configuration.timeout = 0.0001 }

    it "raises an error" do
      request = Shipwire::Secret.new.list

      expect(request.errors?).to be_truthy
      expect(request.errors).to include 'Shipwire connection timeout'
    end
  end
end
