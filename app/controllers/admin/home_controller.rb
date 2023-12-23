class Admin::HomeController < Admin::BaseController
  def index
    @period = params[:period]&.to_sym || :week
  end
end
