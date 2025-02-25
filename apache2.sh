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
fi