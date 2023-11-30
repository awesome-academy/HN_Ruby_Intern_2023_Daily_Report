class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :sort_on, ->(col, desc){order("#{col} #{:desc if desc}")}
  scope :newest, ->{order(updated_at: :desc)}

  protected
  def downcase_email
    email.downcase!
  end
end
