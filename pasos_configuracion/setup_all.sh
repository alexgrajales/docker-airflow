sudo yum update -y
sudo amazon-linux-extras install docker
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
sudo yum install git -y
mkdir imagenes
cd imagenes
git clone https://github.com/puckel/docker-airflow.git
cd docker-airflow
docker-compose -f docker-compose-LocalExecutor.yml up -d
docker-compose -f docker-compose-LocalExecutor.yml down
cd
cd imagenes
mkdir docker-airflow-custom
cd docker-airflow-custom
git clone https://github.com/alexgrajales/docker-airflow.git
cd docker-airflow
docker-compose -f docker-compose-CeleryExecutor.yml up -d
docker exec -it docker-airflow_worker_1 /bin/bash
cd keys
ssh-keygen -q -t rsa -N '' -f ./keys/my_rsa_key
exit
cat my_rsa_key.pub >> ~/.ssh/authorized_keys
sudo yum install python37
cd ~/
mkdir venv
cd venv
python3 -m venv dbt
python3 -m venv move_files
source dbt/bin/activate
pip install dbt
dbt debug --config-dir
mkdir ~/.dbt
cd ~/.dbt
cat ~/imagenes/docker-airflow-custom/docker-airflow/pasos_configuracion/profile.yml > profile.yml
cd ~

docker run -d -p 3000:3000 \
-v ~/metabase-data:/metabase-data \
-e "MB_DB_FILE=/metabase-data/metabase.db" \
--name metabase metabase/metabase