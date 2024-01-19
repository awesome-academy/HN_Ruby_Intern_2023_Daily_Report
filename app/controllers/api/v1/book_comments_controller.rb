class API::V1::BookCommentsController < API::V1::BaseController
  before_action :set_book
  before_action :set_comment, only: %i(update destroy)

  def create
    @comment = @book.comments.create comment_params
    @comment.commenter = @current_account

    user_save @comment, :comment
  end

  def update
    user_update @comment, comment_params, :comment
  end

  def destroy
    user_destroy @comment, :comment
  end

  private

  def set_book
    @book = Book.find_by id: params[:book_id]
    return if @book

    handle_not_found
  end

  def set_comment
    @comment = @book.comments.find_by id: params[:id]
    return if @comment

    handle_not_found
  end

  def comment_params
    params.require(:book_comment).permit(:content, :star_rate)
  end
end
