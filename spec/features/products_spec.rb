require 'spec_helper'

RSpec.describe "Product", type: :feature, vcr: true do
  %w(basic insert kit virtual_kit).each do |product_type|
    context "type #{product_type}" do
      let(:product_class) do
        "Shipwire::Products::#{product_type.camelize}".constantize
      end

      context "list" do
        context "without params" do
          it "is successful" do
            VCR.use_cassette("products_#{product_type}_list") do
              request = product_class.new.list

              expect(request.ok?).to be_truthy
            end
          end
        end

        context "with params" do
          it "is successful" do
            VCR.use_cassette("products_#{product_type}_list_with_params") do
              request = product_class.new.list({
                sku: "TEST-PRODUCT"
              })

              expect(request.ok?).to be_truthy
            end
          end
        end
      end

      context "management" do
        let!(:product) do
          VCR.use_cassette("product_#{product_type}") do
            product_class.new.create(payload(product_type))
          end
        end

        context "create" do
          xit "is successful" do
          end
        end

        context "find" do
          xit "is successful" do
            VCR.use_cassette("product_#{product_type}_find") do
              product_id = product.response.resource.items.first.resource.id

              request = Shipwire::Orders.new.find(product_id)

              expect(request.ok?).to be_truthy
            end
          end

          xit "fails when id does not exist" do
            VCR.use_cassette("product_#{product_type}_find_fail") do
              request = Shipwire::Orders.new.find(0)

              expect(request.errors?).to be_truthy
            end
          end
        end

        context "update" do
          xit "is successful" do
          end

          xit "fails when id does not exist" do
          end
        end

        context "retire" do
          context "with string passed" do
            xit "is successful" do
            end
          end

          context "with array passed" do
            xit "is successful" do
            end
          end

          context "with hash passed" do
            xit "is successful when valid" do
            end

            xit "is fails when invalid" do
            end
          end
        end

        # NOTE: This is ugly and massive and I know it. I'm down to change it.
        # It's been a long day and my brain hurts and I couldn't think of a way
        # to switch between variable product types within the file. Maybe it
        # would be better to split them to different files?
        def payload(type)
          product_sku         = FFaker::Product.model
          product_description = FFaker::Product.product
          product_external_id = FFaker::Product.model
          product_values      = {
            costValue:      1,
            wholesaleValue: 2,
            retailValue:    4
          }
          product_dimensions  = {
            length: 1,
            width:  1,
            height: 1,
            weight: 1
          }

          case type
          when "insert"
            {
              sku:            product_sku,
              externalId:     product_sku,
              description:    product_description,
              dimensions:     product_dimensions,
              inclusionRules: {
                insertWhenWorthCurrency: "USD"
              }
            }
          when "kit"
            {
              sku:        product_sku,
              externalId:  product_sku,
              description: product_description,
              values:      product_values,
              dimensions:  product_dimensions,
              kitContent:  [{
                externalId: product_external_id,
                quantity:   1
              }]
            }
          when "virtual_kit"
            {
              sku:               product_sku,
              description:       product_description,
              virtualKitContent: [{
                externalId: product_external_id,
                quantity:   1
              }]
            }
          else
            {
              sku:                  product_sku,
              externalId:           product_sku,
              description:          product_description,
              values:               product_values,
              dimensions:           product_dimensions,
              category:             "Foo", # Required?
              batteryConfiguration: "NONE" # Required?
            }
          end
        end
      end
    end
  end
end
