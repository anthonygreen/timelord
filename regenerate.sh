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

function generate_secrets_file
{

  read -e -p "Enter your BBC email address: " BBC_EMAIL_ADDRESS

  read -e -p "Enter your BBC login id: " BBC_LOGIN_ID

  read -e -p "Enter the full path to a Forge developer certificate:" FORGE_CERTIFICATE_FILEPATH

  read -s -e -p "Enter your Forge certificate password: " FORGE_CERTIFICATE_PASSWORD

  if [[ ! -x $FORGE_CERTIFICATE_FILEPATH ]]; then
    FORGE_CERTIFICATE_B64=$(base64 -i $FORGE_CERTIFICATE_FILEPATH)
  fi

  if [[ ! -x ./secrets.yml ]]; then
    cat > ./secrets.yml <<- _EOF_
---

accounts:
  bbc:
    username: $BBC_LOGIN_ID
    email: $BBC_EMAIL_ADDRESS
    developer_certificate:
      password: $FORGE_CERTIFICATE_PASSWORD
      content:
        base64_encoded: $FORGE_CERTIFICATE_B64
_EOF_
  fi

  ansible-vault encrypt ./secrets2.yml

}

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

while true; do
  read -p "Do you wish to generate an encrypted secrets file? " yn
    case $yn in
      [Yy]* ) $(generate_secrets_file); break;;
      [Nn]* ) break;;
      * ) echo "Please answer yes or no.";;
  esac
done

echo "Running Ansible"
ansible-playbook workstation.yml
