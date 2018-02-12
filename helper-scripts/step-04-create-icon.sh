#!/bin/bash

mkdir -p /home/nemo/.config/autostart /home/nemo/Desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec=python3 /home/nemo/python/lib/python3.6/site-packages/NEMO/manage.py runserver
Name=Start NEMO Development Server
Icon=' > /home/nemo/Desktop/nemo.desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=firefox http://localhost:8000
Name=Open Firefox for NEMO
Icon=' > /home/nemo/Desktop/firefox-nemo.desktop

chmod 755 /home/nemo/Desktop/nemo.desktop /home/nemo/Desktop/firefox-nemo.desktop


cp /home/nemo/Desktop/nemo.desktop /home/nemo/Desktop/firefox-nemo.desktop /home/nemo/.config/autostart
