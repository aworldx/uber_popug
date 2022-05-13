class OauthSessionController < ApplicationController
  def create
    logger.info 'new session create!'
    payload = request.env['omniauth.auth']

    logger.info 'task_manager'
    logger.info payload['info']['public_id']
    logger.info Account.find_by(public_id: payload['info']['public_id'])

    account = Account.find_by(public_id: payload['info']['public_id'])
    account ||= create_account!(payload)

    if account
      session[:account_id] = account.id
      logger.info "session account id #{session[:account_id]}"
      redirect_to '/'
    else
      redirect_to login_path
    end
  end

  def destroy
    session[:account_id] = nil
    redirect_to login_path
  end

  private

  def create_account!(payload)
    Account.create!(
      public_id: payload['info']['public_id'],
      full_name: payload['info']['full_name'],
      email: payload['info']['email'],
      role: payload['info']['role']
    )
  end
end
