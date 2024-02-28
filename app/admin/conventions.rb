# frozen_string_literal: true

ActiveAdmin.register Convention do
  menu label: "Eventos"

  permit_params :name, :active, :image, description_ids: []

  index title: "Listado de Eventos" do
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

  form title: "Creación/Edición de Evento" do |f|
    f.inputs do
      f.input :name, required: true
      f.input :image, as: :file, input_html: { accept: 'image/jpeg,image/png,image/jpg' }
      f.input :active, as: :boolean

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show title: "Detalle de Evento" do
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

  controller do
    def new
      if session[:convention_params].present?
        @convention = Convention.new(session[:convention_params])
        session.delete(:convention_params)
      else
        @convention = Convention.new
      end
    end

    def create
      unless image_error?
        flash[:error] = 'Porfavor subir imagenes JPEG, PNG y JPG.'
        session[:convention_params] = params[:convention].except(:image)
        redirect_to new_admin_convention_path
        return
      end

      super
    end

    def update
      unless image_error?
        flash[:error] = 'Porfavor subir imagenes JPEG, PNG y JPG.'
        redirect_to edit_admin_convention_path(resource)
        return
      end

      super
    end

    def image_error?
      params[:convention][:image].nil? ||
      (
        params[:convention][:image].present? &&
        params[:convention][:image].content_type.in?(['image/jpeg', 'image/png', 'image/jpg'])
      )
    end
  end
end
