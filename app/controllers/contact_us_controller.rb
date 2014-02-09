class ContactUsController < ApplicationController

  # GET /contact_us
  def index

  end

  def send_mail
    ContactUsMailer.contact_us(params).deliver
    flash[:notice] = 'Your message has been sent.'
    redirect_to action: index
  end

end