require 'spec_helper'

RSpec.describe "Rate", type: :feature, vcr: true do
  context "find" do
    xit "is successful with existing items" do
      VCR.use_cassette("rate_find") do
        request = Shipwire::Rate.new.find(payload)

        expect(request.ok?).to be_truthy
      end
    end

    it "fails with non existing items" do
      VCR.use_cassette("rate_find_fail") do
        bad_payload = payload
        bad_payload[:order][:items][0][:sku] = 'FAKE-PRODUCT'

        request = Shipwire::Rate.new.find(bad_payload)

        expect(request.errors?).to be_truthy
        expect(request.errors).to include "unknown SKU 'FAKE-PRODUCT'"
      end
    end

    def payload
      {
        options: {
          currency: "USD",
          groupBy: "all"
        },
        order: {
          shipTo: {
            address1: "540 West Boylston St.",
            city: "Worcester",
            postalCode: "01606",
            region: "MA",
            country: "US"
          },
          items: [{
            sku: "TEST-PRODUCT",
            quantity: 1
          }]
        }
      }
    end
  end
end
