class BorrowInfosController < ApplicationController
  include CartActions

  before_action :require_login, only: %i(new)
  before_action :set_cart, only: %i(new)
  before_action :check_cart_empty, only: %i(new)

  def index
    @borrow_infos = BorrowInfo.all
  end

  def show
    @borrow_info = BorrowInfo.find_by(id: params[:id])
  end

  def new
    @borrow_info = BorrowInfo.new
  end
end
