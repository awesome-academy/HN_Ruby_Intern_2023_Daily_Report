module ApplicationHelper
  include Pagy::Frontend

  def full_title page_title = ""
    base_title = "Libma"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def borrow_item_quantity
    @current_cart.borrowings.sum(&:quantity) if account_signed_in?
  end

  def type_for_toastr message_type
    case message_type
    when "alert" then "error"
    when "notice" then "success"
    else message_type
    end
  end
end
