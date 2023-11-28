class AuthorsController < ApplicationController
  def show
    @author = Author.find_by id: params[:id]
    return if @author

    flash[:warning] = t "author_not_found"
    redirect_to root_path
  end
end
