ActiveAdmin.register TermsAndCondition do
  permit_params :file, :active

  index do
    selectable_column
    id_column
    column :file do |terms_and_condition|
      if terms_and_condition.file.attached?
        link_to terms_and_condition.file.filename, rails_blob_path(terms_and_condition.file), target: '_blank'
      else
        content_tag(:span, 'Falta terms and condition')
      end
    end
    toggle_bool_column :active, if: proc { |terms_and_condition| terms_and_condition.active? || TermsAndCondition.active.empty? }

    actions
  end

  filter :title
  filter :chapter
  filter :active
  filter :user_profile

  form do |f|
    f.inputs do
      f.inputs "Upload" do
        if f.object.file.attached?
          current_file_name = f.object.file.filename
          f.input :file, as: :file, input_html: { accept: 'application/pdf', value: current_file_name }, label: "Current File: #{current_file_name}"
        else
          f.input :file, as: :file, input_html: { accept: 'application/pdf' }
        end
      end
      f.input :active, as: :boolean

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show do
    attributes_table do
      row :id
      row :file do |terms_and_condition|
        if terms_and_condition.file.attached?
          link_to terms_and_condition.file.filename, rails_blob_path(terms_and_condition.file), target: '_blank'
        else
          content_tag(:span, 'Falta terms and condition')
        end
      end
      row :active
    end

    active_admin_comments
  end

  controller do
    def create
      unless params[:terms_and_condition][:file].content_type == 'application/pdf'
        flash[:error] = 'Please upload only PDF files.'
        redirect_to new_admin_terms_and_condition_path
        return
      end

      super
    end

    def update
      unless params[:terms_and_condition][:file].content_type == 'application/pdf'
        flash[:error] = 'Please upload only PDF files.'
        redirect_to edit_admin_terms_and_condition_path(resource)
        return
      end

      super
    end
  end
end
