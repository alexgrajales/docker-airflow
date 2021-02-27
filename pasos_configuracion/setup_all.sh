cd ~/
sudo yum update -y
sudo amazon-linux-extras install docker -yqq
---------------------------------------------
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo systemctl start docker
sudo service docker start
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo docker-compose version
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
sudo yum install git -yqq
mkdir imagenes
cd imagenes
git clone https://github.com/puckel/docker-airflow.git
cd docker-airflow
sudo docker-compose -f docker-compose-LocalExecutor.yml down
sudo docker-compose -f docker-compose-LocalExecutor.yml up -d
sudo docker-compose -f docker-compose-LocalExecutor.yml down
cd ~/
cd imagenes
mkdir docker-airflow-custom
cd docker-airflow-custom
git clone https://github.com/alexgrajales/docker-airflow.git
cd docker-airflow
sudo docker-compose -f docker-compose-CeleryExecutor.yml down
sudo docker-compose -f docker-compose-CeleryExecutor.yml up --force-recreate --build -d
sudo yum install python37 -yqq
cd ~/
mkdir venv
cd venv
python3 -m venv dbt
python3 -m venv move_files
source dbt/bin/activate
pip install dbt
dbt debug --config-dir
cd ~
git clone https://github.com/alexgrajales/dbt.git
mkdir .dbt
cat ~/imagenes/docker-airflow-custom/docker-airflow/pasos_configuracion/profiles.yml > ~/.dbt/profiles.yml
cd ~
---------------------------------------------
sudo docker run -d -p 3000:3000 \
-v ~/metabase-data:/metabase-data \
-e "MB_DB_FILE=/metabase-data/metabase.db" \
--name metabase metabase/metabase
---------------------------------------------
sudo yum install postgresql postgresql-server -yqq
cd ~
mkdir dowload_files
cd dowload_files
git clone https://github.com/alexgrajales/uploads_files.git
source /home/ec2-user/venv/move_files/bin/activate
cd uploads_files/
pip install -r requirements.txt
(echo "access_key=''"; echo "secret_key=''"; echo "bucket='nombrebukect'") > settings.py
---------------------------------------------
cd ~
mkdir .aws
cd .aws
(echo "[default]"; echo "aws_access_key_id="; echo "aws_secret_access_key=") > credentials
(echo "[default]"; echo "region=us-west-2"; echo "output=json") > config
---------------------------------------------
sudo docker exec -it docker-airflow_worker_1 /bin/bash
cd keys
ssh-keygen -f my_rsa_key
exit
cat /home/ec2-user/imagenes/docker-airflow-custom/docker-airflow/keys/my_rsa_key.pub >> /home/ec2-user/.ssh/authorized_keys
---------------------------------------------
source ~/venv/dbt/bin/activate
cd ~/dbt/datawarehouse
dbt docs generate --vars "{'schema': 'sandbox'}"
nohup dbt docs serve --port 8001
----------------------------------------------
PGPASSWORD="" psql --host  --port 5432 --username postgres
\l
CREATE database datawarehouse
\c datawarehouse;
CREATE SCHEMA datawarehouse;
CREATE SCHEMA sandbox;
CREATE TABLE sandbox.data_covid (
    "fecha reporte web" varchar(100),
    "ID de caso" varchar(100),
    "Fecha de notificación" varchar(100),
    "Código DIVIPOLA departamento" varchar(100),
    "Nombre departamento" varchar(100),
    "Código DIVIPOLA municipio" varchar(100),
    "Nombre municipio" varchar(100),
    "Edad" varchar(100),
    "Unidad de medida de edad" varchar(100) ,
    "Sexo" varchar(100),
    "Tipo de contagio" varchar(100),
    "Ubicación del caso" varchar(100),
    "Estado" varchar(100),
    "Código ISO del país" varchar(100),
    "Nombre del país" varchar(100),
    "Recuperado" varchar(100),
    "Fecha de inicio de síntomas" varchar(100),
    "Fecha de muerte" varchar(100),
    "Fecha de diagnóstico" varchar(100),
    "Fecha de recuperación" varchar(100),
    "Tipo de recuperación" varchar(100),
    "Pertenencia étnica" varchar(100),
    "Nombre del grupo étnico" varchar(100)
);
CREATE TABLE sandbox.data_ciudades (
    "Código Departamento" varchar(100),
    "Nombre Departamento" varchar(100),
    "Código Municipio" varchar(100),
    "Nombre Municipio" varchar(100)
);
CREATE TABLE sandbox.data_covid_uci_bogota(
    "Fecha" varchar(1000),
    "Camas UCI ocupadas Covid-19" varchar(1000),
    "Total camas UCI COVID 19 reportadas por IPS" varchar(1000),
    "Ocupación UCI COVID 19" varchar(1000)
);

SELECT * FROM pg_catalog.pg_tables;

1. permisos puertos
2. usuario ec2
3. variables y coexion ariflow
4. archivo configuracion aws
5. dbt profile
