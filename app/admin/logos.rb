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
      f.input :image, as: :file
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
    def create
      unless params[:logo][:image].content_type.in?(['image/jpeg', 'image/png', 'image/jpg'])
        flash[:error] = 'Please upload only JPEG, PNG, or JPG images.'
        redirect_to new_admin_logo_path
        return
      end

      super
    end

    def update
      unless params[:logo][:image].content_type.in?(['image/jpeg', 'image/png', 'image/jpg'])
        flash[:error] = 'Please upload only JPEG, PNG, or JPG images.'
        redirect_to edit_admin_logo_path(resource)
        return
      end

      super
    end
  end
end
