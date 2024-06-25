import os
import numpy as np
from tensorflow.keras.preprocessing import image
from model_definition import create_model

model = create_model()
model.load_weights('/path/to/light_esti.h5')

test_folder = '/path/to/patches'
test_files = os.listdir(test_folder)
predictions_list = []

for filename in test_files:
    img_path = os.path.join(test_folder, filename)
    img = image.load_img(img_path, target_size=(384, 384))
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array /= 255.0
    prediction = model.predict(img_array)
    predictions_list.append(prediction)

predictions_array = np.array(predictions_list)
print("Predictions:", predictions_array)
