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

    t = page.has_content?('Listing Goals')
    assert t
    assert page.has_content?('Signed in successfully.')

    assert true
  end
end
