require "rails_helper"

RSpec.describe Publisher, type: :model do
  describe ".bquery" do
    let(:publisher1) { create(:publisher) }
    let(:publisher2) { create(:publisher, name: "Jane", email: "jane@example.com", address: "456 Street", about: "About Jane") }

    context "when a match is found" do
      it "returns publishers that match the name query" do
        expect(Publisher.bquery("John")).to include(publisher1)
      end

      it "returns publishers that match the email query" do
        expect(Publisher.bquery("john@example.com")).to include(publisher1)
      end

      it "returns publishers that match the address query" do
        expect(Publisher.bquery("456 Street")).to include(publisher2)
      end

      it "returns publishers that match the about query" do
        expect(Publisher.bquery("About Jane")).to include(publisher2)
      end
    end

    context "when no match is found" do
      it "does not return publishers that do not match the query" do
        expect(Publisher.bquery("No Match")).to_not include(publisher1, publisher2)
      end
    end
  end

  describe ".ransackable_attributes" do
    it "returns the correct ransackable attributes" do
      expect(Publisher.ransackable_attributes).to eq(["name"])
    end
  end
end
