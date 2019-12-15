#!/bin/bash

docker run -it --rm -h=kclient --name kclient --privileged --env-file=env --net=jenkins -v kdc.example.at.etc_kerb5_conf_d:/etc/kerb5.conf.d:ro kerb5 bash
