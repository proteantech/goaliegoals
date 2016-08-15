require 'test_helper'

class LoginControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["HTTP_ACCEPT"] = "application/json"
    @request.env["CONTENT_TYPE"] = "application/vnd.api+json"
  end

  test "valid login for existing user with token" do
    user = users(:one)
    post :login, user_email: user.email,  user_token: user.authentication_token
    assert_response :success
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_equal json_response['authentication_token'], user.authentication_token
  end

  test "invalid login for existing user with token" do
    user = users(:one)
    post :login, user_email: 'mmspam31@gmail.com',  user_token: 'bad_token'
    assert_response 401
    assert_not_nil @response.body['errors']
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_not_nil json_response['errors']
    assert json_response['errors'][0]['title'] == CustomFailure::UNAUTHORIZED_ERROR_TITLE
    assert_nil json_response['authentication_token']
  end

  test "invalid username" do
    post :login, user_email: 'invalid@gmail.com',  user_token: 'bad_token'
    assert_response 401
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_nil json_response['authentication_token']
  end

  test "user with no token" do
    user = users(:two)
    post :login, user_email: user.email,  user_token: 'bad_token'
    assert_response 401
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_nil json_response['authentication_token']
  end

end
