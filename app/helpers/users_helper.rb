module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user
    gravatar_id = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def gender_options
    [
      [t("signup.genders.male"), "male"],
      [t("signup.genders.female"), "female"],
      [t("signup.genders.other"), "other"]
    ]
  end
end
