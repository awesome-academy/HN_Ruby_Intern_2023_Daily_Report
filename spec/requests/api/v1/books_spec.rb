require "support/api_shared"

RSpec.describe API::V1::BooksController, :api, type: :controller do
  let(:book){create(:book)}
  let(:serialize_attributes){%w(id title description isbn available publish_date authors publisher genres cover)}

  describe "GET #index" do
    context "when letter param is present" do
      before do
        3.times { create(:book, title: "B#{Faker::Lorem.word}") }
        get :index, params: { letter: "B" }
      end

      include_examples "json collection", :book, 3
    end

    context "when letter param is not present" do
      before do
        create_list(:book_full_info, 3)
        get :index
      end

      include_examples "json collection", :book, 3
    end
  end

  describe "GET #show" do
    context "when book is found" do
      before { get :show, params: {id: book.id} }

      include_examples "json object", :book
    end

    context "when book is not found" do
      before { get :show, params: {id: -1} }

      include_examples "json message", :record_not_found, status: :not_found
    end
  end
end
