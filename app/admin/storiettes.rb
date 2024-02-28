ActiveAdmin.register Storiette do
  menu label: "Historieta"

  permit_params :title, :description, :active

  index title: "Listado de Historietas" do
    selectable_column
    id_column
    column :title
    column :description
    toggle_bool_column :active, if: proc { |storiette| storiette.active? || Storiette.active.empty? }

    actions
  end

  filter :title
  filter :description
  filter :active

  form title: "Creación/Edición de Historieta" do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :active, as: :boolean

      render 'admin/shared/display_errors', resource: f.object
    end

    f.actions
  end

  show title: "Detalle de Historieta" do
    attributes_table do
      row :id
      row :title
      row :description
      row :active
    end

    active_admin_comments
  end

  member_action :export_images_to_zip, method: :get do
    storiette = Storiette.find(params[:id])
    temp_file = Tempfile.new("images.zip")

    Zip::OutputStream.open(temp_file) { |zos| }

    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
      storiette.chapters.active.each do |chapter|
        chapter.canvas.active.each do |canva|
          image_data = canva.image.download
          zipfile.get_output_stream("chapter_#{chapter.id}_canva_#{canva.id}.jpg") { |f| f.puts image_data }
        end
      end
    end

    send_file temp_file.path, filename: "#{storiette.title}_images.zip"
    temp_file.close
  end

  member_action :export_images_to_pdf, method: :get do
    storiette = Storiette.find(params[:id])

    temp_file = Tempfile.new("images.pdf")

    Prawn::Document.generate(temp_file.path) do |pdf|
      storiette.chapters.active.each do |chapter|
        chapter.canvas.active.each_with_index do |canva, index|
          image_data = canva.image.download
          image = MiniMagick::Image.read(image_data)
          temp_jpeg_file = Tempfile.new('image.jpg')

          image.format('jpg')
          image.write(temp_jpeg_file.path)

          pdf.image temp_jpeg_file.path, fit: [pdf.bounds.width, pdf.bounds.height]

          # Don't start a new page if it's the last canvas
          pdf.start_new_page unless index == chapter.canvas.active.size - 1
        end
      end
    end

    send_file temp_file.path, filename: "#{storiette.title}_images.pdf"
    temp_file.close
  end

  action_item :export_images_to_zip, only: :show do
    link_to 'Exportar imagenes a Zip', export_images_to_zip_admin_storiette_path(resource)
  end

  action_item :export_images_to_pdf, only: :show do
    link_to 'Exportar imagenes a PDF', export_images_to_pdf_admin_storiette_path(resource)
  end
end
