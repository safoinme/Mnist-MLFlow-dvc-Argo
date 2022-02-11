import numpy as np
from PIL import ImageOps
from PIL import Image
import json
import requests
import os 

def process_image(image):
    # Resize the image to MNIST size 28 x 28 pixels
    image = image.resize((28, 28))

    # Make the image grayscale
    image = image.convert('L')

    # If the image looks like it's dark-on-white, invert it first
    inverted = image.getpixel((0, 0)) > 192
    if inverted:
        print('Inverting image')
        image = ImageOps.invert(image)

    # Transform the image into a NumPy array
    image_data = np.array(image)

    # Normalize the pixel values from 0-255 to 0.0-1.0
    image_data = image_data / 255.0

    return image_data.reshape((1, 28, 28)), inverted


if __name__ == '__main__':
    image, inverted = process_image(Image.open("five.jpeg")) 
    #with open('mnist-input.json', 'w') as f:
    #    json.dump({"instances": image.tolist()},f)
    data = json.dumps({"signature_name": "serving_default", "instances": image.tolist()})
    headers = {"content-type": "application/json","Host":"mnist-example-s3.kserve-deployement.example.com".format(os.environ["SERVICE_HOSTNAME"])}
    json_response = requests.post("http://{}:{}/v1/models/mnist-example-s3:predict".format(os.environ["INGRESS_HOST"],os.environ["INGRESS_PORT"]), data=data, headers=headers)
    predictions = json.loads(json_response.text)['predictions']
    print(predictions)
    print(np.argmax(predictions[0]))

#SERVICE_HOSTNAME=$(kubectl get inferenceservice mnist-example-s3 -n kserve-deployement -o jsonpath='{.status.url}' | cut -d "/" -f 3)
#curl -v -H "Host: ${SERVICE_HOSTNAME}" http://${INGRESS_HOST}:${INGRESS_PORT}/v1/models/mnist-example-s3:predict -d @./mnist-input.json
