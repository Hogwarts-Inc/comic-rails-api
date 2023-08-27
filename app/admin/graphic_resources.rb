# frozen_string_literal: true

ActiveAdmin.register GraphicResource do
  permit_params :resource_type, :image

  index do
    selectable_column
    id_column
    column :resource_type
    column :image do |graphic_resource|
      if graphic_resource.image.present?
        image_tag url_for(graphic_resource.image), style: 'width: 10%;'
      else
        content_tag(:span, 'El recurso grafico no tiene imagen')
      end
    end

    actions
  end

  filter :resource_type

  form do |f|
    f.inputs do
      f.input :resource_type
      f.input :image, as: :file
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :resource_type
      row :image do |graphic_resource|
        if graphic_resource.image.present?
          image_tag url_for(graphic_resource.image), style: 'width: 10%;'
        else
          content_tag(:span, 'El recurso grafico no tiene imagen')
        end
      end
    end

    active_admin_comments
  end
end
