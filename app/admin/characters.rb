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
      f.input :images, as: :file, input_html: { multiple: true, accept: 'image/jpeg,image/png,image/jpg' }
      f.object.images.each do |image|
        span image_tag(image, width: '100px', height: '100px', class: 'object-contain')
      end
      f.input :active, as: :boolean

      render 'admin/shared/display_errors', resource: f.object
    end

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

  controller do
    def new
      if session[:character_params].present?
        @character = Character.new(session[:character_params])
        session.delete(:character_params)
      else
        @character = Character.new
      end
    end

    def create
      if params[:character][:images].present?
        is_error = params[:character][:images].reject { |image| image == "" }
                                              .map { |image| image.content_type.in?(['image/jpeg', 'image/png', 'image/jpg']) }
                                              .all? { |image| image == true }
        unless is_error
          flash[:error] = 'Please upload only JPEG, PNG, or JPG images.'
          session[:character_params] = params[:character].except(:image)
          redirect_to new_admin_character_path
          return
        end
      end

      super
    end

    def update
      if params[:character][:images].present?
        is_error = params[:character][:images].reject { |image| image == "" }
                                          .map { |image| image.content_type.in?(['image/jpeg', 'image/png', 'image/jpg']) }
                                          .all? { |image| image == true }
        unless is_error
          flash[:error] = 'Please upload only JPEG, PNG, or JPG images.'
          redirect_to edit_admin_character_path(resource)
          return
        end
      end

      super
    end
  end
end
