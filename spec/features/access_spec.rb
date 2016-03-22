require 'spec_helper'

RSpec.describe "General access", type: :feature, vcr: true do
  describe 'with missing credentials' do
    before do
      Shipwire.configuration.username = nil
      Shipwire.configuration.password = nil
    end

    it "raises an error" do
      VCR.use_cassette("credentials_missing") do
        response = Shipwire::Secret.new.list

        expect(response.ok?).to be_falsy
        expect(response.error_summary).to eq(
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
        response = Shipwire::Secret.new.list

        expect(response.ok?).to be_falsy
        expect(response.error_summary).to eq(
          'Please include a valid Authorization header (Basic)'
        )
      end
    end
  end

  describe "with incorrect base endpoint" do
    before { Shipwire.configuration.endpoint = 'https://api.fake.shipwire.com' }

    it "raises an error" do
      response = Shipwire::Secret.new.list

      expect(response.ok?).to be_falsy
      expect(response.error_summary).to eq 'Unable to connect to Shipwire'
    end
  end

  describe "with API timeout" do
    before { Shipwire.configuration.timeout = 0.0001 }

    it "raises an error" do
      response = Shipwire::Secret.new.list

      expect(response.ok?).to be_falsy
      expect(response.error_summary).to eq 'Shipwire connection timeout'
    end
  end
end
