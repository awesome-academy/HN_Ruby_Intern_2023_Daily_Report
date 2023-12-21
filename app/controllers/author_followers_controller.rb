class AuthorFollowersController < ApplicationController
  before_action :authenticate_account!
  before_action :set_author

  def create
    current_account.follow @author

    flash[:success] = t "author_follow_successfully"
    redirect_to @author
  end

  def destroy
    current_account.unfollow @author if current_account.following? @author

    flash[:success] = t "author_unfollow_successfully"
    redirect_to @author
  end

  private

  def set_author
    @author = Author.find_by id: params[:id]
    return if @author

    flash[:warning] = t "author_not_found"
    redirect_to root_path
  end
end
