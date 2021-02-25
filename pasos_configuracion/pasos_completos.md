# SESION 1 AIRFLOW
# Configuracion Docker en imagen aws linux
1. crear ec2 type medium 
3. Decargar cliente ssh https://mobaxterm.mobatek.net/?gclid=EAIaIQobChMIgcXi1pTt7gIVlqCGCh0ifQDOEAAYASAAEgKHQfD_BwE
2. Conectarse por medio de ssh tomando el host de aws y el usuario ec2-user, recordar en opciones avanzadas colocar el .pem
3. si es linux por medio de la terminal ssh -i /home/alex/Descargas/aws_fabio.pem ec2-user@ec2-54-242-221-8.compute-1.amazonaws.com, recordar que en el archivo .pem debe de tener estos permisos sudo chmod 400 /home/alex/Descargas/aws_fabio.pem 
# docker https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html
4. sudo yum update -y # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html actualizar el sistema 
5. sudo amazon-linux-extras install docker # instalar docker
6. sudo service docker start #inicializar el servicio
7. sudo usermod -a -G docker ec2-user #permisos
8. sudo systemctl start docker
9. sudo service docker start
10. sudo docker-compose version
# docker compose https://acloudxpert.com/how-to-install-docker-compose-on-amazon-linux-ami/
11. sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
12. sudo chmod +x /usr/local/bin/docker-compose
13. sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
14. docker-compose --version
# instalar git
15. sudo yum install git -y 
# descargar imagen de airflow
16. mkdir imagenes
17. cd imagenes
18. git clone https://github.com/puckel/docker-airflow.git
19. cd docker-airflow 
20. docker-compose -f docker-compose-LocalExecutor.yml up -d

# configurar conexion ssh y repo airflow custom
1. cd imagenes
2. mkdir docker-airflow-custom
3. cd docker-airflow-custom
4. git clone https://github.com/alexgrajales/docker-airflow.git
5. cd docker-airflow
6. docker-compose -f docker-compose-CeleryExecutor.yml up -d # para bajar los contenedores(docker-compose -f docker-compose-CeleryExecutor.yml down)
7. docker exec -it docker-airflow_worker_1 /bin/bash
8. cd keys
9. ssh-keygen -t rsa -f my_rsa_key
10. exit
10. copiar la clave publica del contenedor en el host (cat my_rsa_key.pub copiar el contenido en /home/ec2-user/.ssh/authorized_keys)


# permisos entrada EC2    
21. ingresar al grupo de seguridad de la ec2 y dar permisos de entrada por el puerto 8080, 5555 y 3000
# Configurar docker para subir al iniciar la ec2
22. sudo systemctl enable docker.service
23. sudo systemctl enable containerd.service


# SESION 2 DBT
# Instalar python 3.7  https://docs.aws.amazon.com/es_es/elasticbeanstalk/latest/dg/eb-cli3-install-linux.html
python --version
sudo yum install python37
#Crear entorno virtual con virtual env python3 -m venv my_app/env 
mkdir venv
cd venv
python3 -m venv dbt
python3 -m venv move_files
#Activar el entorno e instalar dbt pip install dbt https://docs.getdbt.com/dbt-cli/installation/
source dbt/bin/activate
pip install dbt
# Configurar el profile dbt debug --config-dir  https://docs.getdbt.com/dbt-cli/configure-your-profile
dbt debug --config-dir
mkdir ~/.dbt
cd ~/.dbt
vi profile.yml
vamos y editamos el contenido con (recordar correo enviado)
datawarehouse:
  target: dev
  outputs:
    dev:
      type: postgres
      host: host_rds
      user: usuario_rds
      pass: pass_rds
      port: 5432
      dbname: datawarehouse
      schema: public
      threads: 4
sandbox:
  target: dev
  outputs:
    dev:
      type: postgres
      host: host_rds
      user: usuario_rds
      pass: pass_rds
      port: 5432
      dbname: sandbox
      schema: public
      threads: 4
* crear en postgres rds una base de datos de dev habilitar la conexion por fuera y acceso por medio de usuario y clave
* habilitar input desde el grupo de suguridad
# opciones 

# 1. Configurar el start project de dbt https://github.com/fishtown-analytics/dbt-starter-project  
se puede clonar el repo e iniciar
# 2. realizar el dbt init para iniciar con la configuracion https://docs.getdbt.com/tutorial/create-a-project-dbt-cli
se puede ejecutar el comando dbt init y se crea la configuracion inical
cd ~
mkdir dbt
cd dbt
dbt init datawarehouse
cd datawarehouse
dbt seed --profile sandbox
dbt run --profile sandbox

# SESION 3 metabase

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