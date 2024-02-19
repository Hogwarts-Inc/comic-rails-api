require 'fastimage'

class ValidateImageSizeDimensionService

  def self.validate(image)
    return "Solo permitimos estos archivos imagenes: JPEG, PNG or JPG." unless image.present? && image.content_type.in?(['image/jpeg', 'image/png', 'image/jpg'])

    dimensions = FastImage.size(image.tempfile)
    between_width = dimensions[0] <= 1500 && dimensions[0] > 500
    between_height = dimensions[1] <= 1500 && dimensions[1] > 500
    return "Subir imagen que este entre 500x500 a 1500x1500." unless dimensions && between_width && between_height

    square = dimensions[0] == dimensions[1]
    return "Subir imagen que sea cuadrada." unless square

    nil
  end
end
