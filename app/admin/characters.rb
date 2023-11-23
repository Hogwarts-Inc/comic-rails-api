# frozen_string_literal: true

ActiveAdmin.register Character do
  permit_params :name, :active, description_ids: [], images: []

  index do
    selectable_column
    id_column
    column :name
    column 'Images' do |character|
      div do
        character.images.first(2).each do |image|
          span image_tag(image, width: '100px', height: '100px', class: 'object-contain')
        end
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
      f.input :images, as: :file, input_html: { multiple: true }
      f.object.images.each do |image|
        span image_tag(image, width: '100px', height: '100px', class: 'object-contain')
      end
    end
    f.input :active, as: :boolean

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :descriptions
      row 'Images' do |character|
        div style: 'display: flex; flex-direction: row' do
          character.images.each do |image|
            span image_tag(image, width: '200px', height: '200px', class: 'object-contain')
          end
        end
      end
      row :active
    end

    active_admin_comments
  end
end
