# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# Run this after save this file
# whenever --update-crontab --set "environment=development&report_day=monday&report_time=8:00am"
# crontab -l

env :PATH, ENV["PATH"] # incase `bundle command not found`
set :output, "#{path}/log/cronjob.log"

report_day = @set_variables[:report_day] || :monday
report_time = @set_variables[:report_time] || "8:00am"

every report_day, at: report_time do
  runner "ReportJob.perform_now"
end
