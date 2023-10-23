# frozen_string_literal: true

ActiveAdmin.register Chapter do
  permit_params :title, :description, :storiette_id, :active

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :storiette
    toggle_bool_column :active, success_message: 'El capitulo fue activado correctamente!'

    actions
  end

  filter :title
  filter :description
  filter :storiette
  filter :active

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :storiette_id, as: :select, collection: Storiette.all
      f.input :active, as: :boolean
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :storiette
      row :description
      row :active
    end

    active_admin_comments
  end
end
