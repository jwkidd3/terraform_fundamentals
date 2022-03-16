#!/bin/bash

export TF_VAR_pgp_key=$(gpg --export "Dave Wade-Stein" | base64)
terraform init
terraform $@
