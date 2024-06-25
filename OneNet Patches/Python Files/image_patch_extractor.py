import os
from PIL import Image
import cv2

def extract_patches_pil(input_image_path, patch_size=100, output_folder='patches'):
    # Read the image using PIL
    image = Image.open(input_image_path)
    cols, rows = image.size

    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    patch_count = 1
    for i in range(0, rows, patch_size):
        for j in range(0, cols, patch_size):
            if (i+patch_size <= rows) and (j+patch_size <= cols):
                patch = image.crop((j, i, j+patch_size, i+patch_size))
                patch.save(f'{output_folder}/patch_{patch_count}.png')
                patch_count += 1

def extract_patches_opencv(input_image_path, patch_size=100, output_folder='patches'):
    # Read the image using OpenCV
    image = cv2.imread(input_image_path)
    rows, cols, channels = image.shape

    os.makedirs(output_folder, exist_ok=True)
    patch_count = 1

    for i in range(0, rows, patch_size):
        for j in range(0, cols, patch_size):
            row_end = min(i+patch_size, rows)
            col_end = min(j+patch_size, cols)
            patch = image[i:row_end, j:col_end, :]
            patch_file_name = os.path.join(output_folder, f'patch_{patch_count}.png')
            cv2.imwrite(patch_file_name, patch)
            patch_count += 1
