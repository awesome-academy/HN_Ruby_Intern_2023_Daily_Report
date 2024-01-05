require "support/admin_shared"

RSpec.describe Admin::AuthorsController, :admin, type: :controller do
  include_examples "CRUD", :author
end
