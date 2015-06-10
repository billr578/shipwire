require 'spec_helper'

RSpec.describe "Returns", type: :feature, vcr: true do
  context "list" do
    context "without params" do
      it "is successful" do
        VCR.use_cassette("returns_list") do
          request = Shipwire::Returns.new.list

          expect(request.ok?).to be_truthy
        end
      end
    end

    context "using params" do
      it "is successful" do
        VCR.use_cassette("returns_list_with_params") do
          request = Shipwire::Returns.new.list(
            status: "canceled"
          )

          expect(request.ok?).to be_truthy
        end
      end
    end
  end

  context "management" do
    # Took me WAY too long to realize I can't use the variable `return`
    let!(:return_order) do
      VCR.use_cassette("return") do
        items = [{
          sku: "TEST-PRODUCT",
          quantity: 1
        }]

        order = Shipwire::Orders.new.create(
          orderNo: FFaker::Product.model,
          items: items,
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
        )

        order_id = order.response.resource.items.first.resource.id

        # There is an issue with returns. You can't create an order, then
        # immediately return it. This is the functionality that a test would be
        # doing. There is some kind of processing that needs to happen on
        # Shipwire's end. Whatever needs to happen on their end takes time. The
        # only way I was ever able to get the returns to work was to put a
        # `binding.pry` between the part where it create an order and the part
        # where it returns the order. Let it sit for about 5 minutes, then let
        # the tests continue as normal.
        Shipwire::Returns.new.create(
          originalOrder: {
            id: order_id
          },
          items: items,
          options: {
            emailCustomer: 0
          }
        )
      end
    end

    context "find" do
      context "without params" do
        it "is successful" do
          VCR.use_cassette("return_find") do
            return_id = return_order.response.resource.items.first.resource.id

            request = Shipwire::Returns.new.find(return_id)

            expect(request.ok?).to be_truthy
          end
        end
      end

      context "using params" do
        it "is successful" do
          VCR.use_cassette("return_find_with_params") do
            return_id = return_order.response.resource.items.first.resource.id

            request = Shipwire::Returns.new.find(return_id, expand: "items")

            expect(request.ok?).to be_truthy
          end
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("return_find_fail") do
          request = Shipwire::Returns.new.find(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "holds" do
      context "without params" do
        it "is successful" do
          VCR.use_cassette("return_holds") do
            return_id = return_order.response.resource.items.first.resource.id

            request = Shipwire::Returns.new.holds(return_id)

            expect(request.ok?).to be_truthy
          end
        end
      end

      context "using params" do
        it "is successful" do
          VCR.use_cassette("return_holds_with_params") do
            return_id = return_order.response.resource.items.first.resource.id

            request = Shipwire::Returns.new.holds(return_id, includeCleared: 0)

            expect(request.ok?).to be_truthy
          end
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("return_holds_fail") do
          request = Shipwire::Returns.new.holds(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "items" do
      it "is successful" do
        VCR.use_cassette("return_items") do
          return_id = return_order.response.resource.items.first.resource.id

          request = Shipwire::Returns.new.items(return_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("return_items_fail") do
          request = Shipwire::Returns.new.items(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "trackings" do
      it "is successful" do
        VCR.use_cassette("return_trackings") do
          return_id = return_order.response.resource.items.first.resource.id

          request = Shipwire::Returns.new.trackings(return_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("return_trackings_fail") do
          request = Shipwire::Returns.new.trackings(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "labels" do
      it "is successful" do
        VCR.use_cassette("return_labels") do
          return_id = return_order.response.resource.items.first.resource.id

          request = Shipwire::Returns.new.labels(return_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("return_labels_fail") do
          request = Shipwire::Returns.new.labels(0)

          expect(request.errors?).to be_truthy
        end
      end
    end

    context "cancel" do
      it "is successful" do
        VCR.use_cassette("return_cancel") do
          return_id = return_order.response.resource.items.first.resource.id

          request = Shipwire::Returns.new.cancel(return_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("return_cancel_fail") do
          request = Shipwire::Returns.new.cancel(0)

          expect(request.errors?).to be_truthy
        end
      end
    end
  end
end
