class AuthorFollowersController < ApplicationController
  before_action :authenticate_account!
  before_action :set_author

  def create
    current_account.follow @author

    flash.now[:success] = t "author_follow_successfully"

    respond_to do |format|
      format.html{redirect_to @author}
      format.turbo_stream
    end
  end

  def destroy
    current_account.unfollow @author if current_account.following? @author

    flash.now[:success] = t "author_unfollow_successfully"

    respond_to do |format|
      format.html{redirect_to @author}
      format.turbo_stream
    end
  end

  private

  def set_author
    @author = Author.find_by id: params[:id]
    return if @author

    flash[:warning] = t "author_not_found"
    redirect_to root_path
  end
end
