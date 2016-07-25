class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # app/controllers/application_controller.rb
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  private
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(cashiers)
    new_cashier_session_path
  end
end
