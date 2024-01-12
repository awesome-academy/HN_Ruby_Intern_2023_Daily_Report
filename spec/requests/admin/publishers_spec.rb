require "support/admin_shared"

RSpec.describe Admin::PublishersController, :admin, type: :controller do
  include_examples "CRUD", :publisher
end
