=begin
This works:

curl http://localhost:3000/login -d user_email=mmspam31@gmail.com -d user_token=z3vk_VGbf7cppjbMrfEM
curl "http://localhost:3000/goals.json?user_email=mmspam31@gmail.com&user_token=z3vk_VGbf7cppjbMrfEM"

=end

class LoginController < ActionController::Base
    acts_as_token_authentication_handler_for User, fallback_to_devise: false

  def login
    logger.info "Enter login"
    if current_user
      render json: {msg: 'Login Success!'}
    else
      render json: {errors: [status: 401, title: 'Login Failed!']}, status: 401
    end
  end

end
