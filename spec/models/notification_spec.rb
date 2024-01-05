require "rails_helper"

RSpec.describe Notification, type: :model do
  it { should define_enum_for(:status).with_values(%i(info notice urgent)) }
  it { should belong_to(:account).dependent(:destroy) }

  describe ".scopes" do
    let(:account) { create(:account) }
    let(:notification1) { create(:notification, account: account, created_at: 1.day.ago) }
    let(:notification2) { create(:notification, account: account, checked: false, created_at: 1.hour.ago) }

    describe ".for_me" do
      it "returns notifications for account" do
        expect(Notification.for_me(account)).to eq([notification1])
      end
    end

    describe ".unchecked" do
      it "returns unchecked notifications" do
        expect(Notification.unchecked).to eq([notification2])
      end
    end

    describe ".created_order" do
      it "returns notifications in created order" do
        expect(Notification.created_order).to eq([notification2, notification1])
      end
    end
  end
end
