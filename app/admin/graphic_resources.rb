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
      f.input :image, as: :file, input_html: { accept: 'image/svg+xml' }

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
    def new
      if session[:graphic_resource_params].present?
        @graphic_resource = GraphicResource.new(session[:graphic_resource_params])
        session.delete(:graphic_resource_params)
      else
        @graphic_resource = GraphicResource.new
      end
    end

    def create
      unless image_error?
        flash[:error] = 'Please upload only JPEG, PNG, or JPG images.'
        session[:graphic_resource_params] = params[:graphic_resource].except(:image)
        redirect_to new_admin_graphic_resource_path
        return
      end

      super
    end

    def update
      unless image_error?
        flash[:error] = 'Please upload only JPEG, PNG, or JPG images.'
        redirect_to edit_admin_graphic_resource_path(resource)
        return
      end

      super
    end

    def image_error?
      params[:graphic_resource][:image].nil? ||
      (
        params[:graphic_resource][:image].present? &&
        params[:graphic_resource][:image].content_type == 'image/svg+xml'
      )
    end
  end
end
