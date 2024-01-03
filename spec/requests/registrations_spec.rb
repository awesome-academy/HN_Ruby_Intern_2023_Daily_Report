require 'rails_helper'

RSpec.describe Accounts::RegistrationsController, type: :controller do
  describe '#after_sign_up_path_for' do
    let(:resource) { instance_double(Account) }

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:account]
      allow(controller).to receive(:edit_account_path).and_return('/accounts/edit')
    end

    it 'sets a flash notice and redirects to the edit account path' do
      expect(controller.send(:after_sign_up_path_for, resource)).to eq('/accounts/edit')
      expect(flash[:notice]).to eq I18n.t("account_create_success")
    end
  end
end
