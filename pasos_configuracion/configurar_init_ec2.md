# configurar conexion ssh y repo airflow custom
1. cd imagenes
2. mkdir docker-airflow-custom
3. cd docker-airflow-custom
4. git clone https://github.com/alexgrajales/docker-airflow.git
5. cd docker-airflow
6. docker-compose -f docker-compose-CeleryExecutor.yml up -d
7. docker exec -it docker-airflow_worker_1 /bin/bash
8. cd keys
9. ssh-keygen -t rsa -f my_rsa_key
10. exit
10. copiar la clave publica del contenedor en el host (cat my_rsa_key.pub copiar el contenido en /home/ec2-user/.ssh/authorized_keys)
