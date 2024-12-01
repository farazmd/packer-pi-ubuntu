# packer-pi-ubuntu

Packer code base to build/customize Ubuntu raspberry pi server images

## Setup

- Uses the `mkaczanowski/packer-builder-arm` docker image - [info](https://github.com/mkaczanowski/packer-builder-arm)
- Run the following command
    ```shell
        docker run --rm --privileged -v /dev:/dev -v $(pwd):/build mkaczanowski/packer-builder-arm:latest build .
    ```
