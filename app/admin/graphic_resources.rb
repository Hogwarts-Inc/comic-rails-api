# frozen_string_literal: true

ActiveAdmin.register GraphicResource do
  menu label: "Recursos Graficos"

  permit_params :resource_type, :image

  index title: "Listado de Recursos Graficos" do
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

  form title: "Creación/Edición de Recurso Grafico" do |f|
    f.inputs do
      f.input :resource_type
      f.input :image, as: :file

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show title: "Detalle de Recurso Grafico" do
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
        flash[:error] = 'Porfavor subir imagenes JPEG, PNG y JPG para background, SVG para el resto de tipos'
        session[:graphic_resource_params] = params[:graphic_resource].except(:image)
        redirect_to new_admin_graphic_resource_path
        return
      end

      super
    end

    def update
      unless image_error?
        flash[:error] = 'Porfavor subir imagenes JPEG, PNG y JPG para background, SVG para el resto de tipos'
        redirect_to edit_admin_graphic_resource_path(resource)
        return
      end

      super
    end

    def image_error?
      params[:graphic_resource][:image].nil? ||
      (
        params[:graphic_resource][:resource_type] != 'background' &&
        params[:graphic_resource][:image].present? &&
        params[:graphic_resource][:image].content_type == 'image/svg+xml'
      ) ||
      (
        params[:graphic_resource][:resource_type] == 'background' &&
        params[:graphic_resource][:image].present? &&
        params[:graphic_resource][:image].content_type.in?(['image/jpeg', 'image/png', 'image/jpg'])
      )
    end
  end
end
