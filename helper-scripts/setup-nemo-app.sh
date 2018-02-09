#!/bin/bash

cd /home/nemo

pip3 install git+https://github.com/usnistgov/NEMO.git@b219bba1166b893b4223d23ed3383fbf54e77fc5 gunicorn
mkdir /home/nemo/{email,media,secrets,logs,nginx,static}
wget -q -O -  https://gist.github.com/saltlakeryan/5e3b1a2612f973689f25fced3452629/raw > settings.py
nemo generate_secret_key > secrets/django_secret_key.txt

django-admin makemigrations NEMO
django-admin migrate
django-admin createsuperuser
django-admin collectstatic

gunicorn -b 0.0.0.0:8000 NEMO.wsgi:application
