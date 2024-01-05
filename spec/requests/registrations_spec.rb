require 'rails_helper'

RSpec.describe Accounts::RegistrationsController, type: :controller do
  describe '#after_sign_up_path_for' do
    let(:account) { create(:account) }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:account]
      sign_in account
    end

    it 'sets a flash notice' do
      controller.send(:after_sign_up_path_for, account)
      expect(flash[:notice]).to eq(I18n.t("account_create_success"))
    end

    it 'redirects to the edit account path' do
      expect(controller.send(:after_sign_up_path_for, account)).to eq(edit_account_path(account))
    end
  end
end
