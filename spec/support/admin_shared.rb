require "rails_helper"
require "support/mailer_matcher"
require "support/model_matcher"

RSpec.shared_context "shared admin controller" do
  let(:admin){create(:admin)}

  before do
    allow(controller).to receive(:authenticate_admin_account!).and_return(true)
    allow(controller).to receive(:current_admin_account).and_return(admin)
  end
end


RSpec.shared_examples "invalid item" do |name, model_name = nil|
  model_name = name unless model_name
  it "set flash message to error" do
    should set_flash[:error].to I18n.t("admin.notif.item_not_found", name: I18n.t("#{model_name}s._name"))
  end
  it "redirects to #{name}s list path" do
    should redirect_to public_send("admin_#{name}s_path")
  end
end

RSpec.shared_examples "set flash" do |type, key, now: false, **key_options|
  if now
    it "set flash now message to #{type}" do
      should set_flash.now[type].to I18n.t("admin.notif.#{key}", **key_options)
    end
  else
    it "set flash message to #{type}" do
      should set_flash[type].to I18n.t("admin.notif.#{key}", **key_options)
    end
  end
end

RSpec.shared_examples "check errors" do |assign_key, name, *keys|
  it "set errors on #{name}" do
    expect(assigns(assign_key).errors.messages.keys).to include(*keys)
  end
end

RSpec.configure do |config|
  config.include_context "shared admin controller", :admin, type: :controller
end
