import numpy as np
import os

def main():
    
    project_path =  os.getcwd()
    data_folder = 'dataset/'
    print('Loading data')
    with np.load(os.path.join(project_path, data_folder, "mnist.npz"), allow_pickle=True) as file:
        x_train, y_train = file['x_train'], file['y_train']
        x_test, y_test = file['x_test'], file['y_test']

    print('Preprocessing data')
    x_train, x_test = x_train / 255.0, x_test / 255.0

    # Write output files to Valohai outputs directory
    # This enables Valohai to version your data
    # and upload output it to the default data store

    print('Saving preprocessed data')
    save_path = os.path.join(project_path, data_folder, "preprocessedmnist3.npz")
    np.savez_compressed(save_path, x_train=x_train, y_train=y_train, x_test=x_test, y_test=y_test)


if __name__ == '__main__':
    main()