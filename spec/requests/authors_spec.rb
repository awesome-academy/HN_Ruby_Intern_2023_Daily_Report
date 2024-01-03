require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do
  describe "GET /show" do
    context "when author id valid" do
      it "render show" do
        author = create :author

        get :show, params: { id: author.id}
        expect(response).to render_template(:show)
      end
    end

    context "when author not found" do
      before { get :show, params: {id: -1} }
        it "display flash warning " do
          expect(flash[:warning]).to eq I18n.t('author_not_found')
        end

        it "redirect root page" do
          expect(response).to redirect_to root_path
        end
      end
    end
end
