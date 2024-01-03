require "rails_helper"

RSpec.describe AuthorFollowersController, type: :controller do
  let(:account) { create(:account) }
  let(:author) { create(:author) }

  before(:each) do
    allow(controller).to receive(:authenticate_account!).and_return(true)
    allow(controller).to receive(:current_account).and_return(account)
  end

  shared_examples "displays flash message" do |flash_type, message|
    it "displays flash #{flash_type}" do
      expect(flash.now[flash_type]).to eq I18n.t(message)
    end
  end

  describe "POST #create" do
    context "when author id valid" do
      before { post :create, params: {id: author.id} }

      it "follows the author" do
        expect(account.following?(author)).to be_truthy
      end

      it_behaves_like "displays flash message", :success, "author_follow_successfully"

      it "redirects to the author page" do
        expect(response).to redirect_to author_path(author)
      end
    end

    context "when author not found" do
      before { post :create, params: {id: -1} }

      it_behaves_like "displays flash message", :warning, "author_not_found"

      it "redirect to root page" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE #destroy" do
    before { delete :destroy, params: {id: author.id} }

    it "unfollows the author" do
      expect(account.following?(author)).to be_falsey
    end

    it_behaves_like "displays flash message", :success, "author_unfollow_successfully"

    it "redirects to the author page" do
      expect(response).to redirect_to author_path(author)
    end
  end
end
