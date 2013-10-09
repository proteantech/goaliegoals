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

  test 'create goal' do

    login()

    submit_and_verify_goal1()
    submit_and_verify_goal2()

    submit_all_blank_and_validate()

    # Fill in fields one at a time and ensure proper validation
    @fields.keys.each do |k|
      fill_next_field_and_validate(k)
    end

    submit_all_blank_and_validate()

    find(:xpath, "//a[@class='edit-goal-link][0]'").click
    assert find('.goal-submit-link').visible?

  end

  test 'edit goal' do

    login()

    submit_and_verify_goal1()
    submit_and_verify_goal2()

    submit_all_blank_and_validate()

    assert !find(:xpath, "(//a[contains(@class, 'goal-submit-link')])[1]", visible: false).visible?
    find(:xpath, "(//a[contains(@class, 'edit-goal-link')])[1]").click
    assert find('.goal-submit-link').visible?

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

  def submit_and_verify_goal1
    fill_in 'goal_action', with: 'action1'
    fill_in 'goal_quantity', with: '1'
    fill_in 'goal_unit', with: 'unit1'
    fill_in 'goal_frequency', with: '1'
    select 'day', from: 'frequency-unit-select'
    fill_in 'goal_start', with: '2000-12-03'
    fill_in 'goal_end', with: '2000-12-04'
    click_on 'Add'

    assert page.has_content? 'Goal was successfully created.'
    assert page.has_content? 'action1'
    assert page.has_content? 'unit1'
    assert page.has_content? '2000-12-03'
    assert page.has_content? '2000-12-04'
  end

  def submit_and_verify_goal2
    fill_in 'goal_action', with: 'action2'
    fill_in 'goal_quantity', with: '2'
    fill_in 'goal_unit', with: 'unit2'
    fill_in 'goal_frequency', with: '2'
    select 'week', from: 'frequency-unit-select'
    fill_in 'goal_start', with: '2000-12-05'
    fill_in 'goal_end', with: '2000-12-06'
    click_on 'Add'

    assert page.has_content? 'Goal was successfully created.'
    assert page.has_content? 'action2'
    assert page.has_content? 'unit2'
    assert page.has_content? '2000-12-05'
    assert page.has_content? '2000-12-06'
  end

  # Check validation with no fields filled in
  def submit_all_blank_and_validate
    blank_dates_unless_should_pass
    click_on 'Add'
    validate_fields
  end

  # k = key of the field to fill next
  def fill_next_field_and_validate(k)
    fill_next_field_and_adjust_fields_map(k)
    click_on 'Add'
    validate_fields
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

  def validate_fields

    passes = @fields.values.collect { |mini_hash| mini_hash[:should_pass] }
    error_count = passes.inject(0) {|err_count, should_pass| should_pass ? err_count : err_count  + 1}

    if error_count > 0
      assert page.has_content? "#{pluralize(error_count, 'error')} prohibited this goal from being saved:"
      validate_fields_on_error
    else
      assert page.has_content? 'Goal was successfully created.'
      validate_fields_on_success
    end

  end

  def validate_fields_on_success
    @fields.keys.each do |k|
      assert page.has_content?(@fields[k][:content])
    end
  end

  def validate_fields_on_error
    @fields.keys.each do |k|
      if @fields[k][:should_pass]
        p "key=#{k}, content=#{@fields[k][:content]}"
        assert page.has_no_content?("#{k.capitalize} #{@fields[k][:message]}")
        assert page.has_field?("goal_#{k}", with: @fields[k][:content])
      else
        assert page.has_content?("#{k.capitalize} #{@fields[k][:message]}")
        assert page.has_no_field?("goal_#{k}", with: @fields[k][:content])
      end
    end
  end

end
