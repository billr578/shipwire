require 'spec_helper'

RSpec.describe Shipwire::Response do
  describe '#error_report' do
    context 'when the response has an error summary' do
      it 'includes it in the returned text' do
        body = JSON.generate(
          'status' => 500,
          'message' => 'Something really bad happened'
        )
        underlying_response = double(:response, body: body)
        response = described_class.new(
          underlying_response: underlying_response
        )

        expected_error_summary = <<-REPORT.rstrip
Error summary:
Something really bad happened
REPORT
        expect(response.error_report).to eq(expected_error_summary)
      end
    end

    context 'when the response has validation errors' do
      it 'includes it in the returned text' do
        body = JSON.generate(
          'errors' => {
            'SKU-1' => { 'some' => 'really really really long error' },
            'SKU-2' => { 'another' => 'error' }
          }
        )
        underlying_response = double(:response, body: body)
        response = described_class.new(
          underlying_response: underlying_response
        )

        expected_validation_errors = <<-REPORT.rstrip
Validation errors:
{"SKU-1"=>{"some"=>"really really really long error"},
 "SKU-2"=>{"another"=>"error"}}
REPORT
        expect(response.error_report).to eq(expected_validation_errors)
      end
    end
  end
end
