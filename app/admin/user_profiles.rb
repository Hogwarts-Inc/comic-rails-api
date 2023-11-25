ActiveAdmin.register UserProfile do
  permit_params :email, :given_name, :name, :family_name, :nft_url, :image, :picture, :sub

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
      f.input :nft_url
      f.input :picture
      f.input :sub, only: [:create]
      f.input :image, as: :file
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :given_name
      row :family_name
      row :email
      row :nft_url
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
end
