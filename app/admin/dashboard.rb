# frozen_string_literal: true

ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { 'La historieta mas grande del mundo!' } do
    div class: 'blank_slate_container', id: 'dashboard_default_message' do
      span class: 'blank_slate' do
        span 'Bienvenido al backoffice de la historieta mas grande del mundo'
        small 'Aqui vas a poder ver todos los datos guardados en la base de datos y cambiarlos, a su vez tambien vas a poder activar/desactivar las viñetas, capitulos y otras cosas.'
      end
    end
  end
end
