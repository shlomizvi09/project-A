import numpy as np
import time
import read_image

ROI = np.array([[152, 233, 214, 233, 175, 229, 138, 134, 105, 205, 153, 9, 9,
                 143, 163, 151, 125, 69, 3, 253],
                [50, 101, 94, 180, 245, 253, 197, 37, 250, 0, 234, 8, 71,
                 11, 254, 4, 90, 54, 48, 218],
                [158, 180, 143, 98, 88, 177, 115, 151, 97, 150, 68, 83, 164,
                 182, 19, 51, 120, 129, 49, 46],
                [17, 42, 196, 45, 163, 76, 208, 165, 30, 216, 107, 75, 221,
                 45, 67, 70, 10, 224, 200, 217],
                [144, 8, 27, 10, 65, 168, 3, 182, 109, 20, 2, 68, 23,
                 129, 131, 171, 226, 103, 143, 3],
                [175, 108, 6, 52, 25, 92, 74, 31, 72, 3, 239, 189, 144,
                 246, 123, 41, 34, 188, 154, 112],
                [148, 35, 220, 90, 198, 211, 76, 175, 132, 151, 234, 154, 234,
                 107, 172, 151, 107, 243, 190, 196],
                [12, 62, 58, 209, 5, 37, 68, 149, 209, 55, 199, 30, 160,
                 159, 216, 183, 151, 113, 194, 32],
                [62, 130, 31, 217, 218, 175, 33, 21, 67, 102, 89, 4, 254,
                 13, 17, 250, 179, 26, 59, 154],
                [190, 49, 121, 211, 212, 245, 60, 122, 157, 244, 189, 182, 72,
                 162, 22, 67, 130, 157, 48, 224]])
TEMPLATE_ROW_SIZE = 3
TEMPLATE_COL_SIZE = 7
ROI_ROW_SIZE = 10
ROI_COL_SIZE = 20
N = TEMPLATE_COL_SIZE * TEMPLATE_COL_SIZE

# crate templates
sub_matrix = ROI[3:3 + TEMPLATE_ROW_SIZE, 5:5 + TEMPLATE_COL_SIZE]
template_1 = sub_matrix.copy()
template_2 = sub_matrix.copy()

# add randomness to templates to set them apart
with np.nditer(template_1, op_flags=['readwrite']) as it:
    for x in it:
        if x > 5 and x < 250:
            x[...] += np.random.randint(-4, 4)
with np.nditer(template_2, op_flags=['readwrite']) as it:
    for x in it:
        if x > 5 and x < 250:
            x[...] += np.random.randint(-4, 4)

template_1_square = np.multiply(template_1, template_1)
template_2_square = np.multiply(template_2, template_2)
B_1 = template_1.sum()
B_2 = template_2.sum()
D_1 = np.sqrt(N * template_1_square.sum() - B_1 ** 2)
D_2 = np.sqrt(N * template_2_square.sum() - B_2 ** 2)


def get_image_from_ROI(ROI, row_start, row_end, col_start, col_end):
    return ROI[row_start:row_end, col_start:col_end].copy()


def calc(ROI, template_1, template_2):
    I, I_square, I_X_T1, I_X_T2 = np.zeros((8, 14)), np.zeros((8, 14)), np.zeros((8, 14)), np.zeros((8, 14))
    for row in range(ROI_ROW_SIZE - TEMPLATE_ROW_SIZE + 1):
        for col in range(ROI_COL_SIZE - TEMPLATE_COL_SIZE + 1):
            image = get_image_from_ROI(ROI, row, row + TEMPLATE_ROW_SIZE, col, col + TEMPLATE_COL_SIZE)
            i_sum = image.sum()
            i_square = np.multiply(image, image)
            i_square_sum = i_square.sum()
            i_x_t1 = np.multiply(image, template_1)
            i_x_t1_sum = i_x_t1.sum()
            i_x_t2 = np.multiply(image, template_2)
            i_x_t2_sum = i_x_t2.sum()
            I[row, col], I_square[row, col], I_X_T1[row, col], I_X_T2[row, col] \
                = i_sum, i_square_sum, i_x_t1_sum, i_x_t2_sum
    return I, I_square, I_X_T1, I_X_T2


def final_calc(I, I_square, I_X_T1, I_X_T2):
    ans_t1 = np.zeros((8, 14))
    ans_t2 = np.zeros((8, 14))
    for row in range(8):
        for col in range(14):
            ans_t1[row, col] = (N * I_X_T1[row, col] - B_1 * I[row, col]) / (
                        D_1 * np.sqrt(N * I_square[row, col] - I[row, col] ** 2))
            ans_t2[row, col] = (N * I_X_T2[row, col] - B_2 * I[row, col]) / (
                        D_2 * np.sqrt(N * I_square[row, col] - I[row, col] ** 2))
    return ans_t1, ans_t2

start = time.time()
ans = calc(ROI, template_1, template_2)
final = final_calc(ans[0], ans[1], ans[2], ans[3])
end = time.time()
print(f"Total time for image correlation with 2 templates: {end-start} seconds")
print("Done")
