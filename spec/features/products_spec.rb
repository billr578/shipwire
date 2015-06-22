require 'spec_helper'

RSpec.describe "Product", type: :feature, vcr: true do
  context "list" do
    context "without params" do
      it "is successful" do
        VCR.use_cassette("products_list") do
          request = Shipwire::Products.new.list

          expect(request.ok?).to be_truthy
        end
      end
    end

    context "with params" do
      it "is successful" do
        VCR.use_cassette("products_list_with_params") do
          request = Shipwire::Products.new.list(
            sku: "TEST-PRODUCT"
          )

          expect(request.ok?).to be_truthy
        end
      end
    end
  end

  context "management" do
    let!(:product) do
      VCR.use_cassette("product") do
        Shipwire::Products.new.create(product_payload)
      end
    end

    context "create" do
      context "multiple products types" do
        it "is successful" do
          VCR.use_cassette("product_multiple_create_success") do
            payload = [
              product_payload,
              product_payload("insert"),
              product_payload("kit"),
              product_payload("virtual_kit")
            ]

            request = Shipwire::Products.new.create(payload)

            expect(request.ok?).to be_truthy
            expect(request.response.resource.items.count).to eq 4

            # Retire products just created
            items = request.response.resource.items
            retire_array = items.each_with_object([]) do |item, hsh|
              hsh << item.resource.id
            end
            Shipwire::Products.new.retire(retire_array)
          end
        end

        it "parts fail when classification is wrong" do
          VCR.use_cassette("product_multiple_create_fail") do
            payload = [
              product_payload,
              product_payload("insert"),
              product_payload("kit"),
              product_payload("virtual_kit")
            ]

            payload[0].deeper_merge!(
              classification: "fake"
            )

            request = Shipwire::Products.new.create(payload)

            expect(request.errors?).to be_truthy
            expect(request.response.resource.items.count).to eq 3
            expect(request.errors).to include "Product Classification not "\
                                              "detected. Please pass "\
                                              "classification for each product."

            # Retire products just created
            items = request.response.resource.items
            retire_array = items.each_with_object([]) do |item, hsh|
              hsh << item.resource.id
            end
            Shipwire::Products.new.retire(retire_array)
          end
        end
      end

      it "fails when classification is not valid" do
        VCR.use_cassette("product_create_fail_with_invalid_classification") do
          payload = product_payload.deeper_merge!(
            classification: "fake"
          )

          request = Shipwire::Products.new.create(payload)

          expect(request.errors?).to be_truthy
          expect(request.errors).to include "Product Classification not "\
                                            "detected. Please pass "\
                                            "classification for each product."
        end
      end
    end

    context "find" do
      it "is successful" do
        VCR.use_cassette("product_find") do
          product_id = product.response.resource.items.first.resource.id

          request = Shipwire::Products.new.find(product_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("product_find_fail") do
          request = Shipwire::Products.new.find(0)

          expect(request.errors?).to be_truthy
          expect(request.errors).to include 'Product not found.'
        end
      end
    end

    context "update" do
      it "is successful" do
        VCR.use_cassette("product_update") do
          product_id = product.response.resource.items.first.resource.id

          payload = product_payload.deeper_merge!(
            description: "Super awesome description"
          )

          request = Shipwire::Products.new.update(product_id, payload)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("product_update_fail") do
          payload = product_payload.deeper_merge!(
            description: "Super awesome description"
          )

          request = Shipwire::Products.new.update(0, payload)

          expect(request.errors?).to be_truthy
          expect(request.errors).to include 'Product not found.'
        end
      end
    end

    context "retire" do
      context "with string passed" do
        it "is successful" do
          VCR.use_cassette("product_retire_id") do
            product_id = product.response.resource.items.first.resource.id

            request = Shipwire::Products.new.retire(product_id)

            expect(request.ok?).to be_truthy
          end
        end
      end

      context "with array passed" do
        it "is successful" do
          VCR.use_cassette("product_retire_id") do
            product_id = product.response.resource.items.first.resource.id

            request = Shipwire::Products.new.retire([product_id, 0])

            expect(request.ok?).to be_truthy
          end
        end
      end

      context "when product does not exist" do
        it "is successful" do
          VCR.use_cassette("product_retire_nonexistent") do
            request = Shipwire::Products.new.retire(0)

            expect(request.ok?).to be_truthy
          end
        end
      end
    end

    # NOTE: This is ugly and massive and I know it. I'm down to change it.
    def product_payload(type = "base")
      payload = {
        sku: FFaker::Product.model,
        externalId: FFaker::Product.model,
        description: FFaker::Product.product,
        classification: "baseProduct",
        category: "OTHER",
        batteryConfiguration: "NOBATTERY",
        values: {
          costValue: 1,
          retailValue: 4
        },
        dimensions: {
          length: 1,
          width: 1,
          height: 1,
          weight: 1
        },
        flags: {
          isPackagedReadyToShip: 1,
          isFragile: 0,
          isDangerous: 0,
          isPerishable: 0,
          isLiquid: 0,
          isMedia: 0,
          isAdult: 0,
          hasInnerPack: 0,
          hasMasterCase: 0,
          hasPallet: 0
        }
      }

      product_contents = [
        {
          externalId: "TEST-PRODUCT",
          quantity: 1
        },
        {
          externalId: "TEST-PRODUCT2",
          quantity: 1
        }
      ]

      case type
      when "insert"
        payload.deeper_merge!(
          classification: "marketingInsert",
          dimensions: {
            height: 0.1,
            weight: 0.1
          },
          masterCase: {
            individualItemsPerCase: 1,
            sku: FFaker::Product.model,
            description: FFaker::Product.product,
            dimensions: {
              length: 1,
              width: 1,
              height: 1,
              weight: 1
            }
          },
          inclusionRules: {
            insertWhenWorthCurrency: "USD"
          }
        )
      when "kit"
        payload.deeper_merge!(
          classification: "kit",
          kitContent: product_contents
        )

      when "virtual_kit"
        payload.deeper_merge!(
          classification: "virtualKit",
          virtualKitContent: product_contents
        )
      end

      payload
    end
  end
end
