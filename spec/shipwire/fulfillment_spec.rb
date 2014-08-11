require 'spec_helper'

describe Shipwire::Fulfillment, vcr: true do
  let(:configuration) { Shipwire.configuration }

  let(:address) {
    {
      first_name: 'Bill',
      last_name: 'Rowell',
      address1: '540 West Boylston St.',
      city: 'Worcester',
      state: 'MA',
      country: 'US',
      zip: '01606',
      phone: '555-555-5555'
    }
  }

  let(:orders) { [
    order_number: 'W0000001',
    shipping: 'GD',
    email: 'test@example.com',
    items: [{ code: '123456', quantity: 1 }],
    address: address
  ] }

  it 'should get back a valid fulfillment response' do
    fulfillment = Shipwire::Fulfillment.new({
      orders: orders
    })

    fulfillment.send
    fulfillment.parse_response
    expect(fulfillment.order_responses.count).to be > 0
  end
end
