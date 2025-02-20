#!/bin/bash

if [[ -z $1 ]]; then
        echo "Utilice los parametros correctos: --, --, --"
else
        if [[ "$1" == "--help" ]]; then
                echo "Escribe la ruta absoluta donde tengas tu proyecto (el directorio)" ruta
                echo "Escribe el nuevo nombre que le quieres dar a la carpeta" nombre
                echo "Introduce el nombre del ServerAdmin (Ejemplo: root@ajemplo.com)" svadmin
                echo "Introduce el nombre del server (Ejemplo: ejemplo.com)" svname
                echo "Aqui Introduce el alias de servidor (Ejemplo: www.ejemplo.es)" svalias
                echo "Introduce el nombre del index de tu página web" index
        elif [[ "$1" == "--install" ]]; then
                if [[ $# !=  ]]; then
                        echo "La sintaxis para -- es incorrecta, consulte --help"
                else
                        sudo apt install apache2
                fi
fi
