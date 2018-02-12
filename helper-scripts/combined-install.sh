#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

cd /tmp

echo 'Getting scripts'

wget https://raw.githubusercontent.com/utahnanofab/nemo-installation-notes/master/helper-scripts/step-02-login-and-install-prerequisites.sh
wget https://raw.githubusercontent.com/utahnanofab/nemo-installation-notes/master/helper-scripts/step-03-setup-nemo-app.sh
wget https://raw.githubusercontent.com/utahnanofab/nemo-installation-notes/master/helper-scripts/step-04-create-icon.sh


echo 'Step 02
======================'

. ./step-02-login-and-install-prerequisites.sh

echo 'Step 03
======================'

. ./step-03-setup-nemo-app.sh

echo 'Step 04
======================'

. ./step-04-create-icon.sh

