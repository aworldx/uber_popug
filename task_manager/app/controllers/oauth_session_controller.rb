class OauthSessionController < ApplicationController
  def create
    provider = params[:provider].to_s
    payload = request.env['omniauth.auth']

    account = Account.find_by(public_id: payload['info']['public_id'])
    account ||= persist(provider, payload)

    if account
      session[:account_public_id] = account.public_id
      redirect_to '/'
    else
      redirect_to login_path
    end
  end

  def destroy
    session[:account_public_id] = nil
    redirect_to login_path
  end

  private

  def persist(provider, payload)
    Account.create!(
      public_id: payload['info']['public_id'],
      full_name: payload['info']['full_name'],
      email: payload['info']['email'],
      role: payload['info']['role']
    )
  end
end
