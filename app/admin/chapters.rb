# frozen_string_literal: true

ActiveAdmin.register Chapter do
  menu label: "Capitulos"

  permit_params :title, :description, :storiette_id, :active

  index title: "Listado de Capitulos" do
    selectable_column
    id_column
    column :title
    column :description
    column :storiette
    toggle_bool_column :active

    actions
  end

  filter :title
  filter :description
  filter :storiette
  filter :active

  form title: "Creación/Edición de Capitulo" do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :storiette_id, as: :select, collection: Storiette.all
      f.input :active, as: :boolean

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show title: "Detalle de Capitulo" do
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
