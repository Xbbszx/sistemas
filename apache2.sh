#!/bin/bash
if [[ -z $1 ]]; then
        echo "Utilice los parametros correctos: --help para ver la información de los comandos"
    else
            if [[ "$1" == "--help" ]]; then
                    echo "Si quiere instalar solamente apache utilicé el parámetro --install"
                    echo "Si quieres configurar el servicio apache utiliza --config"
                    echo "Si quieres ver los logs puedes usar --logs"
                    echo "Si quieres parar el servicio apache utiliza --stop"
                    echo "Si quieres iniciar el servicio apache utiliza --start"
                    echo "Si quieres ver el status el servicio apache utiliza --status"
                    echo "Si quieres reiniciar el servicio apache utiliza --restart"
                    echo "Si quieres desinstalar el servicio apache utiliza --uninstall"
            elif [[ "$1" == "--install" ]]; then
                    if [[ $# !=  1 ]]; then
                            echo "La sintaxis para -- es incorrecta, consulte --help"
                    else
                            sudo apt install apache2 -y
                            sudo touch midominio.conf
                            sudo echo "<VirtualHost *:80>" >> midominio.conf
                            sudo echo "ServerName Ejemplo" >> /midominio.conf
                            sudo echo "ServerAlias Ejemplo" >> midominio.conf
                            sudo echo "DocumentRoot /var/www/" >> midominio.conf
                            sudo echo "DirectoryIndex Ejemplo" >> midominio.conf
                            sudo echo "</VirtualHost>" >> midominio.conf
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
                            if [ $opcion == "1" ]; then
                                read -p "Dime que puerto quieres que tenga apache" puerto
                                sudo sed -i "s/^Listen [0-9]\+/Listen $puerto/" /etc/apache2/ports.conf
                                sudo sed -i "" /etc/apache2/
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
            #No se si va a joder al de lo que habreis puesto en ell Script, comentadme las líneas que puedan ser problemáticas

            elif [[ "$1" == "--docker" ]]; then
                    if (( $# != 1 )); then
                        echo "Has usado más argumentos de los necesarios chet"
                    else
                        echo "Iniciando Apache en un contenedor Docker"
                
                        DOCKER_IMG="jophes/my-apache-img"
                
                        # Si docker no está instalado lo va a instalar, si lo está pues nada, sigue.
                        if ! command -v docker &> /dev/null; then
                            echo "Docker no está instalado. Instalándolo..."
                            sudo apt update && sudo apt install -y docker.io
                            sudo systemctl enable --now docker
                        fi
                
                        # Esto es pra saber si ya esta usando apache en dock
                        if docker ps --format '{{.Names}}' | grep -q '^apache_container$'; then
                            echo "Ya estás aejecutando un contenedor apache en Docker."
                            echo "Deja de ejecutarlo para poder usar el contenedor de este script"
                            echo "Deteniendo proceso."
                        else
                            # Descargar la última versión de la imagen desde Docker Hub
                            echo "Descargando la imagen desde Docker Hub"
                            echo "Se descargará la imagen de $DOCKER_IMG"
                            docker pull $DOCKER_IMG
                
                            # Ejecuta el contenedor con tu imagen personalizada
                            docker run -d --name apache_container -p 8080:80 $DOCKER_IMG
                            echo "Apache esta siendo ejecutado con docker con la imagen $DOCKER_IMG."
                            echo "Puerto usado por defecto 8080:80"
                        fi
            fi


            
fi
