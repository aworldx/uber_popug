class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Pundit::Authorization

  def current_account
    # logger.info "find user by session account id #{session[:account_id]}"
    account = Account.find_by(id: session[:account_id])
    logger.info "find user by session account id #{session[:account_id]} = #{account}"
    account
  end

  def current_user
    current_account
  end

  def authenticate!
    origin_path = request.path ? "/?origin=#{request.path}" : nil
    redirect_to("/login#{origin_path}") unless authenticated?
  end

  def authenticated?
    current_account.present?
  end
end
