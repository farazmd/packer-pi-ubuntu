# packer-pi-ubuntu

Packer code base to build/customize Ubuntu raspberry pi server images

## Overview

The project makes use of the [Ubuntu Raspberry Pi server images](https://ubuntu.com/download/raspberry-pi) to build custom image files
to run on the raspberry-pi platform.

## Setup

- Uses the `mkaczanowski/packer-builder-arm` docker image - [info](https://github.com/mkaczanowski/packer-builder-arm)
- Uses the [ansible-role-os-user](https://github.com/farazmd/ansible-role-os-user) to create the admin user.
- Create a `ubuntu.auto.pkrvars.hcl` file with the following required variables
  ```shell
    image_name = <output name of the image>
    base_dir_name = <a custom directory to store config and tool>
    admin_user = <admin user to create to access to server>
    admin_user_group = <admin user group to create>
    additional_groups = <a list of additional groups to add to the admin user>. eg - ["sudo"]
    ssh_pub_key = <the ssh public key to add to the authorized_keys of the admin user>
    no_cloud_url = <cloud init's NoCloud Datasource url to provide runtime cloud init config. Will fallback to default cloud init config if does not exists>
    no_cloud_file_path = <local cloud-init userdata and metadata path. Falls back to this if no_cloud_url does not exist>
  ```
- Create a directory called `images`. This is where the final build images will be stored.
- Run the following command
    ```shell
        docker run --rm --privileged -v /dev:/dev -v $(pwd):/build mkaczanowski/packer-builder-arm:latest build .
    ```

- Once the image is created, you can write the file to an SD card and run it on a raspberry-pi.
- Connect to the raspberry-pi via ssh using the private key and `admin_user`

## Configuration

- You can add additional shell execution scripts as needed or modify existing ones to add more tools, etc
- You can also customize [NoCloud Configuration](https://cloudinit.readthedocs.io/en/latest/reference/datasources/nocloud.html) as needed.
  - There are 3 configs present
    - nocloud with user creation
    - nocloud with no user creation
    - no cloud with just the datasource defined
