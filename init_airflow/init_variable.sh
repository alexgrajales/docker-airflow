#!/usr/bin/env bash
airflow initdb
airflow connections -d --conn_id 'ssh_ec2'
airflow connections -d --conn_id 's3_conection'
airflow connections -a --conn_id 'ssh_ec2' --conn_type 'ssh' --conn_login 'ec2-user' --conn_password '' --conn_host '' --conn_port '22' --conn_extra "{\"key_file\": \"/keys/my_rsa_key\", \"no_host_key_check\": true}"
{"key_file": "/usr/local/airflow/keys/my_rsa_key", "no_host_key_check": true}
airflow connections -a --conn_id 's3_conection' --conn_type 's3' --conn_login '' --conn_password '' --conn_host '' --conn_port '' --conn_extra "{\"aws_access_key_id\":\"_your_aws_access_key_id_\", \"aws_secret_access_key\": \"_your_aws_secret_access_key_\"}"
{"aws_access_key_id":"_your_aws_access_key_id_", "aws_secret_access_key": "_your_aws_secret_access_key_"}
airflow variables -i /usr/local/airflow/init_airflow/variable.json
