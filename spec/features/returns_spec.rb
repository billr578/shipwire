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
          request = Shipwire::Returns.new.list({
            status: "canceled"
          })

          expect(request.ok?).to be_truthy
        end
      end
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

  context "cancel" do
    xit "is successful" do
    end

    xit "fails when id does not exist" do
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

  context "returns" do
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

  context "labels" do
    xit "is successful" do
    end

    xit "fails when id does not exist" do
    end
  end
end
