class ValidateImageSizeDimensionService

  def self.validate(base64_image)
    image_data = Base64.decode64(base64_image)
    image = MiniMagick::Image.read(image_data)

    # Validar dimensiones de la imagen
    max_width = 1024
    max_height = 1024

    if (image.width && image.width > max_width) || (image.height && image.height) > max_height
      return false
    end

    # Validar tamaño de la imagen
    max_size = 2.megabytes
    if image_data.size && image_data.size > max_size
      return false
    end

    # La imagen cumple con los requisitos
    true
  end
end
