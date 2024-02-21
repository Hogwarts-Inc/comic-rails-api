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

  filter :active

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
    def new
      if session[:terms_and_condition_params].present?
        @terms_and_condition = TermsAndCondition.new(session[:terms_and_condition_params])
        session.delete(:terms_and_condition_params)
      else
        @terms_and_condition = TermsAndCondition.new
      end
    end

    def create
      unless file_error?
        flash[:error] = 'Porfavor subir imagenes JPEG, PNG y JPG.'
        session[:terms_and_condition_params] = params[:terms_and_condition].except(:image)
        redirect_to new_admin_terms_and_condition_path
        return
      end

      super
    end

    def update
      unless file_error?
        flash[:error] = 'Porfavor subir imagenes JPEG, PNG y JPG.'
        redirect_to edit_admin_terms_and_condition_path(resource)
        return
      end

      super
    end

    def file_error?
      params[:terms_and_condition][:file].nil? ||
      (
        params[:terms_and_condition][:file].present? &&
        params[:terms_and_condition][:file].content_type.in?('application/pdf')
      )
    end
  end
end
