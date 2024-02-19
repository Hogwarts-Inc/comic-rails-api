# frozen_string_literal: true

ActiveAdmin.register GraphicResource do
  permit_params :resource_type, :image

  index do
    selectable_column
    id_column
    column :resource_type
    column :image do |graphic_resource|
      if graphic_resource.image.present?
        image_tag(url_for(graphic_resource.image), width: '100px', height: '100px', class: 'object-contain')
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

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :resource_type
      row :image do |graphic_resource|
        if graphic_resource.image.present?
          image_tag(url_for(graphic_resource.image), width: '100px', height: '100px', class: 'object-contain')
        else
          content_tag(:span, 'El recurso grafico no tiene imagen')
        end
      end
    end

    active_admin_comments
  end

  controller do
    def create
      unless params[:graphic_resource][:image].content_type.in?(['image/jpeg', 'image/png', 'image/jpg'])
        flash[:error] = 'Please upload only JPEG, PNG, or JPG images.'
        redirect_to new_admin_graphic_resource_path
        return
      end

      super
    end

    def update
      unless params[:graphic_resource][:image].content_type.in?(['image/jpeg', 'image/png', 'image/jpg'])
        flash[:error] = 'Please upload only JPEG, PNG, or JPG images.'
        redirect_to edit_admin_graphic_resource_path(resource)
        return
      end

      super
    end
  end
end
