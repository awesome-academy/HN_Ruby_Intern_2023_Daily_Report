class Department < ApplicationRecord
  has_many :user_departments, dependent: :destroy
  has_many :users, through: :user_department
end
