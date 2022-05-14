import numpy as np
import time
import read_image
import test

ROI, template = read_image.get_image_and_template('Dogs.jpg', 'template.JPG')

TEMPLATE_ROW_SIZE, TEMPLATE_COL_SIZE = template.shape
ROI_ROW_SIZE, ROI_COL_SIZE = ROI.shape
N = TEMPLATE_COL_SIZE * TEMPLATE_COL_SIZE

template_square = np.multiply(template, template)
B_1 = template.sum()
D_1 = np.sqrt(N * template_square.sum() - B_1 ** 2)

ans = test.calc(ROI, template, template)

def final_calc(I, I_square, I_X_T1, I_X_T2):
    ans_t1 = np.zeros((8, 14))
    ans_t2 = np.zeros((8, 14))
    for row in range(8):
        for col in range(14):
            ans_t1[row, col] = (N * I_X_T1[row, col] - B_1 * I[row, col]) / (
                        D_1 * np.sqrt(N * I_square[row, col] - I[row, col] ** 2))

    return ans_t1, ans_t2

final = final_calc(ans[0], ans[1], ans[2], ans[3])

# print(template.shape)
print("Done")