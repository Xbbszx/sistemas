#!/bin/bash
if [[ -z $1 ]]; then
        echo "Utilice los parametros correctos: --help, --install, --logs"
    else
            if [[ "$1" == "--help" ]]; then
                    echo "Si quiere instalar solamente apache utilicé el parámetro --install"
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
            fi
fi