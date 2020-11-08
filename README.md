# License Plate Recognizer
The main motivation of the project is implementing an API which, takes an Image as input and try to recognize license plates on the image and return recognized license plates as response

For license plate recognition, it uses [OpenAlpr library](https://github.com/openalpr/openalpr). 

# Usage
* (only for one time) build base docker image
    ```bash
    docker build -f Dockerfile.base -t license-plate-recognizer-base:dev --no-cache .
    ```
* build image and run container
    ```bash
    docker-compose up -d --build
    ```
* to stop;
    ```bash
    docker-compose stop
    ```
* to remove;
    ```bash
    docker-compose down
    ```
* An then, open following url on your browser \
  [localhost:9090](http://localhost:9090/)
* Upload an **jpg** image and wait for results