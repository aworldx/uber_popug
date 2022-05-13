class TaskPolicy < ApplicationPolicy
  attr_reader :user, :task

  def initialize(user, task)
    @user = user
    @task = task
  end

  def reshuffle?
    user.role == 'admin' || user.role == 'manager'
  end

  def complete?
    task.active? && user.role == 'worker' && task.account_id = user.id
  end

  class Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.role == 'admin' || user.role == 'manager'
        scope.all
      else
        scope.where(account_id: user.id)
      end
    end

    private

    attr_reader :user, :scope
  end
end
