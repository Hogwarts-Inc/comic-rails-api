# frozen_string_literal: true

ActiveAdmin.register Opinion do
  menu label: "Comentarios"

  permit_params :canva_id, :user_profile_id, :active, :text

  index title: "Listado de Comentarios" do
    selectable_column
    id_column
    column :canva_id
    column :user_profile_id
    column :text
    toggle_bool_column :active

    actions
  end

  filter :canva
  filter :user_profile
  filter :active

  form title: "Creación/Edición de Comentarios" do |f|
    f.inputs do
      f.input :canva, as: :select, collection: Canva.all.map { |c| [c.id, c.id] }
      f.input :user_profile, as: :select, collection: UserProfile.all
      f.input :text
      f.input :active, as: :boolean

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show title: "Detalle de Comentario" do
    attributes_table do
      row :id
      row :canva
      row :user_profile
      row :text
      row :active
    end

    active_admin_comments
  end
end
