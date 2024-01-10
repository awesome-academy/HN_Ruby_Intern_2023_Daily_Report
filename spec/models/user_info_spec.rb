require "rails_helper"

RSpec.describe UserInfo, type: :model do
  describe ".bquery" do
    let(:account) { create(:account) }
    let(:user_info1) { create(:user_info, account: account) }
    let(:user_info2) { create(:user_info, phone: "0987654321", citizen_id: 2, account: account) }

    context "when a match is found" do
      it "returns user_infos that match the name query" do
        expect(UserInfo.bquery("Gilberto Bernhard")).to include(user_info1)
      end

      it "returns user_infos that match the phone query" do
        expect(UserInfo.bquery("0987654321")).to include(user_info2)
      end
    end

    context "when no match is found" do
      it "does not return user_infos that do not match the query" do
        expect(UserInfo.bquery("No Match")).to_not include(user_info1, user_info2)
      end
    end
  end
end
