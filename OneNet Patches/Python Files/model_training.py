import tensorflow as tf
from model_definition import create_model

def custom_loss(y_true, y_pred):
    return tf.reduce_mean(tf.square((y_pred - y_true) / y_true))

model = create_model()
optimizer = tf.optimizers.AdamW(learning_rate=2e-3, weight_decay=5e-5)
model.compile(optimizer=optimizer, loss=custom_loss)

class CyclicLR(tf.keras.callbacks.Callback):
    def __init__(self, max_lr, min_lr, half_cycle):
        self.max_lr = max_lr
        self.min_lr = min_lr
        self.half_cycle = half_cycle
        self.iteration = 0
        super(CyclicLR, self).__init__()

    def on_epoch_begin(self, epoch, logs=None):
        cycle = tf.floor(1 + self.iteration / (2 * self.half_cycle))
        x = tf.abs(self.iteration / self.half_cycle - 2 * cycle + 1)
        new_lr = self.min_lr + (self.max_lr - self.min_lr) * tf.maximum(0, (1 - x))
        self.iteration += 1
        self.model.optimizer.learning_rate.assign(new_lr)

# Example usage of CyclicLR
# model.fit(..., callbacks=[CyclicLR(max_lr=0.1, min_lr=0.01, half_cycle=10)])
