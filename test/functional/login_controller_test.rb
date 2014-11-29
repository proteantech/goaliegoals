require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
  end

  test "valid login for existing user with token" do
    user = users(:one)
    post :login, user_email: user.email,  user_token: user.authentication_token
    assert_response :success
    p @response.body
  end

  test "invalid login for existing user with token" do
    user = users(:one)
    post :login, user_email: 'mmspam31@gmail.com',  user_token: 'bad_token'
    assert_response 401
  end

  test "invalid username" do
    post :login, user_email: 'invalid@gmail.com',  user_token: 'bad_token'
    assert_response 401
  end

  test "user with no token" do
    user = users(:two)
    post :login, user_email: user.email,  user_token: 'bad_token'
    assert_response 401
  end

end
