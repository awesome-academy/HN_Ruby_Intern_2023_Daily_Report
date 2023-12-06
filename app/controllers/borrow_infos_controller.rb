class BorrowInfosController < ApplicationController
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
