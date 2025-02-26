#!/bin/bash
# Faltaban algunos fi, H epuesto un puerto por defecto para --docker
if [[ -z $1 ]]; then
        echo "Utilice los parametros correctos: --help para ver la información de los comandos"
        else
            if [[ "$1" == "--help" ]]; then
                    echo "La sintaxis para usar este script es [script] --[variable]"
                    echo "Solo se adminten las variables listadas:"
                    echo "Si quiere INSTALAR SOLAMENTE apache utilicé el parámetro --install"
                    echo "Si quieres CONFIGURAR el servicio apache utiliza --config"
                    echo "Si quieres ver los LOGS puedes usar --logs"
                    echo "Si quieres DETENER el servicio apache utiliza --stop"
                    echo "Si quieres INICIAR el servicio apache utiliza --start"
                    echo "Si quieres ver el ESTADO del servicio apache utiliza --status"
                    echo "Si quieres REINICIAR el servicio apache utiliza --restart"
                    echo "Si quieres DESINSTALAR el servicio apache utiliza --uninstall"
                    echo "Si quieres INICIAR el servicio apache con DOCKER utiliza --docker"
                    echo "Si quieres DETENER el DOCKERde apache entonces utiliza --dkstop"
            elif [[ "$1" == "--install" ]]; then
                    if [[ $# !=  1 ]]; then
                            echo "La sintaxis para -- es incorrecta, consulte --help"
                    else
                            sudo apt install apache2 -y
                            sudo touch midominio.conf
                            echo "<VirtualHost *:80>" | sudo tee midominio.conf
                            echo "ServerName Ejemplo" | sudo tee -a midominio.conf
                            echo "ServerAlias Ejemplo" | sudo tee -a midominio.conf
                            echo "DocumentRoot /var/www/" | sudo tee -a midominio.conf
                            echo "DirectoryIndex Ejemplo" | sudo tee -a midominio.conf
                            echo "</VirtualHost>" | sudo tee -a midominio.conf
                            sudo mv midominio.conf /etc/apache2/sites-available/midominio.conf
                            sudo a2dissite /etc/apache2/sites-available/000-default.conf
                            sudo a2ensite /etc/apache2/sites-available/midominio.conf
                    fi
            elif [[ "$1" == "--logs" ]]; then
                    if [[ $# !=  1 ]]; then
                            echo "La sintaxis para -- es incorrecta, consulte --help"
                    else
                            journalctl -u apache2 --no-pager
                    fi
            elif [[ "$1" == "--stop" ]]; then
                    if [[ $# !=  1 ]]; then
                            echo "La sintaxis para -- es incorrecta, consulte --help"
                    else
                            sudo systemctl stop apache2
                    fi
            elif [[ "$1" == "--start" ]]; then
                    if [[ $# !=  1 ]]; then
                            echo "La sintaxis para -- es incorrecta, consulte --help"
                    else
                            sudo systemctl start apache2
                    fi
            elif [[ "$1" == "--restart" ]]; then
                    if [[ $# !=  1 ]]; then
                            echo "La sintaxis para -- es incorrecta, consulte --help"
                    else
                            sudo systemctl restart apache2
                    fi
            elif [[ "$1" == "--uninstall" ]]; then
                    if [[ $# !=  1 ]]; then
                            echo "La sintaxis para -- es incorrecta, consulte --help"
                    else
                            sudo apt remove apache2 -y
                    fi
            elif [[ "$1" == "--status" ]]; then
                    if [[ $# !=  1 ]]; then
                            echo "La sintaxis para -- es incorrecta, consulte --help"
                    else
                            sudo systemctl status apache2
                    fi
            elif [[ "$1" == "--config" ]]; then
                    if [[ $# !=  1 ]]; then
                            echo "La sintaxis para -- es incorrecta, consulte --help"
                    else
                            echo "1. Cambiar el puerto de Apache"
                            echo "2. Cambiar dominio principal"
                            echo "3. "
                            echo "4. "
                            echo "5. "
                            read -p "Escribe en número para elegir la opción" opcion
                            if [[ $opcion == "1" ]]; then
                                read -p "Dime que puerto quieres que tenga apache" puerto
                                sudo sed -i "s/^Listen [0-9]\+/Listen $puerto/" /etc/apache2/ports.conf
                                sudo ufw allow $puerto/tcp
                                echo "Debes reiniciar Apache para aplicar cambios, recuerda usar --restart"
                            fi
                    fi
            elif [[ "$1" == "--ansible" ]]; then
                    if [[ $# !=  1 ]]; then
                            echo "La sintaxis para -- es incorrecta, consulte --help"
                    else
                            echo "Instalando Apache con Ansible"
                            if ! command -v ansible &> /dev/null; then
                                echo "Instalando Ansible"
                                sudo apt update && sudo apt install -y ansible
                            fi
                            host="hosts.ini"
                    fi

#-------------------------------------------------------------------------------------------#
            elif [[ "$1" == "--docker" ]]; then
                    if (( $# != 1 )); then
                        echo "Has usado más argumentos de los necesarios chet"
                    else
                        echo "Iniciando Apache en un contenedor Docker"
                        DOCKER_IMG="jophes/my-apache-img" #Comprobar nombre
                        if ! command -v docker &> /dev/null; then #Comprobado que funcoina
                            echo "Docker no está instalado. Instalándolo..."
                            sudo apt update && sudo apt install -y docker.io
                            sudo systemctl enable --now docker
                        fi
                        if docker ps --format '{{.Names}}' | grep -q '^apache_container$'; then #Tengo que comprobar que funciona todavía
                            echo "Ya estás ejecutando un contenedor apache en Docker."
                            echo "Deja de ejecutarlo para poder usar el contenedor de este script"
                            echo "Deteniendo proceso."
                        else
                            echo "Descargando la imagen desde Docker Hub" #Comprobado que funcoina
                            echo "Se descargará la imagen de $DOCKER_IMG"
                            docker pull $DOCKER_IMG
                            docker run -d --name apache_container -p 8080:80 $DOCKER_IMG #Solo me ha funcionado el 8080, el 80 estaba ocupado
                            echo "Apache está siendo ejecutado con docker con la imagen $DOCKER_IMG."
                            echo "Puerto usado por defecto 8080:80"
                        fi
                    fi

           elif [[ "$1" == "--dkstop" ]]; then
                if (( $# != 1 )); then
                    echo "La sintaxis para --dkstop es incorrecta, consulta --help"
                else
                    echo "Deteniendo el contenedor de Apache en Docker..."
                    docker stop apache_container
                    echo "Contenedor detenido."
                fi
        fi
fi