module AccountsHelper
  include AvatarHelper

  def account_has? attribute
    current_account&.public_send(attribute)&.present?
  end
end
