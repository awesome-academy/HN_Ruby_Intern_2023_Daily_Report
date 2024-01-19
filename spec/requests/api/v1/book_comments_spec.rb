require "support/api_shared"

RSpec.describe API::V1::BookCommentsController, :api, type: :controller do
  let(:account) { create(:account) }
  let(:book) { create(:book) }
  let(:comment) { create(:book_comment, content: "Ok", star_rate: 4, commenter: account, book: book) }
  let(:serialize_attributes){%w(id star_rate content)}

  describe "POST #create" do
    context "when book is found" do
      before do
        post :create, params: { book_id: book.id, book_comment: { content: "Ok", star_rate: 5 } }
      end

      include_examples "json object", :book_comment
    end

    context "when book is not found" do
      before { post :create, params: {book_id: -1} }

      include_examples "json message", :record_not_found, status: :not_found
    end
  end

  describe "PATCH #update" do
    context "when params are valid" do
      before { patch :update, params: { book_id: book.id, id: comment.id, book_comment: { content: "da update", star_rate: "1" } } }

      include_examples "json object", :comment
    end

    context "when params are not valid" do
      before { patch :update, params: { book_id: book.id, id: comment.id, book_comment: { content: "", star_rate: "" } } }

      include_examples "json errors", :comment, :update
    end
  end

  describe "DELETE #destroy" do
    context "when comment is found" do
      before { delete :destroy, params: { book_id: book.id, id: comment.id } }

      include_examples "json object", :comment
    end

    context "when comment is not found" do
      before { delete :destroy, params: { book_id: book.id, id: -1 } }

      include_examples "json message", :record_not_found, status: :not_found
    end
  end
end
