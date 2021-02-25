cd ~/
sudo yum update -y
sudo amazon-linux-extras install docker -yqq
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
sudo docker-compose -f docker-compose-CeleryExecutor.yml down
cd keys
ssh-keygen -q -t rsa -N '' -f my_rsa_key
cat my_rsa_key.pub >> ~/.ssh/authorized_keys
sudo yum install python37 -yqq
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

sudo yum install postgresql postgresql-server -yqq
cd ~
mkdir dowload_files
cd dowload_files
git clone https://github.com/alexgrajales/uploads_files.git
source /home/ec2-user/venv/move_files/bin/activate
cd uploads_files/
pip install -r requirements.txt
(echo "access_key=''"; echo "secret_key=''"; echo "bucket='nombrebukect'") > settings.py
mkdir .aws
cd .aws
(echo "[default]"; echo "aws_access_key_id=AKIAIOSFODNN7EXAMPLE"; echo "aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY") > credentials
(echo "[default]"; echo "region=us-west-2"; echo "output=json") > config