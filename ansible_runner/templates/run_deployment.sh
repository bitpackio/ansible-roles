#!/bin/ksh
HOME={{ ansible_runner_home }}
DEPLOYMENT_DIR=$HOME/{{ deployment.name }}

cd $DEPLOYMENT_DIR && \
    git pull && \
    {{ ansible_runner_command }}
