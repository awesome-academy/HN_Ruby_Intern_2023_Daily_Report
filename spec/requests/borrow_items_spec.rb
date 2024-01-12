require 'rails_helper'

RSpec.describe BorrowItemsController, type: :controller do
  let(:book_in_stock) { create(:book, amount: 50, borrowed_count: 6) }
  let(:book_out_of_stock) { create(:book, amount: 0) }
  let(:cart) { create(:cart) }
  let(:borrow_item_in_cart) { create(:borrow_item, book: book_in_stock, cart: cart) }
  let(:borrow_item_not_in_cart) { create(:borrow_item, book: book_in_stock) }

  before do
    allow(controller).to receive(:authenticate_account!).and_return(true)
    allow(controller).to receive(:check_user_info).and_return(true)
  end

  describe "POST #create" do
    context "when book is in stock" do
      before do
        session[:cart_id] = cart.id
        controller.send(:current_cart)
      end

      context "when book is in the cart" do
        before do
          cart.borrowings << borrow_item_not_in_cart
          post :create, params: { book_id: book_in_stock.id }, as: :turbo_stream
        end

        it "does not create a new borrow item" do
          expect(assigns(:borrow_item)).to eq borrow_item_not_in_cart
        end

        it_behaves_like "displays flash message", :warning, "book_borrow_one"
      end

      context "when book is not in the cart" do
        before do
          post :create, params: { book_id: book_in_stock.id }, as: :turbo_stream
        end

        it "creates a new borrow item" do
          expect(BorrowItem.count).to eq 1
        end

        it_behaves_like "displays flash message", :success, "book_added_successfully"
      end
    end

    context "when book is out of stock" do
      before { post :create, params: { book_id: book_out_of_stock.id } }

      it_behaves_like "displays flash message", :warning, "book_out_of_stock"

      it_behaves_like "redirects to", :root_path
    end
  end

  describe "DELETE #destroy" do
    context "when borrow item is found" do
      before { delete :destroy, params: { id: borrow_item_in_cart.id } }

      it_behaves_like "displays flash message", :success, "delete_success"

      it_behaves_like "redirects to", :carts_path
    end

    context "when borrow item is deleted unsuccessfully" do
      before do
        allow(BorrowItem).to receive(:find_by).and_return(borrow_item_in_cart)
        allow(borrow_item_in_cart).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: borrow_item_in_cart.id }
      end

      it_behaves_like "displays flash message", :warning, "delete_fail"

      it_behaves_like "redirects to", :carts_path
    end

    context "when borrow item is not found" do
      before { delete :destroy, params: { id: -1 } }

      it_behaves_like "displays flash message", :warning, "item_not_found"

      it_behaves_like "redirects to", :root_path
    end
  end
end
