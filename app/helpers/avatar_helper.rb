module AvatarHelper
  def gravatar_for account, size
    gravatar_id = Digest::MD5.hexdigest account.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag gravatar_url, alt: "#{account} avatar", height: size, width: size,
              class: "rounded-circle"
  end

  def avatar_for account, size = 80
    if account.avatar.attached?
      image_tag account.avatar.variant(resize: "#{size}x#{size}!"),
                alt: "#{account} avatar", class: "rounded-circle"
    else
      gravatar_for(account, size)
    end
  end
end
