require 'test_helper'

class GoalsCapybaraTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::TextHelper

  def setup()
    cantBeBlank = "can't be blank"
    isNotNumber = 'is not a number'

    @fields = {
        action: {
            message:      cantBeBlank,
            should_pass:  false,
            content:      'action3'
        },
        quantity: {
            message:      isNotNumber,
            should_pass:  false,
            content:      '333'
        },
        unit: {
            message:      cantBeBlank,
            should_pass:  false,
            content:      'unit3'
        },
        frequency: {
            message:      isNotNumber,
            should_pass:  false,
            content:      '444'
        },
        'frequency_unit'.to_sym => {
            message:      cantBeBlank,
            should_pass:  true,
            content:      '444',
            type: :select
        },
        start: {
            message:      cantBeBlank,
            should_pass:  false,
            content:      '2000-12-07'
        },
        end: {
            message:      cantBeBlank,
            should_pass:  false,
            content:      '2000-12-08'
        }
    }
  end

  def teardown
    logout()
  end

  def logout
    click_on 'Logout'
    assert page.has_content? 'Signed out successfully.'
    assert page.has_content? 'Welcome to Goalie!'
  end

  test 'create goal' do

    login()

    submit_and_verify_goal1()
    submit_and_verify_goal2()
    submit_all_blank_and_validate()

    # Fill in fields one at a time and ensure proper validation
    @fields.keys.each do |k|
      fill_next_field_and_validate(k)
    end

    deleteGoal(3)

  end

  def deleteGoal(numGoals)
    (0...numGoals).each do
      within(:xpath, "(//tr[.//a[contains(@class, 'goal-edit-link')]])[1]") do
        click_link 'goal-delete-link-id'
        a = page.driver.browser.switch_to.alert
        assert a.text == 'Goal was successfully deleted.'
        a.accept  # can also be a.dismiss
      end
      assert page.has_content? 'Goal was successfully deleted.'
    end
  end

  def view_row_xpath(fields)
    "(//tr[.//a[contains(@class, 'goal-edit-link')] and td[contains(@class, 'action-cell') and .='#{fields[:action][:content]}']])"
  end

  def edit_row_xpath(fields)
    "(//tr[.//a[contains(@class, 'goal-submit-link')] and descendant::input[contains(@class, 'action-field') and @value='#{fields[:action][:content]}']])"
  end

  test 'edit goal' do

    login()

    fields1 = submit_and_verify_goal1()
    fields2 = submit_and_verify_goal2()

    submit_all_blank_and_validate()

    # Assert hidden row has expected value
    within(:xpath, "(//tr[.//a[contains(@class, 'goal-submit-link')]])[1]", visible: false) do
      assert !find(:xpath, ".//a[contains(@class, 'goal-submit-link')]", visible: false).visible?
      assert find(:xpath, ".//input[@name='goal[action]' and @value='action2']", visible: false)
    end
    assert page.has_no_css?('.goal-submit-link')

    # Open Goal for Editing
    within(:xpath, view_row_xpath(fields2)) do
      find(:xpath, ".//td[text()='action2']")
      find(:xpath, ".//a[contains(@class, 'goal-edit-link')]").click
    end
    assert find('.goal-submit-link')

    # Save and verify validation error for missing action field
    within(:xpath, edit_row_xpath(fields2)) do
      assert find(:xpath, ".//input[@name='goal[action]' and @value='action2']")
      fill_in('goal[action]', with: '')
      find('.goal-submit-link').click
    end
    assert page.has_content? "1 error prohibited this goal from being saved:"

    # Fill Goal in edit and Save
    goal_in_edit = all(:xpath, "(//tr[.//input[@name='goal[action]']])")[1]
    within goal_in_edit do
      fill_in('goal[action]', with: 'edit_goal_text')
      find('.goal-submit-link').click
    end

    # Verify Successful Modification
    assert page.has_content? 'Goal was successfully updated.'
    assert page.has_content? 'edit_goal_text'

    # Open Goal for Editing
    within(:xpath, "(//tr[.//a[contains(@class, 'goal-edit-link')]])[1]") do
      find(:xpath, ".//td[text()='edit_goal_text']")
      find(:xpath, ".//a[contains(@class, 'goal-edit-link')]").click
    end
    assert find('.goal-submit-link')

    # Save and verify validation error for bad number
    within(:xpath, "(//tr[.//input[@name='goal[action]']])[2]") do
      assert find(:xpath, ".//input[@name='goal[action]' and @value='edit_goal_text']")
      fill_in('goal[frequency]', with: 'abc')
      find('.goal-submit-link').click
    end
    assert page.has_content? "1 error prohibited this goal from being saved:"
    assert page.has_content? "Frequency is not a number"

    # Fill Goal in edit and Save
    goal_in_edit = all(:xpath, "(//tr[.//input[@name='goal[action]']])")[1]
    within goal_in_edit do
      fill_in('goal[frequency]', with: '33')
      find('.goal-submit-link').click
    end

    # Verify Successful Modification
    assert page.has_content? 'Goal was successfully updated.'
    assert page.has_content? '33'

  end

  def login
    visit '/'
    click_on 'Login'

    assert page.has_content? 'Sign in'
    user = users(:one)
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'password'
    click_on 'Sign in'

    assert page.has_content?('Goals')
    assert page.has_content?('Signed in successfully.')
  end

  def login_staging
    visit 'http://goalie-staging.herokuapp.com/'
    click_on 'Login'

    assert page.has_content? 'Sign in'
    fill_in 'user_email', with: 'mmspam31@gmail.com'
    fill_in 'user_password', with: 'password'
    click_on 'Sign in'

    assert page.has_content?('Goals')
    assert page.has_content?('Signed in successfully.')
  end

  def submit_and_verify_goal1
    fields = Marshal.load( Marshal.dump(@fields) )
    fields[:action][:content] = 'action1'
    fields[:quantity][:content] = '1'
    fields[:unit][:content] = 'unit1'
    fields[:frequency][:content] = '1'
    fields[:'frequency_unit'][:content] = 'day'
    fields[:start][:content] = '2000-12-03'
    fields[:end][:content] = '2000-12-04'
    fields.keys.each {|field| fields[field][:should_pass] = true}
    fill_fields(fields)

    click_on 'Add'

    validate_fields(fields)

    return fields
  end

  def fill_fields(fields)
    fields.keys.each do |field|
      if fields[field][:type] == :select
        select fields[field][:content], from: "#{field}-select"
      else
        fill_in "goal_#{field}", with: fields[field][:content]
      end
    end
  end

  def submit_and_verify_goal2
    fields = Marshal.load( Marshal.dump(@fields) )
    fields[:action][:content] = 'action2'
    fields[:quantity][:content] = '2'
    fields[:unit][:content] = 'unit2'
    fields[:frequency][:content] = '2'
    fields[:'frequency_unit'][:content] = 'week'
    fields[:start][:content] = '2000-12-05'
    fields[:end][:content] = '2000-12-06'
    fields.keys.each {|field| fields[field][:should_pass] = true}
    fill_fields(fields)

    click_on 'Add'

    validate_fields(fields)

    return fields
  end

  # Check validation with no fields filled in
  def submit_all_blank_and_validate
    blank_dates
    click_on 'Add'
    validate_fields(@fields)
  end

  # k = key of the field to fill next
  def fill_next_field_and_validate(k)
    fill_next_field_and_adjust_fields_map(k)
    click_on 'Add'
    validate_fields(@fields)
  end

  def fill_next_field_and_adjust_fields_map(k)
    @fields[k][:should_pass] = true
    fill_in "goal_#{k}", with: @fields[k][:content]
    blank_dates_unless_should_pass
  end

  def blank_dates_unless_should_pass
    unless @fields[:start][:should_pass]
      fill_in 'goal_start', with: ''
    end

    unless @fields[:end][:should_pass]
      fill_in 'goal_end', with: ''
    end
  end

  def blank_dates
    fill_in 'goal_start', with: ''
    fill_in 'goal_end', with: ''
  end

  def validate_fields(fields)

    passes = fields.values.collect { |mini_hash| mini_hash[:should_pass] }
    error_count = passes.inject(0) {|err_count, should_pass| should_pass ? err_count : err_count  + 1}

    if error_count > 0
      assert page.has_content? "#{pluralize(error_count, 'error')} prohibited this goal from being saved:"
      validate_fields_on_error(fields)
    else
      assert page.has_content? 'Goal was successfully created.'
      validate_fields_on_success(fields)
    end

  end

  def validate_fields_on_success(fields)
    fields.keys.each do |k|
      assert page.has_content?(fields[k][:content])
    end
  end

  def validate_fields_on_error(fields)
    fields.keys.each do |k|
      unless fields[k][:type] == :select
        if fields[k][:should_pass]
          p "key=#{k}, content=#{fields[k][:content]}"
          assert page.has_no_content?("#{k.capitalize} #{fields[k][:message]}")
          assert page.has_field?("goal_#{k}", with: fields[k][:content])
        else
          assert page.has_content?("#{k.capitalize} #{fields[k][:message]}")
          assert page.has_no_field?("goal_#{k}", with: fields[k][:content])
        end
      end
    end
  end

end
