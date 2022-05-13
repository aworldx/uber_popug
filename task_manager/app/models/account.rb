class Account < ApplicationRecord
  enum role: {
    admin: 'admin',
    worker: 'worker',
    manager: 'manager'
  }

  has_many :tasks
end
