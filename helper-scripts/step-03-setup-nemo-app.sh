#!/bin/bash

cd /home/nemo

pip3 install git+https://github.com/usnistgov/NEMO.git@b219bba1166b893b4223d23ed3383fbf54e77fc5 gunicorn
mkdir /home/nemo/{email,media,secrets,logs,nginx,static}
nemo generate_secret_key > secrets/django_secret_key.txt
wget -q -O - https://raw.githubusercontent.com/utahnanofab/nemo-installation-notes/master/helper-scripts/settings.template.py > settings.py

django-admin makemigrations NEMO
django-admin migrate
django-admin collectstatic
# django-admin createsuperuser

#create admin user and load other test data
wget https://raw.githubusercontent.com/utahnanofab/nemo-installation-notes/master/helper-scripts/nemo-fixtures.json
django-admin loaddata nemo-fixtures.json

# gunicorn -b 0.0.0.0:8000 NEMO.wsgi:application
