class ContactUsMailer < ActionMailer::Base
  default from: 'anonymous@gg.com'
  default to: 'goaliegoals31@gmail.com'
  default subject: 'GoalieGoals - Contact Us'

  def contact_us(options)
    @from = options[:from]
    @message = options[:message]
    mail(options)
  end

end