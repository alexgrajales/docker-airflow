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
11. sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
12. sudo chmod +x /usr/local/bin/docker-compose
13. ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
14. docker-compose --version
# instalar git
15. sudo yum install git -y 
# descargar imagen de airflow
16. mkdir imagenes
17. cd imagenes
18. git clone https://github.com/puckel/docker-airflow.git
19. cd docker-airflow 
20. docker-compose -f docker-compose-LocalExecutor.yml up -d
# permisos entrada EC2    
21. ingresar al grupo de seguridad de la ec2 y dar permisos de entrada por el puerto 8080, 5555 y 3000
# Configurar docker para subir al iniciar la ec2
22. sudo systemctl enable docker.service
23. sudo systemctl enable containerd.service