=begin
This works:

curl http://localhost:3000/login -d user_email=mmspam31@gmail.com -d password=password
  {"authentication_token":"qeAVfrxD6wVSKYGgPug_"}
curl "http://localhost:3000/goals.json?user_email=mmspam31@gmail.com&user_token=z3vk_VGbf7cppjbMrfEM"
curl -X DELETE http://localhost:3000/logout -d user_token=qeAVfrxD6wVSKYGgPug_

=end

class LoginController < ActionController::Base

  def login
    user = User.find_by_email(params[:user_email])
    if user && user.valid_password?(params[:password])
      user.authentication_token=Devise.friendly_token
      user.save!
      sign_in('user', user)
      logger.info('login successful')
      render json: {authentication_token: user.authentication_token}, status: 200
    else
      render json: {message: 'bad username/pass'}, status: 401
    end
  end

  def logout
    user = User.find_by_authentication_token(params[:user_token])
    if user
      logger.info('Trying to nil auth_token for user.')
      User.where(id: user.id).update_all(authentication_token: nil)
      render json: {}, status: 200
    else
      logger.info('bad username/pass for logout')
      render json: {}, status: 401
    end
  end

end
