class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :sort_on, ->(col, desc){order Arel.sql("#{col} #{:desc if desc}")}
  scope :newest, ->{order(updated_at: :desc)}

  scope :recently, lambda{|period = :month, attribute = :created_at|
    return all if period == :all

    where attribute => Time.zone.today.public_send("all_#{period}")
  }
  scope :period_group, lambda{|period = :date, attribute = :created_at|
    group("#{period}(#{attribute})")
  }

  protected
  def downcase_email
    email.downcase!
  end
end
