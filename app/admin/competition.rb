ActiveAdmin.register Competition do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :image_url, :program, :IsActive
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  form do|f|
    f.inputs "Competition Details" do
      f.input :name
      f.input :image_url
      f.input :program, as: :ckeditor
      f.input :IsActive
    end
    f.actions
  end

end
