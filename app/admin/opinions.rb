# frozen_string_literal: true

ActiveAdmin.register Opinion do
  permit_params :canva_id, :user_profile_id, :active, :text

  index do
    selectable_column
    id_column
    column :canva_id
    column :user_profile_id
    column :text
    toggle_bool_column :active

    actions
  end

  filter :canva
  filter :user_profile
  filter :active

  form do |f|
    f.inputs do
      f.input :canva, as: :select, collection: Canva.all.map { |c| [c.id, c.id] }
      f.input :user_profile, as: :select, collection: UserProfile.all
      f.input :text
      f.input :active, as: :boolean
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :canva
      row :user_profile
      row :text
      row :active
    end

    active_admin_comments
  end
end
