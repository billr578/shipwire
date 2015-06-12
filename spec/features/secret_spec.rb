require 'spec_helper'

RSpec.describe "Secret", type: :feature, vcr: true do
  context "list" do
    it "is successful" do
      VCR.use_cassette("secret_list") do
        request = Shipwire::Secret.new.list

        expect(request.ok?).to be_truthy
      end
    end
  end

  context "management" do
    let!(:secret) do
      VCR.use_cassette("secret") do
        Shipwire::Secret.new.create
      end
    end

    context "find" do
      it "is successful" do
        VCR.use_cassette("secret_find") do
          secret_id = secret.response.resource.id

          request = Shipwire::Secret.new.find(secret_id)

          expect(request.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("secret_find_fail") do
          # For some reason ID 0 returns data for ID 126. I asked Shipwire about
          # this. They didn't respond. Use 1 instead.
          request = Shipwire::Secret.new.find(1)

          expect(request.errors?).to be_truthy
          expect(request.errors).to include 'Not found'
        end
      end
    end

    context "remove" do
      it "is successful" do
        VCR.use_cassette("secret_remove") do
          secret_id = secret.response.resource.id

          request = Shipwire::Secret.new.remove(secret_id)

          expect(request.ok?).to be_truthy
        end
      end
    end
  end
end
