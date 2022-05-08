class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_account
    Account.find_by(public_id: session['account_public_id'])
  end

  def authenticate!
    origin_path = request.path ? "/?origin=#{request.path}" : nil
    redirect_to("/login#{origin_path}") unless authenticated?
  end

  def authenticated?
    !!current_account
  end
end
