import time
from matplotlib import projections

import numpy as np
from PIL import Image, ImageDraw
import read_image
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# possible templates: template.jpg, template 2.jpg, template 3.jpg. need to change the input name for different simulation
ROI, template = read_image.get_image_and_template('Dogs gray scale.jpg', 'template 2.jpg', add_noise=True)

TEMPLATE_ROW_SIZE, TEMPLATE_COL_SIZE = template.shape
ROI_ROW_SIZE, ROI_COL_SIZE = ROI.shape
N = TEMPLATE_COL_SIZE * TEMPLATE_COL_SIZE
ROW_ITERATION_SIZE = ROI_ROW_SIZE - TEMPLATE_ROW_SIZE + 1
COL_ITERATION_SIZE = ROI_COL_SIZE - TEMPLATE_COL_SIZE + 1

template_square = np.multiply(template, template)
B_1 = template.sum()
D_1 = np.sqrt(abs(N * template_square.sum() - B_1 ** 2))

def get_image_from_ROI(ROI, row_start, row_end, col_start, col_end):
    return ROI[row_start:row_end, col_start:col_end].copy()

def calc_formula_values(ROI, template):
    I, I_square = np.zeros((ROW_ITERATION_SIZE, COL_ITERATION_SIZE)), np.zeros((ROW_ITERATION_SIZE, COL_ITERATION_SIZE))
    I_X_T1 = np.zeros((ROW_ITERATION_SIZE, COL_ITERATION_SIZE))
    for row in range(ROW_ITERATION_SIZE):
        for col in range(COL_ITERATION_SIZE):
            image = get_image_from_ROI(ROI, row, row + TEMPLATE_ROW_SIZE, col, col + TEMPLATE_COL_SIZE)
            i_sum = image.sum()
            i_square = np.multiply(image, image)
            i_square_sum = i_square.sum()
            i_x_t1 = np.multiply(image, template)
            i_x_t1_sum = i_x_t1.sum()
            I[row, col], I_square[row, col], I_X_T1[row, col] \
                = i_sum, i_square_sum, i_x_t1_sum
    return I, I_square, I_X_T1

def calc_result_matrix(I, I_square, I_X_T1):
    result_matrix = np.zeros((ROW_ITERATION_SIZE, COL_ITERATION_SIZE))
    for row in range(ROW_ITERATION_SIZE):
        for col in range(COL_ITERATION_SIZE):
            result_matrix[row, col] = (N * I_X_T1[row, col] - B_1 * I[row, col]) / (
                        D_1 * np.sqrt(abs(N * I_square[row, col] - I[row, col] ** 2)))

    return result_matrix

if __name__ == "__main__":
    # formula_values will contain [C, E, A] mentioned in the article's formula
    start_time = time.time()
    formula_values = calc_formula_values(ROI, template)
    print(f"calc formula values took: {time.time() - start_time} seconds")

    #result matrix is R(x,y) for each template, in this case only 1 template
    start_time = time.time()
    result_matrix = calc_result_matrix(formula_values[0], formula_values[1], formula_values[2])
    print(f"calc result matrix values took: {time.time() - start_time} Seconds")

    h, w = result_matrix.shape
    plt.figure(figsize=(16, 8))
    ax = plt.axes(projection='3d')
    X, Y = np.meshgrid(np.arange(w), np.arange(h))
    ax.plot_surface(X, Y, result_matrix, rstride=1, cstride=1, cmap='Blues', edgecolor='none', antialiased=False)
    plt.show()
    # index of maximum value in R(x,y) flattened
    max_index = np.argmax(result_matrix)

    # parsing row and col of maximum index
    max_row = max_index // COL_ITERATION_SIZE
    max_col = max_index % COL_ITERATION_SIZE

    print(f"Max value = {result_matrix[max_row,max_col]}")

    # draw a rect around the template in the ROI
    with Image.open('Dogs gray scale.jpg') as im:
        draw=ImageDraw.Draw(im)
        draw.rectangle([max_col,max_row,max_col+TEMPLATE_COL_SIZE, max_row+TEMPLATE_ROW_SIZE])
        im.save("result.jpg")
        im.show()
        im.close()