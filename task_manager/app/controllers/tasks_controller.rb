class TasksController < ApplicationController
  before_action :authenticate!

  def index
    @tasks = Task.all
  end

  def create
    @task = current_account.tasks.new
  end

  def shuffle
  end
end
