# frozen_string_literal: true

ActiveAdmin.register Description do
  permit_params :title , :text, :active, :descriptionable_id, :descriptionable_type

  index do
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

  form do |f|
    f.inputs do
      f.input :title, required: true
      f.input :text, required: true
      f.input :active, as: :boolean
      f.input :descriptionable_type, as: :select, collection: ['Convention', 'Character'], prompt: 'Select Type', input_html: { class: 'descriptionable-type-select' }
      f.input :descriptionable_id, as: :select, input_html: { class: 'descriptionable-id-select' }
    end

    f.actions
  end

  show do
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
