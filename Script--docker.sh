#No se si va a joder al de lo que habreis puesto en ell Script, comentadme las líneas que puedan ser problemáticas

elif [[ "$1" == "--docker" ]]; then
    if (( $# != 1 )); then
        echo "La sintaxis para --docker es incorrecta, consulte --help"
    else
        echo "Iniciando Apache en un contenedor Docker desde tu imagen personalizada..."

        DOCKER_IMG="jophes/my-apache-img"

        # Si docker no está instalado lo va a instalar, si lo está pues nada, sigue.
        if ! command -v docker &> /dev/null; then
            echo "Docker no está instalado. Instalándolo..."
            sudo apt update && sudo apt install -y docker.io
            sudo systemctl enable --now docker
        fi

        # Esto es pra saber si ya esta usando apache en dock
        if docker ps --format '{{.Names}}' | grep -q '^apache_container$'; then
            echo "El contenedor Apache ya está en ejecución."
        else
            # Descargar la última versión de la imagen desde Docker Hub
            echo "Descargando la imagen desde Docker Hub..."
            docker pull $DOCKER_IMG

            # Ejecuta el contenedor con tu imagen personalizada
            docker run -d --name apache_container -p 8080:80 $DOCKER_IMG
            echo "Apache esta siendo ejecutado con docker con la imagen $DOCKER_IMG."
            echo "Puerto usado por defecto 8080:80"
        fi
    fi
