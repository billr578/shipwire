require 'spec_helper'

RSpec.describe "Secret", type: :feature, vcr: true do
  context "list" do
    it "is successful" do
      VCR.use_cassette("secret_list") do
        response = Shipwire::Secret.new.list

        expect(response.ok?).to be_truthy
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
          secret_id = secret.body["resource"]["id"]

          response = Shipwire::Secret.new.find(secret_id)

          expect(response.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("secret_find_fail") do
          # ID 0 returns data for an existing secret at index 0 instead of a
          # not found. Shipwire considers this an unintended feature or shortcut
          # rather than a bug. So use 1 instead of 0.
          response = Shipwire::Secret.new.find(1)

          expect(response.ok?).to be_falsy
          expect(response.error_summary).to eq 'Not found'
        end
      end
    end

    context "remove" do
      it "is successful" do
        VCR.use_cassette("secret_remove") do
          secret_id = secret.body["resource"]["id"]

          response = Shipwire::Secret.new.remove(secret_id)

          expect(response.ok?).to be_truthy
        end
      end
    end
  end
end
