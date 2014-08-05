require 'spec_helper'

describe Shipwire::ShippingRate, vcr: true do
  let(:configuration) { Shipwire.configuration }

  let(:address) {
    {
      address1: '540 West Boylston St.',
      city: 'Worcester',
      state: 'MA',
      country: 'US',
      zip: '01606'
    }
  }

  let(:items) { [{ code: '123456', quantity: 1 }] }

  let(:non_existing_items) { [{ code: 'ABCDEFG', quantity: 1 } ]}

  it 'should get back a valid shipping response' do
    shipping_rate = Shipwire::ShippingRate.new({
      address: address,
      items: items
    })

    shipping_rate.send
    shipping_rate.parse_response
    expect(shipping_rate.shipping_quotes.count).to be > 0
  end

  it 'should have no shipping rates for an unknown item code' do
    shipping_rate = Shipwire::ShippingRate.new({
      address: address,
      items: non_existing_items
    })

    shipping_rate.send
    shipping_rate.parse_response
    expect(shipping_rate.shipping_quotes.count).to eql(0)
    expect(shipping_rate.errors.count).to be > 0
  end
end
