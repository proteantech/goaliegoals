require 'test_helper'

class GoalsCapybaraTest < ActionDispatch::IntegrationTest

  test 'create goal' do
    visit '/'
    click_on 'Login'

    assert page.has_content? 'Sign in'
    user = users(:one)
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_on 'Sign in'

    assert page.has_content?('Listing Goals')
    assert page.has_content?('Signed in successfully.')

    fill_in 'goal_action', with: 'action1'
    fill_in 'goal_quantity', with: '1'
    fill_in 'goal_unit', with: 'unit1'
    fill_in 'goal_frequency', with: '1'
    select 'day', from: 'frequency-unit-select'
    fill_in 'goal_start', with: '2013-10-06'
    fill_in 'goal_end', with: '2013-10-07'
    click_on 'Add'

    assert page.has_content? 'Goal was successfully created.'
    assert page.has_content? '2013-10-06'
    assert page.has_content? '2013-10-07'

  end
end
