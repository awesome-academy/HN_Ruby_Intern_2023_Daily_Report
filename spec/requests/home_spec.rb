require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET /index" do
    let(:account) { create(:account) }
    let(:genre_books) { create_list(:book, 6) }
    let(:author_books) { create_list(:book, 6) }
    let(:top_rated_books) { create_list(:book, 6) }
    let(:most_borrowed_books) { create_list(:book, 6) }

    before do
      allow(account).to receive(:books_with_same_genre).and_return(genre_books)
      allow(account).to receive(:books_from_favorite_authors).and_return(author_books)
      allow(Book).to receive_message_chain(:with_image_and_authors, :top_rated_books).and_return(top_rated_books)
      allow(Book).to receive_message_chain(:with_image_and_authors, :most_borrowed_books).and_return(most_borrowed_books)
    end

    context "when account is present" do
      before do
        allow(controller).to receive(:current_account).and_return(account)
        get :index
      end

      it "matches the genre books" do
        expect(assigns(:books)[:books_with_same_genre]).to match_array(genre_books)
      end

      it "matches the author books" do
        expect(assigns(:books)[:books_from_favorite_authors]).to match_array(author_books)
      end

      it "matches the top rated books" do
        expect(assigns(:books)[:top_rated_books]).to match_array(top_rated_books)
      end

      it "matches the most borrowed books" do
        expect(assigns(:books)[:most_borrowed_books]).to match_array(most_borrowed_books)
      end

      it "assigns the @books instance variable" do
        expect(assigns(:books)).to eq({
          books_with_same_genre: genre_books,
          books_from_favorite_authors: author_books,
          top_rated_books: top_rated_books,
          most_borrowed_books: most_borrowed_books
        })
      end
    end

    context "when account is blank" do
      before do
        allow(controller).to receive(:current_account).and_return(nil)
        get :index
      end

      it "returns without assigning @books" do
        expect(assigns(:books)).to be_nil
      end
    end
  end
end
