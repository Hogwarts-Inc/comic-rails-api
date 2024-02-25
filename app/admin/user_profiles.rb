ActiveAdmin.register UserProfile do
  permit_params :email, :given_name, :name, :family_name, :wallet_address, :image, :picture, :sub

  index do
    selectable_column
    id_column
    column :email
    column :given_name
    column :family_name
    column :image do |user|
      if user.image.present?
        image_tag(url_for(user.image), width: '100px', height: '100px', class: 'object-contain')
      else
        content_tag(:span, 'La viñeta no tiene imagen')
      end
    end

    actions
  end

  filter :email
  filter :given_name
  filter :family_name

  form do |f|
    f.inputs do
      f.input :given_name
      f.input :family_name
      f.input :email
      f.input :wallet_address
      f.input :picture
      f.input :sub, only: [:create]
      f.input :image, as: :file, input_html: { accept: 'image/jpeg,image/png,image/jpg' }

      render 'admin/shared/display_errors', resource: f.object
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :given_name
      row :family_name
      row :email
      row :wallet_address
      row :picture
      row :sub
      row :image do |user|
        if user.image.present?
          image_tag(url_for(user.image), width: '100px', height: '100px', class: 'object-contain')
        else
          content_tag(:span, 'La viñeta no tiene imagen')
        end
      end
    end

    active_admin_comments
  end

  controller do
    def new
      if session[:user_profile_params].present?
        @user_profile = UserProfile.new(session[:user_profile_params])
        session.delete(:user_profile_params)
      else
        @user_profile = UserProfile.new
      end
    end

    def create
      unless image_error?
        flash[:error] = 'Porfavor subir imagenes JPEG, PNG y JPG.'
        session[:user_profile_params] = params[:user_profile].except(:image)
        redirect_to new_admin_user_profile_path
        return
      end

      super
    end

    def update
      unless image_error?
        flash[:error] = 'Porfavor subir imagenes JPEG, PNG y JPG.'
        redirect_to edit_admin_user_profile_path(resource)
        return
      end

      super
    end

    def image_error?
      params[:user_profile][:image].nil? ||
      (
        params[:user_profile][:image].present? &&
        params[:user_profile][:image].content_type.in?(['image/jpeg', 'image/png', 'image/jpg'])
      )
    end
  end
end
