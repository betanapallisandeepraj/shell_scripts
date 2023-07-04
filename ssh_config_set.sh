#!/bin/bash
#improve ssh connection
improve_ssh() {
  if [[ ! -f ~/.ssh/config ]]; then
    touch ~/.ssh/config
    mkdir -p ~/.ssh/controlmasters
    echo "Host *" >~/.ssh/config
    echo -e "\tStrictHostKeyChecking no" >>~/.ssh/config
    echo -e "\tControlPersist 60m" >>~/.ssh/config
    echo -e "\tControlMaster auto" >>~/.ssh/config
    echo -e "\tControlPath ~/.ssh/controlmasters/%C" >>~/.ssh/config
    chmod 400 ~/.ssh/config
  fi
}
improve_ssh
