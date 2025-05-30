module UsersHelper
  def gravatar_for(user)
    # gravatarの写真を表示するためのヘルパーメソッド
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://www.gravatar.com/avatar/#{gravatar_id}?s=80&d=identicon"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end
