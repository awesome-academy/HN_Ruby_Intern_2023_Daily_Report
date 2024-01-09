require "rails_helper"

RSpec.describe BookCommentsController, type: :controller do
  let(:account) { create(:account) }
  let(:book) { create(:book) }

  before do
    allow(controller).to receive(:authenticate_account!).and_return(true)
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new comment" do
        expect {
          post :create, params: { book_id: book.id, book_comment: { content: "Ok", star_rate: 5 } }
        }.to change(BookComment, :count).by(1)
        expect(BookComment.last.commenter).to eq(account)
        expect(flash[:notice]).to eq(I18n.t("comment_successfully"))
        expect(response).to redirect_to(book)
      end
    end

    context "with invalid attributes" do
      it "does not create a new comment with blank content" do
        expect {
          post :create, params: { book_id: book.id, book_comment: { content: '', star_rate: 5 } }
        }.not_to change(BookComment, :count)

        expect(flash.now[:alert]).to be_present
        expect(response).to redirect_to(book)
      end
    end
  end

  describe "POST #destroy" do
    context "when book is found" do
      let!(:comment) { create(:book_comment, book: book, commenter: account, content: "nice", star_rate: 4) }

      it "deletes the comment" do
        expect {
          delete :destroy, params: { book_id: book.id, id: comment.id }
        }.to change(BookComment, :count).by(-1)
      end

      it "redirects to the book" do
        delete :destroy, params: { book_id: book.id, id: comment.id }
        expect(response).to redirect_to(book)
      end

      it "sets a flash notice message" do
        delete :destroy, params: { book_id: book.id, id: comment.id }
        expect(flash[:notice]).to eq(I18n.t("comment_deleted"))
      end
    end

    context "when book is not found" do
      before { delete :destroy, params: { book_id: -1, id: -1 } }

      it_behaves_like "displays flash message", :warning, "book_not_found"

      it "redirects to books page" do
        expect(response).to redirect_to books_path
      end
    end
  end
end
