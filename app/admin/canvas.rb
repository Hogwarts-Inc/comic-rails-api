# frozen_string_literal: true
require 'fastimage'

ActiveAdmin.register Canva do
  permit_params :title, :chapter_id, :image, :active, :user_profile_id

  index do
    selectable_column
    id_column
    column :title
    column :chapter
    column :user_profile
    column :image do |canva|
      if canva.image.present?
        image_tag(url_for(canva.image), width: '100px', height: '100px', class: 'object-contain')
      else
        content_tag(:span, 'La viñeta no tiene imagen')
      end
    end
    toggle_bool_column :active

    actions
  end

  filter :title
  filter :chapter
  filter :active
  filter :user_profile

  form do |f|
    f.inputs do
      f.input :title
      f.input :chapter_id, as: :select, collection: Chapter.all
      f.input :user_profile, as: :select, collection: UserProfile.all
      f.input :image, as: :file
      f.input :active, as: :boolean

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :chapter
      row :user_profile
      row :image do |canva|
        if canva.image.present?
          image_tag(url_for(canva.image), width: '100px', height: '100px', class: 'object-contain')
        else
          content_tag(:span, 'La viñeta no tiene imagen')
        end
      end
      row :active
    end

    active_admin_comments
  end

  controller do
    def create
      invalid_message = ValidateImageSizeDimensionService.validate(params[:canva][:image])
      unless invalid_message.nil?
        flash[:error] = invalid_message
        redirect_to new_admin_canva_path
        return

      end

      super
    end

    def update
      invalid_message = ValidateImageSizeDimensionService.validate(params[:canva][:image])
      unless invalid_message.nil?
        flash[:error] = invalid_message
        redirect_to edit_admin_canva_path(resource)
        return
      end

      super
    end
  end
end

