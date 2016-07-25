ActiveAdmin.register Interval do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :cashier_id, :from, :to, :interval_number, :active, :event_id
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
    id_column
    column :from
    column :to
    column :cashier
    column :interval_number
    column :active
    column :created_at
    column :updated_at
    actions
  end

end
