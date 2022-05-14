# load and show an image with Pillow
from PIL import Image, ImageOps
import numpy as np

def get_image_and_template(image_str, template_str):
    dogs = Image.open(image_str)
    template = Image.open(template_str)
    grey_dogs = ImageOps.grayscale(dogs)
    grey_template = ImageOps.grayscale(template)
    dogs_matrix = np.asarray(grey_dogs, dtype=np.uint32)
    template_matrix = np.asarray(grey_template, dtype=np.uint32)
    return dogs_matrix, template_matrix
