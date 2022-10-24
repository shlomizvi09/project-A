# load and show an image with Pillow
from PIL import Image, ImageOps, ImageFilter
import numpy as np

def get_image_and_template(image_path, template_path, add_noise=False):
    dogs = Image.open(image_path)
    template = Image.open(template_path)
    if add_noise:
        template = template.filter(ImageFilter.GaussianBlur(3))
        template.show()
        template.save("noised_template.jpg")
    grey_dogs = ImageOps.grayscale(dogs)
    grey_template = ImageOps.grayscale(template)
    dogs_matrix = np.asarray(grey_dogs, dtype=np.uint32)
    template_matrix = np.asarray(grey_template, dtype=np.uint32)

    return dogs_matrix, template_matrix
