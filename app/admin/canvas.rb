# frozen_string_literal: true

ActiveAdmin.register Canva do
  permit_params :title, :chapter_id, :image

  index do
    selectable_column
    id_column
    column :title
    column :chapter
    column :image do |canva|
      if canva.image.present?
        image_tag url_for(canva.image), style: 'width: 10%;'
      else
        content_tag(:span, 'La viñeta no tiene imagen')
      end
    end

    actions
  end

  filter :title
  filter :chapter

  form do |f|
    f.inputs do
      f.input :title
      f.input :chapter_id, as: :select, collection: Chapter.all
      f.input :image, as: :file
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :chapter
      row :image do |canva|
        if canva.image.present?
          image_tag url_for(canva.image), style: 'width: 10%;'
        else
          content_tag(:span, 'La viñeta no tiene imagen')
        end
      end
    end

    active_admin_comments
  end
end
