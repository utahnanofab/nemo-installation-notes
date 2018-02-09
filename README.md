# Nemo Installation Notes

I put together some notes on getting a development version of
NEMO up and running.  Thought I would share those notes for 
anyone who might find them useful.  Most of the information 
comes directly from the NEMO repo (https://github.com/usnistgov/NEMO).

A note on security: I am not following security measures for this setup. I only am getting it up and running for testing purposes.

## Step 1. Setup Ubuntu 16.04 in a VM (VirtualBox)

I downloaded a pre-installed ubuntu virtual machine from osboxes.org:

https://www.osboxes.org/ubuntu/

default username/password is osboxes/osboxes.org

## Step 2. Login and Install Prerequisites

*This step can be run automatically with script: https://raw.githubusercontent.com/utahnanofab/nemo-installation-notes/master/helper-scripts/step-02-login-and-install-prerequisites.sh*

After logging in, install prerequisites with apt in terminal window:
```
sudo su #become root user
apt-get update
apt-get install -y zlib1g-dev git curl vim gcc wget sqlite3 openssl git unzip build-essential checkinstall \
                        libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
```

Create "nemo" user (with "nemo" password) for running NEMO:
```
useradd -m -s /bin/bash --comment "NEMO" nemo
echo nemo:nemo | chpasswd
```

Install python as nemo user into nemo user's home directory:
```
su nemo - # become nemo
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
```

Make nemo user login automatically, and give nemo sudo powers (this part is unnecessary, but convenient for working in the VM):

```
# SET nemo as default user and automatically login as nemo when rebooted
echo '[Seat:*]
autologin-user=nemo
' > /etc/lightdm/lightdm.conf

gpasswd -a nemo nopasswdlogin

# DON'T REQUIRE PASSWORD TO USE SUDO
echo 'nemo ALL=NOPASSWD: ALL' |  EDITOR='tee -a' visudo

```

## Step 3. Set up the NEMO app

Login as the nemo user and open a terminal so we can install NEMO and its dependencies using pip:

I am installing NEMO at a specific commit in case later versions require different steps:
```
cd /home/nemo
pip3 install git+https://github.com/usnistgov/NEMO.git@b219bba1166b893b4223d23ed3383fbf54e77fc5 gunicorn
```

Create directory structure and secret key:
```
mkdir /home/nemo/{email,media,secrets,logs,nginx,static}
nemo generate_secret_key > secrets/django_secret_key.txt
```

Download settings template (with insecure authentication backend settings)
```
wget -q -O - https://raw.githubusercontent.com/utahnanofab/nemo-installation-notes/master/helper-scripts/settings.template.py > settings.py
```

Create migrations and collect static file assets:
```
django-admin makemigrations NEMO
django-admin migrate
django-admin collectstatic
```

Here you might create a super user with "django-admin createsuperuser", but I'm actually going to skip that step and import a bunch of test data that includes a super user:

```
wget https://raw.githubusercontent.com/utahnanofab/nemo-installation-notes/master/helper-scripts/nemo-fixtures.json
django-admin loaddata nemo-fixtures.json

```

Add an authenticator to the application that allows any user to login with any password.  Obviously, this is very insecure, but it allows us to get up and running for testing purposes.  Later, this should be changed to a normal auth backend.

This backend has already been set up as the default authentication engine in the settings.py file we downloaded earlier.
```
wget -O /home/nemo/python/lib/python3.6/site-packages/NEMO/views/fake_authentication.py https://raw.githubusercontent.com/utahnanofab/nemo-installation-notes/master/helper-scripts/fake_authentication.py
```

