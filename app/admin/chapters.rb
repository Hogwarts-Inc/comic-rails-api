# frozen_string_literal: true

ActiveAdmin.register Chapter do
  permit_params :title, :description, :storiette_id

  index do
    selectable_column
    id_column
    column :title
    column :description
    column :storiette

    actions
  end

  filter :title
  filter :description
  filter :storiette

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :storiette_id, as: :select, collection: Storiette.all
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :storiette
      row :description
    end

    active_admin_comments
  end
end
