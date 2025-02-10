#!/bin/bash
read -p "Escribe la ruta absoluta donde tengas tu proyecto (el directorio)" ruta
read -p "Escribe el nuevo nombre que le quieres dar a la carpeta" nombre
read -p "Introduce el nombre del ServerAdmin (Ejemplo: root@ajemplo.com)" svadmin
read -p "Introduce el nombre del server (Ejemplo: ejemplo.com)" svname
read -p "Aqui Introduce el alias de servidor (Ejemplo: www.ejemplo.es)" svalias
read -p "Introduce el nombre del index de tu página web" index
sudo apt install apache2 -y
mv $ruta /var/www/$nombre
sudo chmod -R 755 >/var/www/$nombre
