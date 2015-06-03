require 'spec_helper'
require 'date'

RSpec.describe "Receivings", type: :feature, vcr: true do
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
          request = Shipwire::Receivings.new.list({
            status: "canceled"
          })

          expect(request.ok?).to be_truthy
        end
      end
    end
  end

  context "management" do
    let!(:receiving) do
      VCR.use_cassette("receiving") do
        Shipwire::Receivings.new.create({
          externalId:   FFaker::Product.model,
          expectedDate: DateTime.now.to_s,
          arrangement:  {
            type: "none"
          },
          items:        [{
            sku:      FFaker::Product.model,
            quantity: 5
          }],
          trackings:    [{
            tracking: "UPS1234567890",
            carrier:  "UPS",
            contact:  FFaker::Name.name ,
            phone:    FFaker::PhoneNumber.short_phone_number
          }],
          shipments:    [{
            length: 1,
            width:  1,
            height: 1,
            weight: 1,
            type:   "box"
          }],
          options:      {
            warehouseRegion: "LAX"
          },
          shipFrom:     {
            email:      FFaker::Internet.email,
            name:       FFaker::Name.name,
            address1: "540 West Boylston St.",
            city: "Worcester",
            state: "MA",
            postalCode: "01606",
            country: "US",
            phone:      FFaker::PhoneNumber.short_phone_number
          }
        })
      end
    end

    context "create" do
      xit "is successful" do
      end
    end

    context "find" do
      context "without params" do
        xit "is successful" do
        end
      end

      context "using params" do
        xit "is successful" do
        end
      end

      xit "fails when id does not exist" do
      end
    end

    context "update" do
      context "without params" do
        xit "is successful" do
        end
      end

      context "using params" do
        xit "is successful" do
        end
      end

      xit "fails when id does not exist" do
      end
    end

    context "cancel" do
      xit "is successful" do
      end

      xit "fails when id does not exist" do
      end
    end

    context "labels_cancel" do
      xit "is successful" do
      end

      xit "fails when id does not exist" do
      end

      context "using alias method" do
        xit "is successful" do
        end

        xit "fails when id does not exist" do
        end
      end
    end

    context "holds" do
      context "without params" do
        xit "is successful" do
        end
      end

      context "using params" do
        xit "is successful" do
        end
      end

      xit "fails when id does not exist" do
      end
    end

    context "instructions_recipients" do
      xit "is successful" do
      end

      xit "fails when id does not exist" do
      end

      context "using first alias method" do
        xit "is successful" do
        end

        xit "fails when id does not exist" do
        end
      end

      context "using second alias method" do
        xit "is successful" do
        end

        xit "fails when id does not exist" do
        end
      end
    end

    context "items" do
      xit "is successful" do
      end

      xit "fails when id does not exist" do
      end
    end

    context "shipments" do
      xit "is successful" do
      end

      xit "fails when id does not exist" do
      end
    end

    context "trackings" do
      xit "is successful" do
      end

      xit "fails when id does not exist" do
      end
    end
  end
end
