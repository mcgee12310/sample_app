module UsersHelper
  GRAVATAR_DEFAULT_SIZE = 80

  # Returns the Gravatar for the given user.
  def gravatar_for user, options = {size: GRAVATAR_DEFAULT_SIZE}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = Settings.default.gravatar.avatar + "#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def gender_options
    User::GENDERS.map do |key, value|
      [I18n.t("users.form.genders.#{key}"), value]
    end
  end

  def can_destroy_user? user
    current_user.admin? && !current_user?(user)
  end
end
