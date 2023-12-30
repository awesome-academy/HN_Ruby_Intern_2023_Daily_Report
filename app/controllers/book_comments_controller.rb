class BookCommentsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_book

  def create
    @comment = @book.comments.create comment_params
    @comment.commenter = current_account

    if @comment.save
      flash.now[:notice] = t "comment_successfully"
    else
      handle_comment_error
    end

    respond_to do |format|
      format.html{redirect_to @book}
      format.turbo_stream
    end
  end

  def destroy
    @comment = @book.comments.find_by id: params[:id]
    @comment.destroy

    flash.now[:notice] = t "comment_deleted"
    respond_to do |format|
      format.html{redirect_to @book}
      format.turbo_stream
    end
  end

  private

  def set_book
    @book = Book.find_by id: params[:book_id]
    return if @book

    flash.now[:warning] = t "book_not_found"
    redirect_to books_path
  end

  def comment_params
    params.require(:book_comment).permit(:content, :star_rate)
  end

  def handle_comment_error
    flash.now[:alert] = if @comment.errors.present?
                          @comment.errors.full_messages.join(", ")
                        else
                          t("comment_failed")
                        end
  end
end
