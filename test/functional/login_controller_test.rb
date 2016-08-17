require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["HTTP_ACCEPT"] = "application/json"
    @request.env["CONTENT_TYPE"] = "application/vnd.api+json"
  end

  test "valid login for existing user with token" do
    user = users(:one)
    post :login, user_email: user.email,  password: 'password'
    assert_response :success
    json_response = ActiveSupport::JSON.decode(@response.body)
    user.reload
    assert_equal json_response['authentication_token'], user.authentication_token
  end

  test "invalid login for existing user with token" do
    user = users(:one)
    post :login, user_email: 'mmspam31@gmail.com',  password: 'bad_token'
    assert_response 401
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_nil json_response['authentication_token']
  end

  test "invalid username" do
    post :login, user_email: 'invalid@gmail.com',  password: 'bad_token'
    assert_response 401
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_nil json_response['authentication_token']
  end

  test "user with no token, bad password" do
    user = users(:two)
    post :login, user_email: user.email,  password: 'bad_token'
    assert_response 401
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_nil json_response['authentication_token']
  end

  test "user with no token, good password" do
    user = users(:two)
    post :login, user_email: user.email,  password: 'password'
    assert_response 200
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_not_nil json_response['authentication_token']
  end

  describe 'logout' do
    it 'deletes the token when credentials are correct' do
      user = users(:one)
      token = user.authentication_token
      delete :logout, user_email: user.email,  user_token: user.authentication_token
      assert_response :success
      user = User.find(user.id).reload
      assert_not_equal user.authentication_token, token
      assert_nil user.authentication_token
    end
  end

end
