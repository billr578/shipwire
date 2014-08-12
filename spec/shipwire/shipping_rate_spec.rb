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

  it 'should have valid return values for a shipping quote' do
    shipping_rate = Shipwire::ShippingRate.new({
      address: address,
      items: items
    })

    shipping_rate.send
    shipping_rate.parse_response

    shipping_quote = shipping_rate.shipping_quotes.first
    expect(shipping_quote[:service]).to_not be nil
    expect(shipping_quote[:carrier_code]).to_not be nil
    expect(shipping_quote[:code]).to_not be nil
    expect(shipping_quote[:cost]).to be > 0
    expect(shipping_quote[:subtotals][:freight]).to be > 0.0
    expect(shipping_quote[:subtotals][:insurance]).to eql 0.0
    expect(shipping_quote[:subtotals][:packaging]).to eql 0.0
    expect(shipping_quote[:subtotals][:handling]).to eql 0.0
  end
end
