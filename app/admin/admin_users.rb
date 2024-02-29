# frozen_string_literal: true

ActiveAdmin.register AdminUser do
  menu label: "Usuarios administradores"
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def update
      admin_user = AdminUser.find(params[:id])

      if admin_user == current_admin_user
        super
      else
        flash[:error] = "Solo podes editar tu cuenta"
        redirect_back fallback_location: admin_root_path
      end
    end
  end
end
