class HomeController < ApplicationController
  def index
    return if current_account.blank? || current_account.favorite_authors.blank?

    @authors = current_account&.favorite_authors
    @pagy, @authors = pagy(
      @authors.with_attached_avatar,
      items: Settings.digit_4
    )
  end
end
