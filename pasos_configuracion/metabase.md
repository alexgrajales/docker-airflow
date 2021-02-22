# Imagen docker metabase https://www.metabase.com/docs/latest/operations-guide/running-metabase-on-docker.html
descargar la imagen de metabase en docker
docker run -d -p 3000:3000 \
-v ~/metabase-data:/metabase-data \
-e "MB_DB_FILE=/metabase-data/metabase.db" \
--name metabase metabase/metabase
# abrir el navegador web con el host:3000
se ingresa la informaciòn requerida y en la base de datos se coloca la base de datos creada en rds
# navegar en el menu de administrador
# revisar el data source de prueba