require 'spec_helper'

RSpec.describe "Rate", type: :feature, vcr: true do
  context "find" do
    let(:options) do
      { currency: "USD", groupBy:  "all" }
    end

    let(:address) do
      {
        address1: "540 West Boylston St.",
        city: "Worcester",
        postalCode: "01606",
        region: "MA",
        country: "US",
      }
    end

    let(:good_items) do
      { sku: "TEST-PRODUCT", quantity: 1 }
    end

    let(:bad_items) do
      { sku: "NON-EXISTANT-PRODUCT", quantity: 1 }
    end

    it "is successful with existing items" do
      VCR.use_cassette("rate_find") do
        payload = {
          options: options,
          order: {
            shipTo: address,
            items: [good_items]
          }
        }

        request = Shipwire::Rate.new.find(payload)

        expect(request.ok?).to be_truthy
      end
    end

    it "fails with non existing items" do
      VCR.use_cassette("rate_find_fail") do
        payload = {
          options: options,
          order: {
            shipTo: address,
            items: [bad_items]
          }
        }

        request = Shipwire::Rate.new.find(payload)

        expect(request.errors?).to be_truthy
        expect(request.errors).to include(
          'One or more errors occurred processing this rate request.'
        )
      end
    end
  end
end
