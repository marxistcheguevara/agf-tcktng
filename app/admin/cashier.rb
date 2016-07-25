ActiveAdmin.register Cashier do
  permit_params :email, :password, :password_confirmation, :sell, :unsell, :bron, :invitation, :discount, :name, :surname

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :sell
  filter :unsell
  filter :bron
  filter :invitation
  filter :discount

  form do |f|
    f.inputs "Cashier Details" do
      f.input :email
      f.input :name
      f.input :surname
      f.input :password
      f.input :password_confirmation
      f.input :sell
      f.input :unsell
      f.input :bron
      f.input :invitation
      f.input :discount
    end
    f.actions
  end

end
