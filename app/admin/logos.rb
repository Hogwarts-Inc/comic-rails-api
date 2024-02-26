ActiveAdmin.register Logo do
  permit_params :image, :active

  index do
    selectable_column
    id_column
    column :image do |logo|
      if logo.image.present?
        image_tag(url_for(logo.image), width: '100px', height: '100px', class: 'object-contain')
      else
        content_tag(:span, 'La viñeta no tiene imagen')
      end
    end
    toggle_bool_column :active, if: proc { |logo| logo.active? || Logo.active.empty? }

    actions
  end

  filter :active

  form do |f|
    f.inputs do
      f.input :image, as: :file, input_html: { accept: 'image/jpeg,image/png,image/jpg,image/svg+xml' }
      f.input :active, as: :boolean

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :image do |logo|
        if logo.image.present?
          image_tag(url_for(logo.image), width: '100px', height: '100px', class: 'object-contain')
        else
          content_tag(:span, 'El logo no tiene imagen')
        end
      end
      row :active
    end

    active_admin_comments
  end

  controller do
    def new
      if session[:logo_params].present?
        @logo = Logo.new(session[:logo_params])
        session.delete(:logo_params)
      else
        @logo = Logo.new
      end
    end

    def create
      unless image_error?
        flash[:error] = 'Porfavor subir imagenes SVG, JPEG, PNG y JPG.'
        session[:logo_params] = params[:logo].except(:image)
        redirect_to new_admin_logo_path
        return
      end

      super
    end

    def update
      unless image_error?
        flash[:error] = 'Porfavor subir imagenes SVG, JPEG, PNG y JPG.'
        redirect_to edit_admin_logo_path(resource)
        return
      end

      super
    end

    def image_error?
      params[:logo][:image].nil? ||
      (
        params[:logo][:image].present? &&
        params[:logo][:image].content_type.in?(['image/jpeg', 'image/png', 'image/jpg', 'image/svg+xml'])
      )
    end
  end
end
