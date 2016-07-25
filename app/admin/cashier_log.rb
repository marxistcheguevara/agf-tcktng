ActiveAdmin.register CashierLog do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :cashier_id, :action, :datetime
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
  index do
    selectable_column
    column :cashier
    column :action
    column :datetime
    column :created_at
    column :updated_at
    actions
  end


end
