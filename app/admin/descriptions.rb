# frozen_string_literal: true

ActiveAdmin.register Description do
  menu label: "Descripciones"

  permit_params :title , :text, :active, :descriptionable_id, :descriptionable_type

  index title: "Listado de Descripciones" do
    selectable_column
    id_column
    column :title
    column :text
    column :descriptionable
    toggle_bool_column :active


    actions
  end

  filter :title
  filter :text
  filter :active

  form title: "Creacion/Edición de Descripcion" do |f|
    f.inputs do
      f.input :title, required: true
      f.input :text, required: true
      f.input :active, as: :boolean
      f.input :descriptionable_type, as: :select, collection: ['Convention', 'Character'], prompt: 'Select Type', input_html: { class: 'descriptionable-type-select' }
      f.input :descriptionable_id, as: :select, input_html: { class: 'descriptionable-id-select' }

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show title: "Detalle de Descripcion" do
    attributes_table do
      row :id
      row :title
      row :text
      row :active
      row :descriptionable
    end

    active_admin_comments
  end
end
