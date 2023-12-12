module Admin::BorrowsHelper
  def get_borrow_status_color borrow
    case borrow.status.to_sym
    when :pending
      borrow.type == :new ? :primary : :info
    when :approved then :success
    when :rejected then :danger
    when :returned then :warning
    else :secondary
    end
  end

  def populate_borrow borrow
    {
      user: borrow.account,
      full_name: borrow.account.user_info&.name,
      start: localize_date(borrow.start_at),
      due: localize_date(borrow.end_at),
      turns: borrow.turns,
      updated_at: localize_date(borrow.updated_at),
      status: t("borrows.#{borrow.status}"),
      borrow_path: admin_borrow_path(borrow),
      id: dom_id(borrow)
    }
  end

  def get_borrow_buttons borrow
    if borrow.pending?
      [
        {
          text: t("borrows.approve"),
          link: approve_admin_borrow_path(borrow),
          color: :success,
          confirm: t(".approve_confirm")
        },
        {
          text: t("borrows.reject"),
          link: reject_admin_borrow_path(borrow),
          color: :danger,
          data: {
            bs_toggle: :modal,
            bs_target: "#reject_response_modal"
          }
        }
      ]
    elsif borrow.approved?
      [
        {
          text: t("borrows.return"),
          link: return_admin_borrow_path(borrow),
          color: :primary,
          confirm: t(".return_confirm")
        },
        {
          text: t("borrows.remind"),
          link: remind_admin_borrow_path(borrow),
          color: :danger,
          confirm: t(".remind_confirm")
        }
      ]
    end
  end
end
