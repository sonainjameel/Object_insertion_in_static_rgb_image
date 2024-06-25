import tensorflow as tf
from tensorflow.keras import layers, models

def create_model():
    model = models.Sequential([
        layers.InputLayer(input_shape=(384, 384, 3)),
        layers.Conv2D(64, (1, 1), activation='relu', padding='same'),
        layers.MaxPooling2D(pool_size=(8, 8)),
        layers.Conv2D(64, (1, 1), activation='relu', padding='same'),
        layers.MaxPooling2D(pool_size=(8, 8)),
        layers.Conv2D(128, (1, 1), activation='relu', padding='same'),
        layers.Conv2D(64, (1, 1), activation='relu', padding='same'),
        layers.Dropout(0.5),
        layers.Conv2D(3, (1, 1), activation='relu', padding='same'),
        layers.GlobalAveragePooling2D(),
        layers.Dense(3)
    ])
    return model
