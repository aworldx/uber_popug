class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_account!, only: [:index]

  def index
    @accounts = Account.all
  end

  def current
    respond_to do |format|
      format.json { render json: current_account }
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @account.update(account_params)
        event = {
          **account_event_data,
          event_name: 'AccountUpdated',
          data: {
            public_id: @account.public_id,
            email: @account.email,
            full_name: @account.full_name,
            position: @account.position,
            role: @account.role
          }
        }

        Producer.new.call(event, topic: 'accounts-stream')

        format.html { redirect_to root_path, notice: 'Account was successfully updated.' }
        format.json { render :index, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @account.update(active: false, disabled_at: Time.now)

    event = {
      **account_event_data,
      event_name: 'AccountDeleted',
      data: { public_id: @account.public_id }
    }

    Producer.new.call(event, topic: 'accounts-stream')

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def account_event_data
    {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'auth_service'
    }
  end

  def current_account
    if doorkeeper_token
      Account.find(doorkeeper_token.resource_owner_id)
    else
      super
    end
  end

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:full_name, :role)
  end
end
