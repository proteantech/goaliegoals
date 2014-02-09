require 'test_helper'

class LogsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    sign_in users(:one)
    @log = logs(:one)
    @goal = goals(:books_2_per_month)
    @goal.logs = [@log]
  end

  test "should get index" do
    get :index, goal_id: @goal
    assert_response :success
    assert_not_nil assigns(:logs)
  end

  test "should get new" do
    get :new, goal_id: @goal
    assert_response :success
  end

  test "should create log" do
    @request.env["HTTP_REFERER"] = "/goals/#{@goal.id}/logs"
    assert_difference('Log.count') do
      post(:create,
           goal_id: @goal.id,
           log: { description: @log.description, log_date: @log.log_date,
                  quantity: @log.quantity })
    end

    assigns(:log)
    assigns(:logs)
    assigns(:goal)
    assert_redirected_to goal_logs_url(@goal)
  end

  test "should show log" do
    get :show, goal_id: @goal, id: @log
    assert_response :success
  end

  test "should get edit" do
    sign_in User.first # devise
    get :edit,  goal_id: @goal, id: @log
    assert_response :success
  end

  test "should update log" do
    put :update, goal_id: @goal, id: @log, log: { description: @log.description, log_date: @log.log_date, quantity: @log.quantity}
    assigns(:logs)
    assigns(:log)
    assert_redirected_to goal_logs_url(@goal)
  end

  test "should destroy log" do
    assert_difference('Log.count', -1) do
      delete :destroy,  goal_id: @goal, id: @log
    end

    assert_redirected_to goal_logs_url(@goal)
  end
end
