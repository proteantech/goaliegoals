class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :goals, dependent: :destroy

  after_create :after_user_create

  def after_user_create
    h = {
        :action =>          'Eat',
        :quantity =>        2,
        :unit =>            'vegetables',
        :frequency =>       1,
        :frequency_unit =>  'day',
        :start =>           Date.today,
        :end =>             Date.today >> 1
    }
    self.goals.create(h)

    h = {
        :action =>          'Exercise',
        :quantity =>        30,
        :unit =>            'minutes',
        :frequency =>       3,
        :frequency_unit =>  'week',
        :start =>           Date.today,
        :end =>             Date.today >> 1
    }
    self.goals.create(h)

  end

end
