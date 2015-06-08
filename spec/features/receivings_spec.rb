require 'spec_helper'
require 'date'

RSpec.describe "Receivings", type: :feature, vcr: true do
  # Creating, updating, and canceling take an uncommonly long time on Shipwire's
  # end. Update the timeout to be safe.
  before { Shipwire.configuration.timeout = 10 }

  context "list" do
    context "without params" do
      it "is successful" do
        VCR.use_cassette("receivings_list") do
          request = Shipwire::Receivings.new.list

          expect(request.ok?).to be_truthy
        end
      end
    end

    context "using params" do
      it "is successful" do
        VCR.use_cassette("receivings_list_with_params") do
          request = Shipwire::Receivings.new.list(
            status: "canceled"
          )

          expect(request.ok?).to be_truthy
        end
      end
    end
  end

  context "management" do
    let!(:receiving) do
      VCR.use_cassette("receiving") do
        Shipwire::Receivings.new.create(payload)
      end
    end

    context "find" do
      context "without params" do
        it "is successful" do
          VCR.use_cassette("receiving_find") do
            receiving_id = receiving.response.resource.items.first.resource.id

            request = Shipwire::Receivings.new.find(receiving_id)

            expect(request.ok?).to be_truthy
          end
        end
      end

      context "using params" do
        it "is successful" do
          VCR.use_cassette("receiving_find_with_params") do
            receiving_id = receiving.response.resource.items.first.resource.id

            request = Shipwire::Receivings.new.find(receiving_id,
                                                    expand: "holds")

            expect(request.ok?).to be_truthy
          end
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("receiving_find_fail") do
          request = Shipwire::Receivings.new.find(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "update" do
      context "without params" do
        it "is successful" do
          VCR.use_cassette("receiving_update") do
            receiving_id = receiving.response.resource.items.first.resource.id

            payload_updates = { shipFrom: { email: FFaker::Internet.email } }
            payload_update  = payload.deep_merge(payload_updates)

            request = Shipwire::Receivings.new.update(receiving_id,
                                                      payload_update)

            expect(request.ok?).to be_truthy
          end
        end
      end

      context "using params" do
        it "is successful" do
          VCR.use_cassette("receiving_update_with_params") do
            receiving_id = receiving.response.resource.items.first.resource.id

            payload_updates = { shipFrom: { email: FFaker::Internet.email } }
            payload_update  = payload.deep_merge(payload_updates)

            request = Shipwire::Receivings.new.update(receiving_id,
                                                      payload_update,
                                                      expand: "all")

            expect(request.ok?).to be_truthy
          end
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("receiving_update_fail") do
          payload_updates = { shipFrom: { email: FFaker::Internet.email } }
          payload_update  = payload.deep_merge(payload_updates)

          request = Shipwire::Receivings.new.update(0, payload_update)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "labels_cancel" do
      it "is successful" do
        VCR.use_cassette("receiving_cancel_label") do
          receiving_id = receiving.response.resource.items.first.resource.id

          request = Shipwire::Receivings.new.labels_cancel(receiving_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("receiving_cancel_label_fail") do
          request = Shipwire::Receivings.new.labels_cancel(0)

          expect(request.ok?).to be_truthy
        end
      end
    end

    context "holds" do
      context "without params" do
        it "is successful" do
          VCR.use_cassette("receiving_holds") do
            receiving_id = receiving.response.resource.items.first.resource.id

            request = Shipwire::Receivings.new.holds(receiving_id)

            expect(request.ok?).to be_truthy
          end
        end
      end

      context "using params" do
        it "is successful" do
          VCR.use_cassette("receiving_holds_with_params") do
            receiving_id = receiving.response.resource.items.first.resource.id

            request = Shipwire::Receivings.new.holds(receiving_id,
                                                     includeCleared: 0)

            expect(request.ok?).to be_truthy
          end
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("receiving_holds_fail") do
          request = Shipwire::Receivings.new.holds(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "instructions_recipients" do
      it "is successful" do
        VCR.use_cassette("receiving_instructions_recipients") do
          receiving_id = receiving.response.resource.items.first.resource.id

          request = Shipwire::Receivings.new.instructions(receiving_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("receiving_instructions_recipients_fail") do
          request = Shipwire::Receivings.new.instructions(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "items" do
      it "is successful" do
        VCR.use_cassette("receiving_items") do
          receiving_id = receiving.response.resource.items.first.resource.id

          request = Shipwire::Receivings.new.items(receiving_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("receiving_items_fail") do
          request = Shipwire::Receivings.new.items(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "shipments" do
      it "is successful" do
        VCR.use_cassette("receiving_shipments") do
          receiving_id = receiving.response.resource.items.first.resource.id

          request = Shipwire::Receivings.new.shipments(receiving_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("receiving_shipments_fail") do
          request = Shipwire::Receivings.new.shipments(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "trackings" do
      it "is successful" do
        VCR.use_cassette("receiving_tracking") do
          receiving_id = receiving.response.resource.items.first.resource.id

          request = Shipwire::Receivings.new.trackings(receiving_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("receiving_tracking_fail") do
          request = Shipwire::Receivings.new.trackings(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "cancel" do
      it "is successful" do
        VCR.use_cassette("receiving_cancel") do
          receiving_id = receiving.response.resource.items.first.resource.id

          request = Shipwire::Receivings.new.cancel(receiving_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("receiving_cancel") do
          request = Shipwire::Receivings.new.cancel(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    def payload
      {
        externalId: FFaker::Product.model,
        expectedDate: DateTime.now.to_s,
        arrangement: {
          type: "none"
        },
        items: [{
          sku: "TEST-PRODUCT",
          quantity: 5
        }],
        shipments: [{
          length: 1,
          width: 1,
          height: 1,
          weight: 1,
          type: "box"
        }],
        options: {
          warehouseRegion: "LAX"
        },
        shipFrom: {
          email: FFaker::Internet.email,
          name: FFaker::Name.name,
          address1: "540 West Boylston St.",
          city: "Worcester",
          state: "MA",
          postalCode: "01606",
          country: "US",
          phone: FFaker::PhoneNumber.short_phone_number
        }
      }
    end
  end
end
