ActiveAdmin.register QueueTime do
  permit_params :remove_from_queue_time, :active

  index do
    selectable_column
    id_column
    column :remove_from_queue_time
    column :active

    actions
  end

  filter :active

  form do |f|
    f.inputs do
      f.input :remove_from_queue_time, input_html: { type: :number, step: 1, min: 1 }
      f.input :active, as: :boolean

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions do
      f.action :submit, button_html: { 'data-confirm': "ADVERTENCIA: Al activar un nuevo tiempo de eliminación para una viñeta, los usuarios que se encuentren en una cola de espera serán eliminados al establecer el nuevo tiempo. ¿Estás seguro de continuar?" }
      f.action :cancel, as: :link, label: 'Cancel', wrapper_html: { class: 'cancel' }
    end
  end

  show do
    attributes_table do
      row :id
      row :remove_from_queue_time
      row :active
    end

    active_admin_comments
  end
end
