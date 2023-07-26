# frozen_string_literal: true

ActiveAdmin.register Storiette do
  permit_params :title, :description

  index do
    selectable_column
    id_column
    column :title
    column :description

    actions
  end

  filter :title
  filter :description

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :description
    end

    active_admin_comments
  end
end
