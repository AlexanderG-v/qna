class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    connect('Github')
  end

  def vkontakte
    connect('Vkontakte')
  end

  private

  def connect(provider)
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif @user.nil? && !auth.nil?
      session["devise.#{provider}_data"] = auth.except('extra')
      redirect_to new_user_registration_path, alert: 'Something went wrong.'
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
