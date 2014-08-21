require 'spec_helper'

describe Shipwire::Tracking, vcr: true do
  let(:configuration) { Shipwire.configuration }

  it 'should raise error if bookmark set to 1' do
    expect { Shipwire::Tracking.new({ bookmark: '1' }) }.to raise_error(Shipwire::TrackingError)
  end

  it 'should get back some tracking responses' do
    tracking = Shipwire::Tracking.new({
      bookmark: '2'
    })

    tracking.send
    tracking.parse_response

    expect(tracking.order_responses.length).to be > 0
  end
end
