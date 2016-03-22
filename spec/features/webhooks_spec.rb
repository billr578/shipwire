require 'spec_helper'

RSpec.describe "Webhooks", type: :feature, vcr: true do
  context "list" do
    it "is successful" do
      VCR.use_cassette("webhooks_list") do
        response = Shipwire::Webhooks.new.list

        expect(response.ok?).to be_truthy
      end
    end
  end

  context "management" do
    let(:webhook_topic)      { "order.created" }
    let(:webhook_url)        { "https://www.shipwire.com/" }
    let(:webhook_url_update) { "https://www.shipwire.com/about/" }

    let!(:webhook) do
      VCR.use_cassette("webhook") do
        Shipwire::Webhooks.new.create(
          topic: webhook_topic,
          url:   webhook_url
        )
      end
    end

    context "create" do
      it "fails with non-https callback URL" do
        VCR.use_cassette("webhooks_create_insecure") do
          response = Shipwire::Webhooks.new.create(
            topic: webhook_topic,
            url:   "http://www.reddit.com/"
          )

          expect(response.ok?).to be_falsy
          expect(response.validation_errors).to include('Invalid URL')
        end
      end
    end

    context "find" do
      it "is successful" do
        VCR.use_cassette("webhooks_find") do
          webhook_id = webhook.body["resource"]["items"].first["resource"]["id"]

          response = Shipwire::Webhooks.new.find(webhook_id)

          expect(response.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("webhooks_find_fail") do
          response = Shipwire::Webhooks.new.find(0)

          expect(response.ok?).to be_falsy
          expect(response.error_summary).to eq 'Subscription not found.'
        end
      end
    end

    context "update" do
      it "is successful" do
        VCR.use_cassette("webhooks_update") do
          webhook_id = webhook.body["resource"]["items"].first["resource"]["id"]

          payload = {
            topic: webhook_topic,
            url:   webhook_url_update
          }

          response = Shipwire::Webhooks.new.update(webhook_id, payload)

          expect(response.ok?).to be_truthy
        end
      end

      it "fails when id does not exist" do
        VCR.use_cassette("webhooks_update_fail") do
          payload = {
            topic: webhook_topic,
            url:   webhook_url_update
          }

          response = Shipwire::Webhooks.new.update(0, payload)

          expect(response.ok?).to be_falsy
          expect(response.error_summary).to eq "Invalid request"
        end
      end
    end

    context "remove" do
      it "is successful" do
        VCR.use_cassette("webhooks_remove") do
          webhook_id = webhook.body["resource"]["items"].first["resource"]["id"]

          response = Shipwire::Webhooks.new.remove(webhook_id)

          expect(response.ok?).to be_truthy
        end
      end
    end
  end
end
