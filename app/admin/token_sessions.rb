ActiveAdmin.register TokenSession do
  permit_params :token, :user_profile_id

  index do
    selectable_column
    id_column
    column :token do |resource|
      div style: 'width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;' do
        resource.token
      end
    end
    column :user_profile

    actions
  end

  show do
    attributes_table do
      row :token
      row :user_profile
    end

    active_admin_comments
  end

  actions :index, :show

  controller do
    def current_user
      # Customize this to return the current user or session
      # For example, if using Devise for authentication:
      current_user || current_user_session
    end
  end
end
