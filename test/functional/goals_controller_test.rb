require 'test_helper'

class GoalsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  describe 'HTML Responses' do
    before do
      @goal = goals(:books_2_per_month)
      sign_in users(:one)
    end

    it "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:goals)
    end

    it "should get new" do
      get :new
      assert_response :success
    end

    it "should create goal" do
      assert_difference('Goal.count') do
        post :create, goal: { action: @goal.action,
                              quantity: @goal.quantity,
                              unit: @goal.unit,
                              frequency: @goal.frequency,
                              frequency_unit: @goal.frequency_unit,
                              start: @goal.start,
                              end: @goal.end
                            }
        assert_empty assigns(:goal).errors
      end

      assert_redirected_to goals_path
    end

    it "should show goal" do
      get :show, id: @goal
      assert_response :success
    end

    it "should get edit" do
      get :edit, id: @goal
      assert_response :success
    end

    it "should update goal" do
      put :update, id: @goal, goal: { action: @goal.action, end: @goal.end, frequency: @goal.frequency, frequency_unit: @goal.frequency_unit, quantity: @goal.quantity, start: @goal.start, unit: @goal.unit }
      assigns(:goal)
      assert_redirected_to goals_path()
      assert flash[:notice] == 'Goal was successfully updated.'
      assert flash[:alert].nil?
    end

    it "should not allow users to update others goals" do
      other_users_goal = goals(:books_2_per_day)
      put :update, id: other_users_goal
      assert flash[:alert] == "You can't update someone else's goal!."
      assigns(:goal)
      assert_redirected_to goals_path()
    end

    it "should NOT destroy other users goal" do
      other_users_goal = goals(:books_2_per_day)
      assert_no_difference('Goal.count') do
        delete :destroy, id: other_users_goal
      end
      assert_redirected_to goals_path
      assert flash[:alert] == "You can't delete someone else's goal!."
    end

    it "should destroy goal" do
      assert_difference('Goal.count', -1) do
        delete :destroy, id: @goal
      end

      assert_redirected_to goals_path
    end
  end

  describe 'HTML Authentication' do
    it "should redirect to login if not logged in" do
      get :index
      assert_redirected_to new_user_session_path
    end
  end

  describe 'JSON Responses' do

    before do
      @goal = goals(:books_2_per_month)
    end

    it "should get index" do
      @request.env["HTTP_ACCEPT"] = "application/json"
      get :index
      assert_response 401
      assert_not_nil @response.body['errors']
    end

  end
end
