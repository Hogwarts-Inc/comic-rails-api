# frozen_string_literal: true

ActiveAdmin.register Storiette do
  permit_params :title, :description, :active

  index do
    selectable_column
    id_column
    column :title
    column :description
    toggle_bool_column :active,
                       if: proc { |storiette| storiette.active? || Storiette.active.empty? },
                       success_message: 'La historieta fue activada correctamente!'

    actions
  end

  filter :title
  filter :description
  filter :active

  form do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :active, as: :boolean
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :description
      row :active
    end

    active_admin_comments
  end
end
