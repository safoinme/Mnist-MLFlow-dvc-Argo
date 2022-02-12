import uuid
import numpy as np
import tensorflow as tf
import os
import mlflow.keras
import mlflow

def main():
    project_path =  os.getcwd()
    data_folder = 'dataset/'
    input_path = os.path.join(project_path, data_folder, "preprocessedmnist3.npz")


    with np.load(input_path, allow_pickle=True) as f:
        x_train, y_train = f['x_train'], f['y_train']
        x_test, y_test = f['x_test'], f['y_test']

    model = tf.keras.models.Sequential([
        tf.keras.layers.Flatten(input_shape=(28, 28)),
        tf.keras.layers.Dense(128, activation='relu'),
        tf.keras.layers.Dropout(0.2),
        tf.keras.layers.Dense(10),
    ])

    optimizer = tf.keras.optimizers.Adam(learning_rate=0.002)
    loss_fn = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)
    model.compile(optimizer=optimizer,
                  loss=loss_fn,
                  metrics=['accuracy'])

    # Print metrics out as JSON
    # This enables Valohai to version your metadata
    # and for you to use it to compare experiments
    mlflow.keras.autolog()
    results = model.fit(x_train, y_train, epochs=20,validation_data=(x_test, y_test))

    #with mlflow.start_run() as run:
    #    mlflow.keras.lpipog_model(model, "mnist-keras")

    #suffix = uuid.uuid4()
    #output_path = valohai.outputs().path(f'model-{suffix}.h5')
    #model.save(output_path)


if __name__ == '__main__':
    mlflow.set_experiment("mnist-example")
    main()