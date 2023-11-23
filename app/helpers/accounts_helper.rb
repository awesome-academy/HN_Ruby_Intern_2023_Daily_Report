module AccountsHelper
  def gravatar_for account
    gravatar_id = Digest::MD5.hexdigest account.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag gravatar_url, alt: account.username, class: "gravatar"
  end
end
