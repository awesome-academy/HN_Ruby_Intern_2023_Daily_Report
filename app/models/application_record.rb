class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :sort_on, ->(col, desc){order("#{col} #{:desc if desc}")}
end
