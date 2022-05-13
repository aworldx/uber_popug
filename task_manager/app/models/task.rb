class Task < ApplicationRecord
  belongs_to :account

  enum status: {
    active: 'active',
    completed: 'completed'
  }

  state_machine :status, initial: :active do
    event :complete do
      transition active: :completed
    end
  end
end
