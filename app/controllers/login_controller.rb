=begin
This works:

curl http://localhost:3000/login -d user_email=mmspam31@gmail.com -d user_token=z3vk_VGbf7cppjbMrfE

=end

class LoginController < ActionController::Base
  #acts_as_token_authentication_handler_for User, fallback_to_devise: false
  before_filter :authenticate_user_from_token!

  def login
    if current_user
      render json: {msg: 'Login Success!'}
    else
      render json: {msg: 'Login Failed!'}
    end
  end

  def authenticate_user_from_token!
    logger.info "authenticate_user_from_token!"
    user_email = params[:user_email].presence
    user = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      logger.info "sign_in user, store: false"
      sign_in user, store: false
    else
      logger.warn "Unable to authenticate user=#{user_email} with token=#{params[:user_token]}"
    end
  end

end
