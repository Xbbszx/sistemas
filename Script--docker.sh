#!/bin/bash
if [[ $EUID -ne 0 ]]; then
        echo "Ejecuta el script como root. Usa:"
        echo "sudo ./apache2.sh --[variable]"
        exit 1
else
        if [[ -z $1 ]]; then
                echo "Utilice los parametros correctos: --help para ver la información de los comandos"
                else
                if [[ "$1" == "--help" ]]; then
                        echo "La sintaxis para usar este script es ./apache2.sh --[variable]"
                        echo "Solo se adminten las variables listadas:"
                        echo "Si quieres ver los DATOS DE RED de tu equipo utiliza --network"
                        echo "Si quieres INSTALAR SOLAMENTE apache utiliza los siquientes parámetros:"
                        echo "   Para instalar Apache con comandos utiliza --install"
                        echo "   Para instalar Apache con Ansible utiliza --ansible"
                        echo "   Para instalar Apache con Docker utiliza --docker para iniciar y --dkstop para detener el contenedor"
                        echo "Si quieres CONFIGURAR el servicio apache utiliza --config"
                        echo "Si quieres ver los LOGS puedes usar --logs"
                        echo "Si quieres DETENER el servicio apache utiliza --stop"
                        echo "Si quieres INICIAR el servicio apache utiliza --start"
                        echo "Si quieres ver el ESTADO del servicio apache utiliza --status"
                        echo "Si quieres REINICIAR el servicio apache utiliza --restart"
                        echo "Si quieres DESINSTALAR el servicio apache utiliza --uninstall"
                elif [[ "$1" == "--network" ]]; then
                        if [[ $# !=  1 ]]; then
                                echo "La sintaxis para --network es incorrecta, consulte --help"
                        else
                                INTERFACE=$(ip route | grep default | cut -d' ' -f5)
                                IP_ADDRESS=$(ip -o -4 addr show "$INTERFACE" | grep inet | cut -d' ' -f7 | cut -d'/' -f1)
                                MAC_ADDRESS=$(cat /sys/class/net/"$INTERFACE"/address)
                                GATEWAY=$(ip route | grep default | cut -d' ' -f3)
                                DNS_SERVERS=$(grep "nameserver" /etc/resolv.conf | cut -d' ' -f2)
                                HOSTNAME=$(hostname)
                                DOMAIN=$(hostname -d 2>/dev/null)
                                echo "Datos de Red del equipo:"
                                echo "Interfaz de Red:       $INTERFACE"
                                echo "Dirección IP:          $IP_ADDRESS"
                                echo "Dirección MAC:         $MAC_ADDRESS"
                                echo "Puerta de Enlace:      $GATEWAY"
                                echo "Servidores DNS:        $DNS_SERVERS"
                                echo "Nombre del Host:       $HOSTNAME"
                                echo "Dominio:               ${DOMAIN:-No configurado}"
                        fi
                elif [[ "$1" == "--install" ]]; then
                        if [[ $# !=  1 ]]; then
                                echo "La sintaxis para --install es incorrecta, consulte --help"
                        else
                                sudo apt install apache2 -y
                        fi
                elif [[ "$1" == "--logs" ]]; then
                        if [[ $# !=  1 ]]; then
                                echo "La sintaxis para --logs es incorrecta, consulte --help"
                        else
                                journalctl -u apache2 --no-pager
                        fi
                elif [[ "$1" == "--stop" ]]; then
                        if [[ $# !=  1 ]]; then
                                echo "La sintaxis para --stop es incorrecta, consulte --help"
                        else
                                sudo systemctl stop apache2
                        fi
                elif [[ "$1" == "--start" ]]; then
                        if [[ $# !=  1 ]]; then
                                echo "La sintaxis para --start es incorrecta, consulte --help"
                        else
                                sudo systemctl start apache2
                        fi
                elif [[ "$1" == "--restart" ]]; then
                        if [[ $# !=  1 ]]; then
                                echo "La sintaxis para --restart es incorrecta, consulte --help"
                        else
                                sudo systemctl restart apache2
                        fi
                elif [[ "$1" == "--uninstall" ]]; then
                        if [[ $# !=  1 ]]; then
                                echo "La sintaxis para --uninstall es incorrecta, consulte --help"
                        else
                                sudo apt remove apache2 -y
                        fi
                elif [[ "$1" == "--status" ]]; then
                        if [[ $# !=  1 ]]; then
                                echo "La sintaxis para --status es incorrecta, consulte --help"
                        else
                                sudo systemctl status apache2
                        fi
                elif [[ "$1" == "--config" ]]; then
                        if [[ $# !=  1 ]]; then
                                echo "La sintaxis para --config es incorrecta, consulte --help"
                        else
                                sudo touch midominio.conf
                                echo "<VirtualHost *:80>" | sudo tee midominio.conf
                                echo "ServerName Ejemplo" | sudo tee -a midominio.conf
                                echo "ServerAlias Ejemplo" | sudo tee -a midominio.conf
                                echo "DocumentRoot /var/www/config" | sudo tee -a midominio.conf
                                echo "DirectoryIndex index.html" | sudo tee -a midominio.conf
                                echo "</VirtualHost>" | sudo tee -a midominio.conf
                                sudo mv midominio.conf /etc/apache2/sites-available/midominio.conf
                                sudo cd /etc/apache2/sites-available
                                sudo a2dissite ./000-default.conf
                                sudo a2ensite ./midominio.conf
                                cd ~
                                echo "1. Cambiar el puerto de Apache"
                                echo "2. Cambiar dominio principal"
                                echo "3. Cambiar el alias de servidor"
                                echo "4. Añadir carpeta con página web"
                                read -p "Escribe en número para elegir la opción: " opcion
                                if [[ $opcion == "1" ]]; then
                                        read -p "Dime que puerto quieres que tenga apache: " puerto
                                        sudo sed -i "s/^Listen [0-9]\+/Listen $puerto/" /etc/apache2/ports.conf
                                        sudo sed -i "s/<VirtualHost *:[0-9]\+>/<VirtualHost *:$puerto>/" /etc/apache2/sites-available/midominio.conf
                                        sudo ufw allow $puerto/tcp
                                        echo "Debes reiniciar Apache para aplicar cambios, recuerda usar --restart"
                                elif [[ $opcion == "2" ]]; then
                                        read -p "Indicame que nombre quieres que tenga el dominio: " domi
                                        sudo sed -i "s/ServerName .*/ServerName $domi/" /etc/apache2/sites-available/midominio.conf
                                elif [[ $opcion == "3" ]]; then
                                        read -p "Indicame que nombre quieres que tenga el Alias: " alias
                                        sudo sed -i "s/ServerAlias.*/ServerAlias $alias/" /etc/apache2/sites-available/midominio.conf
                                elif [[ $opcion == "4" ]]; then
                                        read -p "Indicame la ruta absoluta de la carpeta donde tienes tu index: " ruta
                                        mv $ruta /var/www/config
                                else
                                        echo "Esa opción no es válida"
                                fi
                        fi
                elif [[ "$1" == "--ansible" ]]; then
                        if [[ $# !=  1 ]]; then
                                echo "La sintaxis para --ansible es incorrecta, consulte --help"
                        else
                                if ! command -v ansible >/dev/null 2>&1; then
                                        echo "Ansible no está instalado. Iniciando instalación"
                                        apt update && apt install -y ansible
                                        if [[ $? -ne 0 ]]; then
                                        echo "Error al instalar Ansible." >&2
                                        exit 1
                                        fi
                                else
                                        echo "Ansible ya está instalado."
                                fi

                                PLAYBOOK_PATH="/tmp/install_apache.yml"

                                echo "Creando playbook en $PLAYBOOK_PATH..."

                                cat > "$PLAYBOOK_PATH" <<EOF
---
- name: Instalar Apache en Ubuntu
  hosts: localhost
  connection: local
  become: yes

  tasks:
    - name: Actualizar caché de paquetes
      apt:
        update_cache: yes

    - name: Instalar Apache
      apt:
        name: apache2
        state: present

    - name: Iniciar y habilitar Apache
      systemd:
        name: apache2
        state: started
        enabled: yes
EOF

                                echo "Ejecutando playbook..."
                                ansible-playbook "$PLAYBOOK_PATH"

                                if [[ $? -ne 0 ]]; then
                                        echo "Error al ejecutar el playbook." >&2
                                        exit 1
                                fi

                                echo "Apache instalado correctamente en localhost usando Ansible."
                        fi

        #-------------------------------------------------------------------------------------------#
                elif [[ "$1" == "--docker" ]]; then
                        if (( $# != 1 )); then
                                echo "La sintaxis para --docker es incorrecta, consulte --help"
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
fi