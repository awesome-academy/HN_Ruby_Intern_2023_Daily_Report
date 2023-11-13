class User < ApplicationRecord
  # association marco
  belongs_to :role

  has_many :reports, dependent: :destroy
  has_many :user_departments, dependent: :destroy
  has_many :departments, through: :user_department

  # validation macro
  validates :name, presence: true, length: {maximum: Settings.digit_50}
  validates :email, presence: true,
            length: {maximum: Settings.digit_255},
            format: Settings.valid_email_regex, uniqueness: true
  validates :gender, presence: true
  validates :dob, presence: true
  validates :phone_number, presence: true

  # callback macro
  before_save :downcase_email

  has_secure_password

  private
  def downcase_email
    email.downcase!
  end
end
