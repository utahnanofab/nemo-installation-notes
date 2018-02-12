#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

main() {

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

cd /tmp
chmod 755 ./step-03-setup-nemo-app.sh
su nemo - -c ./step-03-setup-nemo-app.sh

echo 'Step 04
======================'

cd /tmp
chmod 755 ./step-04-create-icon.sh
su nemo - -c ./step-04-create-icon.sh

echo 'Step 05
======================'
for i in 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
do
  sleep 1
  echo "Rebooting in $i seconds"
done

reboot

}

main 2>&1 | tee /var/tmp/nemo-install-log.txt
