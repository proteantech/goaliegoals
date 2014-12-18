require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_ACCEPT"] = "application/json"
    @request.env["CONTENT_TYPE"] = "application/vnd.api+json"
  end

  test "valid login for existing user with token" do
    user = users(:one)
    post :create, user: {email: user.email, password: 'password'}
    assert_response :success
    assert @response.headers['Content-Type'].start_with?('application/json')
    assert_equal @response.body, {authentication_token: user.authentication_token}.to_json
  end

  test "invalid login for existing user with token" do
    user = users(:one)
    post :create, user: {email: user.email, password: 'bad'}
    assert_response 401
    assert_not_nil @response.body['errors']
    json_response = ActiveSupport::JSON.decode(@response.body)
    assert_not_nil json_response['errors']
    assert json_response['errors'][0]['title'] == CustomFailure::UNAUTHORIZED_ERROR_TITLE
  end

  test "try to login a user with no token" do
    user = users(:two)
    post :create, user: {email: user.email, password: 'password'}
    assert_response :success
    assert @response.headers['Content-Type'].start_with?('application/json')
    assert_not_nil JSON.parse(@response.body)['authentication_token']
  end

end
