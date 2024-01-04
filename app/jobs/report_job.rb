class ReportJob < ApplicationJob
  queue_as :default

  def perform
    ReportMailer.week_report.deliver_later
    Account.only_admin.each do |admin|
      admin.notification_for_me :info, I18n.t("admin.notif.report_sent")
    end
  end
end
