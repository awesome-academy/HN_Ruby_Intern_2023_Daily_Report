# Preview all emails at http://localhost:3000/rails/mailers/report_mailer
class ReportMailerPreview < ActionMailer::Preview
  def week_report
    ReportMailer.week_report
  end
end
