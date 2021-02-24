# ingresar al contendor
sudo docker exec -it nombre_contendor /bin/bash 
# eliminar imagenes y volumenes
docker system prune -a --volumes 
# recrear contenedor
docker-compose -f docker-compose-CeleryExecutor.yml up --force-recreate --build -d