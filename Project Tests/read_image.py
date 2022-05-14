# load and show an image with Pillow
from PIL import Image, ImageOps
from numpy import asarray

def get_image_and_template(image_str, template_str):
    dogs = Image.open(image_str)
    template = Image.open(template_str)
    grey_dogs = ImageOps.grayscale(dogs)
    grey_template = ImageOps.grayscale(template)
    dogs_matrix = asarray(grey_dogs)
    template_matrix = asarray(grey_template)
    return dogs_matrix, template_matrix
