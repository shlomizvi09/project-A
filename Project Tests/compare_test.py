import numpy as np
from PIL import Image, ImageDraw
import read_image

ROI, template = read_image.get_image_and_template('Dogs gray scale.jpg', 'template 3.jpg')

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
            if row == 0 and col == 0:
                I_input = open("I_input.txt", "w")
                T_input = open("T_input.txt", "w")
                result_output = open("result_output.txt", "w")
                # printing the image into I_input.txt each element in a line for sending it to verilog with $fgets that reads each line at a time
                for row in range(image.shape[0]):
                    for col in range(image.shape[1]):
                        I_input.write(f"{image[row, col]}\n")
                        T_input.write(f"{template[row, col]}\n")
                result_output.write(f"{i_sum} {i_square_sum} {i_x_t1_sum}")
                I_input.close()
                T_input.close()
                result_output.close()
                return
    return I, I_square, I_X_T1

if __name__ == "__main__":
    calc_formula_values(ROI, template)