module BorrowInfosHelper
  def set_class_based_on status
    case status
    when "pending"
      "info"
    when "approved"
      "success"
    when "rejected"
      "danger"
    when "returned"
      "warning"
    else
      "primary"
    end
  end

  def show_actions status
    case status
    when "pending"
      cancel_btn
    when "approved"
      renewals_form
    when "rejected"
      rejected_content
    when "returned"
      returned_content
    else
      ""
    end
  end

  def cancel_btn
    link_to t("cancel_borrow_request"),
            status_action_path(
              id: @borrow_info.id,
              status: @borrow_info.status
            ),
            data: {turbo_method: :post, turbo_confirm: t("you_sure?")},
            class: "btn btn-outline-danger"
  end

  def renewals_form
    form_with(model: @borrow_info,
              url: status_action_path(id: @borrow_info.id,
                                      status: @borrow_info.status),
              data: {turbo_method: :patch, turbo_confirm: t("you_sure?")},
              class: "d-flex align-items-center my-4") do |form|
      concat(form.label(
               :renewal_at, t("borrow_renewals_date"), class: "fw-semibold"
             ))
      concat(content_tag(:span, "(#{t('if_want')}):",
                         class: "ms-1 text-secondary"))
      concat(form.date_field(:renewal_at, class: "form-control w-auto mx-3",
                             min: Date.current))
      concat(form.submit(t("renewals"), class: "btn btn-primary"))
    end
  end

  def rejected_content
    content_tag(:div, class: "alert alert-danger") do
      concat(content_tag(:span,
                         "#{t('reject_reason')}: ",
                         class: "fw-semibold"))
      concat(content_tag(:span,
                         @borrow_info.response.content,
                         class: "text-break"))
    end
  end

  def returned_content
    content_tag(:div, class: "alert alert-warning") do
      concat(content_tag(:span, "#{t('actual_return_date')}: ",
                         class: "fw-semibold"))
      concat(content_tag(:span, @borrow_info.updated_at.to_date))
    end
  end
end
