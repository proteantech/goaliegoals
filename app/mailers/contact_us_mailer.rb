class ContactUsMailer < ActionMailer::Base
  default from: 'goaliegoals@gg.com'
  default to: 'proteanevolution@gmail.com'
  default subject: 'GoalieGoals - Contact Us'

  def contact_us(options)
    @message = options[:message]
    mail(options)
  end

end