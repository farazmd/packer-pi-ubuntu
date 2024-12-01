#!/bin/bash

# Custom base directory
export BASE_DIR="/${BASE_DIR_NAME}"

source "${BASE_DIR}/tools/pyenv/bin/activate"

cd "${BASE_DIR}/setup"
tar xvf ansible-playbook-create-user.tgz

cd ansible-playbook-create-user
mv "${BASE_DIR}/setup/createuser.yml" .

ansible-playbook playbook.yml --extra-vars "@createuser.yml"

rm -rf createuser.yml
