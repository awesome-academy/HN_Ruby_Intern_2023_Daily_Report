require "rails_helper"

RSpec.describe BooksController, type: :controller do
  let(:book1) { create(:book, title: "Apple") }
  let(:book2) { create(:book, title: "Banana", isbn: "1123456789") }
  let(:books) { [book1, book2] }

  describe "GET #index" do
    context "when letter param is present" do
      before { get :index, params: { letter: "B" } }

      it "filters books by first letter and assigns @books" do
        expect(assigns(:books)).to match_array([book2])
      end
    end

    context "when letter param is not present" do
      before { get :index }

      it "assigns @books" do
        expect(assigns(:books)).to match_array(books)
      end
    end
  end

  describe "GET #show" do
    context "when book is found" do
      before { get :show, params: { id: book1.id } }

      it "assigns @book" do
        expect(assigns(:book)).to eq(book1)
      end
    end

    context "when book is not found" do
      before { get :show, params: { id: -1 } }

      it "sets a flash warning" do
        expect(flash[:warning]).to eq(I18n.t("book_not_found"))
      end

      it "redirects to books_path" do
        expect(response).to redirect_to(books_path)
      end
    end
  end
end
