#!/bin/bash

##############################
### Run as Root: "sudo su" ###
##############################

# INSTALL PREREQUISITES
apt-get update
apt-get install -y zlib1g-dev git curl vim gcc wget sqlite3 openssl git unzip build-essential checkinstall \
			libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev

# CREATE NEMO USER with "nemo" as password
useradd -m -s /bin/bash --comment "NEMO" nemo
echo nemo:nemo | chpasswd

# SET nemo as default user and automatically login as nemo when rebooted
echo '[Seat:*]
autologin-user=nemo
' > /etc/lightdm/lightdm.conf

gpasswd -a nemo nopasswdlogin

# DON'T REQUIRE PASSWORD TO USE SUDO
echo 'nemo ALL=NOPASSWD: ALL' |  EDITOR='tee -a' visudo

# CREATE SHELL SCRIPT TO RUN AS "nemo" USER (installs python)
cat <<EOF > /tmp/runasnemo.sh
#!/bin/bash

cd /home/nemo
wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tgz
tar xf Python-3.6.4.tgz
cd Python-3.6.4/
./configure --prefix=/home/nemo/python
make
make install
cd /home/nemo
rm -rf Python-3.6.4 Python-3.6.4.tgz

echo 'PATH=/home/nemo/python/bin:/home/nemo/nginx:$PATH
PYTHONPATH=/home/nemo
DJANGO_SETTINGS_MODULE=settings
export PATH PYTHONPATH DJANGO_SETTINGS_MODULE' >> /home/nemo/.profile

. /home/nemo/.profile

EOF

# RUN SHELL SCRIPT
su nemo - -c 'sh /tmp/runasnemo.sh'
