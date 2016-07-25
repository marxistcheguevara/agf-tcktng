ActiveAdmin.register TicketItem do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :event_id, :cat_id, :sector_id, :place, :cashier_id, :invoice_id, :is_invalid
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end



end
