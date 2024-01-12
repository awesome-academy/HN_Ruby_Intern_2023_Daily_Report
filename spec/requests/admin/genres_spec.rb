require "support/admin_shared"

RSpec.describe Admin::GenresController, :admin, type: :controller do
  include_examples "CRUD", :genre
end
