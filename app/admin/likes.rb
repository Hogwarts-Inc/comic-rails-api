# frozen_string_literal: true

ActiveAdmin.register Like do
  permit_params :canva_id, :user_profile_id

  index title: "Listado de Likes" do
    selectable_column
    id_column
    column :canva
    column :user_profile

    actions
  end

  filter :canva
  filter :user_profile

  form title: "Creación/Edición de Like" do |f|
    f.inputs do
      f.input :canva, as: :select, collection: Canva.all.map { |c| [c.id, c.id] }
      f.input :user_profile, as: :select, collection: UserProfile.all

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show title: "Detalle de Like" do
    attributes_table do
      row :id
      row :canva
      row :user_profile
    end

    active_admin_comments
  end
end
