require 'spec_helper'

describe Shipwire::Inventory, vcr: true do
  let(:configuration) { Shipwire.configuration }

  let(:product_code) { 'GD802-024' }

  it 'should get back a valid response for all items' do
    inventory = Shipwire::Inventory.new()

    inventory.send
    inventory.parse_response
    expect(inventory.inventory_responses.count).to be > 0
  end

  it 'should get back a valid response for a single item' do
    pending 'Shipwire always returns 2 products.  Grrrr!'

    inventory = Shipwire::Inventory.new({ product_code: product_code })

    inventory.send
    inventory.parse_response
    expect(inventory.inventory_responses.count).to eql 1
  end
end
