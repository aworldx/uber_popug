class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  enum role: {
    admin: 'admin',
    worker: 'worker',
    manager: 'manager'
  }

  after_commit :produce_account_created, on: :create

  private

  def produce_account_created
    event = Event.new(
      {
        public_id: account.public_id,
        email: account.email,
        full_name: account.full_name,
        position: account.position,
        role: account.role
      },
      'AccountCreated'
    )
    Producer.new.call(event, topic: 'accounts-stream')
  end
end
