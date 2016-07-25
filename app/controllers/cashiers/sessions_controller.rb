class Cashiers::SessionsController < Devise::SessionsController
  layout 'main'
  # before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    id = current_cashier.id
    super
    log = CashierLog.new
    log.cashier_id = id
    log.datetime = Time.now
    log.action = 'logout'
    log.save
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
  def after_sign_in_path_for(resource)
    log = CashierLog.new
    log.cashier_id = resource.id
    log.datetime = Time.now
    log.action = 'login'
    log.save
    '/cashier/sell_ticket'
  end

end
