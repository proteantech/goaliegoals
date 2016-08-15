=begin
This works:

curl http://localhost:3000/login -d user_email=mmspam31@gmail.com -d user_token=z3vk_VGbf7cppjbMrfEM
curl "http://localhost:3000/goals.json?user_email=mmspam31@gmail.com&user_token=z3vk_VGbf7cppjbMrfEM"

=end

class LoginController < ApplicationController
  before_filter :authenticate_user!

  def login
    logger.info "Enter login"
    if current_user
      render json: {authentication_token: current_user.authentication_token}
    end
  end

end
