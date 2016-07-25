Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  #your custom code
end