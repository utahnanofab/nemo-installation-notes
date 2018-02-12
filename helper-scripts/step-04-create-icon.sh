echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec=python3 ~/python/lib/python3.6/site-packages/NEMO/manage.py runserver
Name=Start NEMO Development Server
Icon=' 
> ~/Desktop/nemo.desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec=firefox http://localhost:8000
Name=Open Firefox for NEMO
Icon=' 
> ~/Desktop/firefox-nemo.desktop

chmod 755 ~/Desktop/nemo.desktop ~/Desktop/firefox-nemo.desktop
mkdir -p ~/.config/autostart


cp ~/Desktop/nemo.desktop ~/Desktop/firefox-nemo.desktop ~/.config/autostart
