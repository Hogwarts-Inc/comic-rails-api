# frozen_string_literal: true

ActiveAdmin.register Convention do
  permit_params :name, :active, :image, description_ids: []

  index do
    selectable_column
    id_column
    column :name
    column 'Images' do |convention|
      div do
        span image_tag(convention.image, width: '100px', height: '100px', class: 'object-contain')
      end
    end
    toggle_bool_column :active

    actions
  end

  filter :name
  filter :descriptions
  filter :active

  form do |f|
    f.inputs do
      f.input :name, required: true
      f.input :image, as: :file
      f.input :active, as: :boolean
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :descriptions
      row :active
      row 'Image' do |convention|
        div style: 'display: flex; flex-direction: row' do
          span image_tag(convention.image, width: '200px', height: '200px', class: 'object-contain')
        end
      end
    end

    active_admin_comments
  end
end
