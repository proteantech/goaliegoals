require 'test_helper'

class GoalsCapybaraTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::TextHelper

  def setup()
    @cantBeBlank = "can't be blank"
    @isNotNumber = 'is not a number'

    @fields = {
        action: {
            message:      @cantBeBlank,
            should_pass:  false,
            content:      'action3'
        },
        quantity: {
            message:      @isNotNumber,
            should_pass:  false,
            content:      '333'
        },
        unit: {
            message:      @cantBeBlank,
            should_pass:  false,
            content:      'unit3'
        },
        frequency: {
            message:      @isNotNumber,
            should_pass:  false,
            content:      '444'
        },
        'frequency_unit'.to_sym => {
            message:      @cantBeBlank,
            should_pass:  true,
            content:      '444',
            type: :select
        },
        start: {
            message:      @cantBeBlank,
            should_pass:  false,
            content:      '2000-12-07'
        },
        end: {
            message:      @cantBeBlank,
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

  test 'details' do
    visit '/details'
    assert page.has_content? 'Details of Goalie Goals'
    login()
    visit '/details'
    assert page.has_content? 'Details of Goalie Goals'
  end

  test 'create goal' do

    login()

    fields1 = submit_and_verify_goal1()
    fields2 = submit_and_verify_goal2()
    submit_all_blank_and_validate()

    # Fill in fields one at a time and ensure proper validation
    @fields.keys.each do |k|
      fill_next_field_and_validate(k)
    end

    assert page.has_content? 'Goal was successfully created.'

    deleteGoals([fields1, fields2, @fields])

  end

  test 'edit goal' do

    login()

    fields1 = submit_and_verify_goal1()
    fields2 = submit_and_verify_goal2()

    submit_all_blank_and_validate()

    # Assert hidden row has expected value
    within(:xpath, edit_row_xpath(fields2), visible: false) do
      assert !find(:xpath, ".//a[contains(@class, 'goal-submit-link')]", visible: false).visible?
      assert find(:xpath, ".//input[@name='goal[action]' and @value='action2']", visible: false)
    end
    assert page.has_no_css?('.goal-submit-link')

    # Open Goal for Editing
    edit_goal(fields2)

    # Save and verify validation error for missing action field
    fields2[:unit][:content] = ''
    fields2[:unit][:should_pass] = false
    fill_submit_and_validate(fields2)

    # Fill Goal in edit with valid values, Save, Validate
    fields2[:unit][:content] = 'edited_goal_unit'
    fields2[:unit][:should_pass] = true
    fill_submit_and_validate(fields2)

    # Open Goal for Editing
    edit_goal(fields2)

    # Save and verify validation error for bad number
    fields2[:frequency][:content] = 'bad frequency'
    fields2[:frequency][:should_pass] = false
    fill_submit_and_validate(fields2)

    # Fill Goal in edit and Save
    fields2[:frequency][:content] = '33'
    fields2[:frequency][:should_pass] = true
    fill_submit_and_validate(fields2)

    # Verify Successful Modification
    assert page.has_content? 'Goal was successfully updated.'

    # Delete the Goals
    [fields1, fields2].each do |fields|
      edit_goal(fields)
      deleteGoals([fields])
    end

  end

  test 'create logs' do
    login()

    fields1 = submit_and_verify_goal1()

    log1 = {
        log_date: {
            message:      @cantBeBlank,
            should_pass:  true,
            content:      '2000-01-01'
        },
        quantity: {
            message:      @isNotNumber,
            should_pass:  true,
            content:      '11'
        },
        description: {
            message:      @cantBeBlank,
            should_pass:  true,
            content:      'description1'
        }
    }

    #Goto logs page
    within(:xpath, view_row_xpath(fields1)) do
      find(:xpath, ".//a[contains(@class, 'goal-logs-link')]").click
    end
    assert page.has_content? 'Minimum to Stay on Track:'

    # Test Simple Add
    add_log(log1)
    validate_fields(log1, :log)

    # Test Error Add
    log1[:quantity][:content] = ''
    log1[:quantity][:should_pass] = false
    add_log(log1)
    validate_fields(log1, :log)
    assert page.has_content? '1 error prohibited this goal from being saved:'

    click_link 'Goals'
    deleteGoals([fields1])
  end

  def add_log(log)
    within(:xpath, "//tr[.//button[text()='Add']]") do
      fill_in "log[log_date]", with: log[:log_date][:content]
      fill_in "log[quantity]", with: log[:quantity][:content]
      fill_in "log[description]", with: log[:description][:content]
      click_button 'Add'
    end
  end

  def deleteGoals(goals)
    goals.each do |goal|
      within(:xpath, "#{edit_row_xpath(goal)} | #{view_row_xpath(goal)}") do
        click_link 'goal-delete-link-id'
        a = page.driver.browser.switch_to.alert
        assert a.text == 'Are you sure you want to delete this Goal?'
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

  def edit_goal(fields)
    within(:xpath, view_row_xpath(fields)) do
      find(:xpath, ".//td[text()='#{fields[:action][:content]}']")
      find(:xpath, ".//a[contains(@class, 'goal-edit-link')]").click
    end
    assert find('.goal-submit-link')
  end

  def fill_submit_and_validate(fields)
    fill_goal_in_edit(fields)
    submit_goal(fields)
    validate_fields(fields)
  end

  def fill_goal_in_edit(fields)
    within(:xpath, edit_row_xpath(fields)) do
      fields.keys.each do |field|
        if fields[field][:type] == :select
          select fields[field][:content], from: "#{field}-select"
        else
          fill_in "goal[#{field}]", with: fields[field][:content]
        end
      end
    end
  end

  def submit_goal(fields)
    within(:xpath, edit_row_xpath(fields)) do
      find('.goal-submit-link').click
    end
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
    unless @fields[k][:type] == :select
      @fields[k][:should_pass] = true
      fill_in "goal[#{k}]", with: @fields[k][:content]
    end
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

  def validate_fields(fields, object=:goal)

    passes = fields.values.collect { |mini_hash| mini_hash[:should_pass] }
    error_count = passes.inject(0) {|err_count, should_pass| should_pass ? err_count : err_count  + 1}

    if error_count > 0
      assert page.has_content? "#{pluralize(error_count, 'error')} prohibited this goal from being saved:"
      validate_fields_on_error(fields, object)
    else
      assert page.has_content? "#{object.capitalize} was successfully"
      validate_fields_on_success(fields, object)
    end

  end

  def validate_fields_on_success(fields, object)
    fields.keys.each do |k|
      assert page.has_content?(fields[k][:content])
    end
  end

  def validate_fields_on_error(fields, object)
    fields.keys.each do |k|
      unless fields[k][:type] == :select
        if fields[k][:should_pass]
          p "key=#{k}, content=#{fields[k][:content]}"
          assert page.has_no_content?("#{k.capitalize} #{fields[k][:message]}")
          if fields[k][:type] == :select
            assert page.has_select?("#{object}[#{k}]", selected: fields[k][:content])
          else
            assert page.has_field?("#{object}[#{k}]", with: fields[k][:content])
          end
        else
          assert page.has_content?("#{k.capitalize} #{fields[k][:message]}")
          #assert page.has_no_field?("goal_#{k}", with: fields[k][:content])
        end
      end
    end
  end

end
