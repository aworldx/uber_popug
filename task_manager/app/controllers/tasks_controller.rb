class TasksController < ApplicationController
  before_action :authenticate!

  def index
    @tasks = policy_scope(Task)
  end

  def new
    @task = current_account.tasks.new
  end

  def create
    worker_id = Account.where(role: 'worker').pluck(:id).sample
    @task = Task.create!(account_id: worker_id, description: task_params[:description])

    event = Event.new(
      { public_id: @task.public_id, description: @task.description, status: @task.status, account_public_id: @task.account.public_id },
      'TaskCreated'
    )
    Producer.new.call(event, topic: 'tasks-stream')

    event = Event.new(
      { task_public_id: @task.public_id, account_public_id: @task.account.public_id },
      'TaskAssigned'
    )
    Producer.new.call(event, topic: 'tasks-lifecycle')
  end

  def reshuffle
    authorize Task

    account_ids = Account.where(role: 'worker').pluck(:id)
    Task.active.find_each do |task|
      task.update!(account_id: account_ids.sample)

      event = Event.new(
        { public_id: task.public_id, description: task.description, status: task.status, account_public_id: task.account.public_id },
        'TaskUpdated'
      )
      Producer.new.call(event, topic: 'tasks-stream')

      event = Event.new(
        { task_public_id: task.public_id, account_public_id: task.account.public_id },
        'TaskAssigned'
      )
      Producer.new.call(event, topic: 'tasks-lifecycle')
    end
  end

  def complete
    @task = Task.find(params[:id])

    authorize @task

    @task.complete!

    event = Event.new(
      { public_id: @task.public_id, description: @task.description, status: @task.status, account_public_id: @task.account.public_id },
      'TaskUpdated'
    )
    Producer.new.call(event, topic: 'tasks-stream')

    event = Event.new(
      { task_public_id: @task.public_id, account_public_id: @task.account.public_id },
      'TaskFinished'
    )
    Producer.new.call(event, topic: 'tasks-lifecycle')
  end

  private

  def task_params
    params.require(:task).permit(:description)
  end
end
