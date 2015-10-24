#!/bin/bash

cat <<-_EOF_
 ______ _             __               __
/_  __/(_)__ _  ___  / /___   ____ ___/ /
 / /  / //  ' \/ -_)/ // _ \ / __// _  /
/_/  /_//_/_/_/\__//_/ \___//_/   \_,_/

Regenerate a BBC OS X developer workstation from a AtoS base image.
See README for details

_EOF_


while true; do
  read -p "Do you have elevated admin rights to this machine? " yn
    case $yn in
      [Yy]* ) break;;
      [Nn]* ) echo 'Sorry you require admin rights to run this installer'; exit;;
      * ) echo "Please answer yes or no.";;
  esac
done

if [[ ! -x /usr/bin/gcc ]]; then
  echo "Installing Command Line Tools"
  xcode-select --install
fi

if [[ ! -x /usr/local/bin/brew ]]; then
  echo "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

export PATH=/usr/local/bin:$PATH

if [[ ! -x /usr/local/bin/python ]]; then
  echo "Installing python"
  brew install python
fi

if [[ ! -x /usr/local/bin/pip ]]; then
  echo "Installing python pip"
  python "$(curl -fsSL https://bootstrap.pypa.io/get-pip.py)"
fi

if [[ ! -x /usr/local/lib/python2.7/site-packages/jinja2 ]]; then
  echo "Installing Ansible dependency: jinja2"
  pip install jinja2
fi

if [[ ! -x /usr/local/lib/python2.7/site-packages/yaml ]]; then
  echo "Installing Ansible dependency: pyyaml"
  pip install pyyaml
fi

if [[ ! -x /usr/local/bin/ansible ]]; then
  echo "Installing Ansible"
  brew install ansible
fi
