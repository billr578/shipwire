require 'spec_helper'

RSpec.describe "Orders", type: :feature, vcr: true do
  context "list" do
    context "without params" do
      it "is successful" do
        VCR.use_cassette("orders_list") do
          request = Shipwire::Orders.new.list

          expect(request.ok?).to be_truthy
        end
      end
    end

    context "with params" do
      it "is successful" do
        VCR.use_cassette("orders_list_with_params") do
          request = Shipwire::Orders.new.list({
            status: "canceled"
          })

          expect(request.ok?).to be_truthy
        end
      end
    end
  end

  context "management" do
    let(:payload) do
      order_number = (0...8).map { (65 + rand(26)).chr }.join

      {
        orderNo: order_number,
        externalId: order_number,
        items: [
          {
            sku: "FAKE-PRODUCT",
            quantity: 1
          }
        ],
        options: {
          currency: "USD"
        },
        shipTo: {
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

    let(:payload_update) do
      payload.deep_merge({
        options: {
          currency: "MXN"
        }
      })
    end

    let!(:order) do
      VCR.use_cassette("order") do
        Shipwire::Orders.new.create(payload)
      end
    end

    context "create" do
      xit "fails with duplicate order" do
      end
    end

    context "find" do
      context "without params" do
        it "is successful" do
          VCR.use_cassette("order_find") do
            order_id = order.response.resource.items.first.resource.id

            request = Shipwire::Orders.new.find(order_id)

            expect(request.ok?).to be_truthy
          end
        end
      end

      context "with params" do
        it "is successful" do
          VCR.use_cassette("order_find_with_params") do
            order_id = order.response.resource.items.first.resource.id

            request = Shipwire::Orders.new.find(order_id, {
              expand: "trackings"
            })

            expect(request.ok?).to be_truthy
          end
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("order_find_fail") do
          request = Shipwire::Orders.new.find(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "update" do
      context "without params" do
        it "is successful" do
          VCR.use_cassette("order_update") do
            order_id = order.response.resource.items.first.resource.id

            request = Shipwire::Orders.new.update(order_id, payload_update)

            expect(request.ok?).to be_truthy
          end
        end
      end

      context "with params" do
        it "is successful" do
          VCR.use_cassette("order_update_with_params") do
            order_id = order.response.resource.items.first.resource.id

            request = Shipwire::Orders.new.update(order_id, payload_update, {
              expand: "all"
            })

            expect(request.ok?).to be_truthy
          end
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("order_update_fail") do
          request = Shipwire::Orders.new.update(0, payload_update)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "items" do
      it "is successful" do
        VCR.use_cassette("order_items") do
          order_id = order.response.resource.items.first.resource.id

          request = Shipwire::Orders.new.items(order_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("order_items_fail") do
          request = Shipwire::Orders.new.items(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "holds" do
      context "without params" do
        it "is successful" do
          VCR.use_cassette("order_holds") do
            order_id = order.response.resource.items.first.resource.id

            request = Shipwire::Orders.new.holds(order_id)

            expect(request.ok?).to be_truthy
          end
        end
      end

      context "with params" do
        it "is successful" do
          VCR.use_cassette("order_holds_with_params") do
            order_id = order.response.resource.items.first.resource.id

            request = Shipwire::Orders.new.holds(order_id, {
              includeCleared: 1
            })

            expect(request.ok?).to be_truthy
          end
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("order_holds_fail") do
          request = Shipwire::Orders.new.holds(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "returns" do
      xit "is successful" do
        VCR.use_cassette("order_returns") do
          order_id = order.response.resource.items.first.resource.id

          binding.pry
          request = Shipwire::Orders.new.returns(order_id)
          binding.pry

          expect(request.ok?).to be_truthy
        end
      end

      xit "fails when id does not exist" do
        VCR.use_cassette("order_returns_fail") do
          request = Shipwire::Orders.new.returns(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "trackings" do
      it "is successful" do
        VCR.use_cassette("order_trackings") do
          order_id = order.response.resource.items.first.resource.id

          request = Shipwire::Orders.new.trackings(order_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("order_trackings_fail") do
          request = Shipwire::Orders.new.trackings(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "cancel" do
      it "is successful" do
        VCR.use_cassette("order_cancel") do
          order_id = order.response.resource.items.first.resource.id

          request = Shipwire::Orders.new.cancel(order_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("order_cancel_fail") do
          request = Shipwire::Orders.new.cancel(0)

          expect(request.errors?).to be_truthy
        end
      end
    end
  end
end
